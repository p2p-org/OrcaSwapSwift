//
//  File.swift
//  
//
//  Created by Chung Tran on 06/05/2022.
//

import Foundation
import RxSwift
import SolanaSwift

private var balancesCache = [String: TokenAccountBalance]()
private let lock = NSLock()

extension Pools {
    func getPools(
        forRoute route: Route,
        fromTokenName: String,
        toTokenName: String,
        solanaClient: OrcaSwapSolanaClient
    ) -> Single<[Pool]> {
        guard route.count > 0 else {return .just([])}
        
        let requests = route.map {fixedPool(forPath: $0, solanaClient: solanaClient)}
        return Single.zip(requests).map {$0.compactMap {$0}}
            .map { pools in
                var pools = pools
                
                // modify orders
                if pools.count == 2 {
                    // reverse order of the 2 pools
                    // Ex: Swap from SOCN -> BTC, but paths are
                    // [
                    //     "BTC/SOL[aquafarm]",
                    //     "SOCN/SOL[stable][aquafarm]"
                    // ]
                    // Need to change to
                    // [
                    //     "SOCN/SOL[stable][aquafarm]",
                    //     "BTC/SOL[aquafarm]"
                    // ]
                    
                    if pools[0].tokenAName != fromTokenName && pools[0].tokenBName != fromTokenName {
                        let temp = pools[0]
                        pools[0] = pools[1]
                        pools[1] = temp
                    }
                }

                // reverse token A and token B in pool if needed
                for i in 0..<pools.count {
                    if i == 0 {
                        var pool = pools[0]
                        if pool.tokenAName.fixedTokenName != fromTokenName.fixedTokenName {
                            pool = pool.reversed
                        }
                        pools[0] = pool
                    }
                    
                    if i == 1 {
                        var pool = pools[1]
                        if pool.tokenBName.fixedTokenName != toTokenName.fixedTokenName {
                            pool = pool.reversed
                        }
                        pools[1] = pool
                    }
                }
                return pools
            }
    }
    
    private func fixedPool(
        forPath path: String, // Ex. BTC/SOL[aquafarm][stable]
        solanaClient: OrcaSwapSolanaClient
    ) -> Single<Pool?> {
        guard var pool = self[path] else {return .just(nil)}
        
        if path.contains("[stable]") {
            pool.isStable = true
        }
        
        // get balances
        let getBalancesRequest: Single<(TokenAccountBalance, TokenAccountBalance)>
        if let tokenABalance = pool.tokenABalance ?? balancesCache[pool.tokenAccountA],
           let tokenBBalance = pool.tokenBBalance ?? balancesCache[pool.tokenAccountB]
        {
            getBalancesRequest = .just((tokenABalance, tokenBBalance))
        } else {
            getBalancesRequest = Single.zip(
                solanaClient.getTokenAccountBalance(pubkey: pool.tokenAccountA, commitment: nil),
                solanaClient.getTokenAccountBalance(pubkey: pool.tokenAccountB, commitment: nil)
            )
        }
        
        return getBalancesRequest
            .do(onSuccess: {
                lock.lock()
                balancesCache[pool.tokenAccountA] = $0
                balancesCache[pool.tokenAccountB] = $1
                lock.unlock()
            })
            .map {tokenABalane, tokenBBalance in
                pool.tokenABalance = tokenABalane
                pool.tokenBBalance = tokenBBalance
                
                return pool
            }
    }
}

public extension PoolsPair {
    func constructExchange(
        tokens: [String: TokenValue],
        solanaClient: OrcaSwapSolanaClient,
        owner: Account,
        fromTokenPubkey: String,
        intermediaryTokenAddress: String? = nil,
        toTokenPubkey: String?,
        amount: Lamports,
        slippage: Double,
        feePayer: PublicKey?,
        minRenExemption: Lamports
    ) -> Single<(AccountInstructions, Lamports /*account creation fee*/)> {
        guard count > 0 && count <= 2 else {return .error(OrcaSwapError.invalidPool)}
        
        if count == 1 {
            // direct swap
            return self[0]
                .constructExchange(
                    tokens: tokens,
                    solanaClient: solanaClient,
                    owner: owner,
                    fromTokenPubkey: fromTokenPubkey,
                    toTokenPubkey: toTokenPubkey,
                    amount: amount,
                    slippage: slippage,
                    feePayer: feePayer,
                    minRenExemption: minRenExemption
                )
                .map {($0.0, $0.1)}
        } else {
            // transitive swap
            guard let intermediaryTokenAddress = intermediaryTokenAddress else {
                return .error(OrcaSwapError.intermediaryTokenAddressNotFound)
            }

            return self[0]
                .constructExchange(
                    tokens: tokens,
                    solanaClient: solanaClient,
                    owner: owner,
                    fromTokenPubkey: fromTokenPubkey,
                    toTokenPubkey: intermediaryTokenAddress,
                    amount: amount,
                    slippage: slippage,
                    feePayer: feePayer,
                    minRenExemption: minRenExemption
                )
                .flatMap { pool0AccountInstructions, pool0AccountCreationFee -> Single<(AccountInstructions, Lamports /*account creation fee*/)> in
                    guard let amount = try self[0].getMinimumAmountOut(inputAmount: amount, slippage: slippage)
                    else {throw OrcaSwapError.unknown}
                    
                    return self[1].constructExchange(
                        tokens: tokens,
                        solanaClient: solanaClient,
                        owner: owner,
                        fromTokenPubkey: intermediaryTokenAddress,
                        toTokenPubkey: toTokenPubkey,
                        amount: amount,
                        slippage: slippage,
                        feePayer: feePayer,
                        minRenExemption: minRenExemption
                    )
                        .map {pool1AccountInstructions, pool1AccountCreationFee in
                            (.init(
                                account: pool1AccountInstructions.account,
                                instructions: pool0AccountInstructions.instructions + pool1AccountInstructions.instructions,
                                cleanupInstructions: pool0AccountInstructions.cleanupInstructions + pool1AccountInstructions.cleanupInstructions,
                                signers: pool0AccountInstructions.signers + pool1AccountInstructions.signers
                            ), pool0AccountCreationFee + pool1AccountCreationFee)
                        }
                }
                .map {($0.0, $0.1)}
        }
    }
}

extension Pool {
    func constructExchange(
        tokens: [String: TokenValue],
        solanaClient: OrcaSwapSolanaClient,
        owner: Account,
        fromTokenPubkey: String,
        toTokenPubkey: String?,
        amount: Lamports,
        slippage: Double,
        feePayer: PublicKey?,
        minRenExemption: Lamports
    ) -> Single<(AccountInstructions, Lamports /*account creation fee*/)> {
        guard let fromMint = try? tokens[tokenAName]?.mint.toPublicKey(),
              let toMint = try? tokens[tokenBName]?.mint.toPublicKey(),
              let fromTokenPubkey = try? fromTokenPubkey.toPublicKey()
        else {return .error(OrcaSwapError.notFound)}
        
        // Create fromTokenAccount when needed
        let prepareSourceRequest: Single<AccountInstructions>
        
        if fromMint == .wrappedSOLMint &&
            owner.publicKey == fromTokenPubkey
        {
            prepareSourceRequest = solanaClient.prepareCreatingWSOLAccountAndCloseWhenDone(
                from: owner.publicKey,
                amount: amount,
                payer: feePayer ?? owner.publicKey
            )
        } else {
            prepareSourceRequest = .just(.init(account: fromTokenPubkey))
        }
        
        // If necessary, create a TokenAccount for the output token
        let prepareDestinationRequest: Single<AccountInstructions>
        
        // If destination token is Solana, create WSOL if needed
        if toMint == .wrappedSOLMint {
            if let toTokenPubkey = try? toTokenPubkey?.toPublicKey(),
               toTokenPubkey != owner.publicKey
            {
                // wrapped sol has already been created, just return it, then close later
                prepareDestinationRequest = .just(
                    .init(
                        account: toTokenPubkey,
                        cleanupInstructions: [
                            TokenProgram.closeAccountInstruction(
                                account: toTokenPubkey,
                                destination: owner.publicKey,
                                owner: owner.publicKey
                            )
                        ]
                    )
                )
            } else {
                // create wrapped sol
                prepareDestinationRequest = solanaClient.prepareCreatingWSOLAccountAndCloseWhenDone(
                    from: owner.publicKey,
                    amount: 0,
                    payer: feePayer ?? owner.publicKey
                )
            }
        }
        
        // If destination is another token and has already been created
        else if let toTokenPubkey = try? toTokenPubkey?.toPublicKey() {
            prepareDestinationRequest = .just(.init(account: toTokenPubkey))
        }
        
        // Create associated token address
        else {
            prepareDestinationRequest = solanaClient.prepareForCreatingAssociatedTokenAccount(
                owner: owner.publicKey,
                mint: toMint,
                feePayer: feePayer ?? owner.publicKey,
                closeAfterward: false
            )
        }
        
        // Combine request
        return Single.zip(
            prepareSourceRequest,
            prepareDestinationRequest
        )
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .map { sourceAccountInstructions, destinationAccountInstructions in
                // form instructions
                var instructions = [TransactionInstruction]()
                var cleanupInstructions = [TransactionInstruction]()
                var accountCreationFee: UInt64 = 0
                
                // source
                instructions.append(contentsOf: sourceAccountInstructions.instructions)
                cleanupInstructions.append(contentsOf: sourceAccountInstructions.cleanupInstructions)
                if !sourceAccountInstructions.instructions.isEmpty {
                    accountCreationFee += minRenExemption
                }
                
                // destination
                instructions.append(contentsOf: destinationAccountInstructions.instructions)
                cleanupInstructions.append(contentsOf: destinationAccountInstructions.cleanupInstructions)
                if !destinationAccountInstructions.instructions.isEmpty {
                    accountCreationFee += minRenExemption
                }
                
                // swap instructions
                guard let minAmountOut = try? getMinimumAmountOut(inputAmount: amount, slippage: slippage)
                else {throw OrcaSwapError.couldNotEstimatedMinimumOutAmount}
                
                let swapInstruction = try createSwapInstruction(
                    userTransferAuthorityPubkey: owner.publicKey,
                    sourceTokenAddress: sourceAccountInstructions.account,
                    destinationTokenAddress: destinationAccountInstructions.account,
                    amountIn: amount,
                    minAmountOut: minAmountOut
                )
                
                instructions.append(swapInstruction)
                
                var signers = [Account]()
                signers.append(contentsOf: sourceAccountInstructions.signers)
                signers.append(contentsOf: destinationAccountInstructions.signers)
                
                return (.init(
                    account: destinationAccountInstructions.account,
                    instructions: instructions,
                    cleanupInstructions: cleanupInstructions,
                    signers: signers
                ), accountCreationFee)
            }
    }
}

private extension String {
    /// Convert  SOL[aquafarm] to SOL
    var fixedTokenName: String {
        components(separatedBy: "[").first!
    }
}
