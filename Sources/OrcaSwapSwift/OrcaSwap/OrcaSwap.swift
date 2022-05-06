//
//  OrcaSwap.swift
//
//
//  Created by Chung Tran on 13/10/2021.
//

import Foundation
import RxSwift
import SolanaSwift

private var cache: SwapInfo?

public protocol OrcaSwapType {
    func load() -> Completable
    func getMint(tokenName: String) -> String?
    func findPosibleDestinationMints(fromMint: String) throws -> [String]
    func getTradablePoolsPairs(fromMint: String, toMint: String) -> Single<[PoolsPair]>
    func findBestPoolsPairForInputAmount(_ inputAmount: UInt64,from poolsPairs: [PoolsPair]) throws -> PoolsPair?
    func findBestPoolsPairForEstimatedAmount(_ estimatedAmount: UInt64,from poolsPairs: [PoolsPair]) throws -> PoolsPair?
    func getLiquidityProviderFee(
        bestPoolsPair: PoolsPair?,
        inputAmount: Double?,
        slippage: Double
    ) throws -> [UInt64]
    func getNetworkFees(
        myWalletsMints: [String],
        fromWalletPubkey: String,
        toWalletPubkey: String?,
        bestPoolsPair: PoolsPair?,
        inputAmount: Double?,
        slippage: Double,
        lamportsPerSignature: UInt64,
        minRentExempt: UInt64
    ) throws -> Single<SolanaSDK.FeeAmount>
    func prepareForSwapping(
        fromWalletPubkey: String,
        toWalletPubkey: String?,
        bestPoolsPair: PoolsPair,
        amount: Double,
        feePayer: PublicKey?, // nil if the owner is the fee payer
        slippage: Double
    ) -> Single<([PreparedSwapTransaction], String?)>
    func swap(
        fromWalletPubkey: String,
        toWalletPubkey: String?,
        bestPoolsPair: PoolsPair,
        amount: Double,
        slippage: Double,
        isSimulation: Bool
    ) -> Single<SwapResponse>
}

public class OrcaSwap: OrcaSwapType {
    // MARK: - Properties
    let apiClient: OrcaSwapAPIClient
    let solanaClient: OrcaSwapSolanaClient
    let accountProvider: OrcaSwapAccountProvider
    let notificationHandler: OrcaSwapSignatureConfirmationHandler
    
    var info: SwapInfo?
    private let lock = NSLock()
    
    // MARK: - Initializer
    public init(
        apiClient: OrcaSwapAPIClient,
        solanaClient: OrcaSwapSolanaClient,
        accountProvider: OrcaSwapAccountProvider,
        notificationHandler: OrcaSwapSignatureConfirmationHandler
    ) {
        self.apiClient = apiClient
        self.solanaClient = solanaClient
        self.accountProvider = accountProvider
        self.notificationHandler = notificationHandler
    }
    
    // MARK: - Methods
    /// Prepare all needed infos for swapping
    public func load() -> Completable {
        if info != nil {return .empty()}
        return Single.zip(
            apiClient.getTokens(),
            apiClient.getPools(),
            apiClient.getProgramID()
        )
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .map { tokens, pools, programId -> SwapInfo in
                let routes = findAllAvailableRoutes(tokens: tokens, pools: pools)
                let tokenNames = tokens.reduce([String: String]()) { result, token in
                    var result = result
                    result[token.value.mint] = token.key
                    return result
                }
                return .init(
                    routes: routes,
                    tokens: tokens,
                    pools: pools,
                    programIds: programId,
                    tokenNames: tokenNames
                )
            }
            .do(onSuccess: {[weak self] info in
                self?.lock.lock()
                self?.info = info
                self?.lock.unlock()
            })
            .asCompletable()
    }
    
    /// Get token's mint address by its name
    public func getMint(tokenName: String) -> String? {
        info?.tokenNames.first(where: {$0.value == tokenName})?.key
    }
    
    /// Find posible destination tokens by mint
    /// - Parameter fromMint: from token mint
    /// - Returns: List of token mints that can be swapped to
    public func findPosibleDestinationMints(
        fromMint: String
    ) throws -> [String] {
        guard let fromTokenName = getTokenFromMint(fromMint)?.name
        else {throw OrcaSwapError.notFound}
        
        let routes = try findRoutes(fromTokenName: fromTokenName, toTokenName: nil)
        return routes.keys.compactMap {$0.components(separatedBy: "/")
            .first(where: {!$0.contains(fromTokenName)})}
            .unique
            .compactMap {info?.tokens[$0]?.mint}
    }
    
    /// Get all tradable pools pairs for current token pair
    /// - Returns: route and parsed pools
    public func getTradablePoolsPairs(
        fromMint: String,
        toMint: String
    ) -> Single<[PoolsPair]> {
        guard let fromTokenName = getTokenFromMint(fromMint)?.name,
              let toTokenName = getTokenFromMint(toMint)?.name,
              let currentRoutes = try? findRoutes(fromTokenName: fromTokenName, toTokenName: toTokenName)
                .first?.value
        else {return .just([])}
        
        // retrieve all routes
        let requests: [Single<[Pool]>] = currentRoutes.compactMap {
            guard $0.count <= 2 else {return nil} // FIXME: Support more than 2 paths later
            return info?.pools.getPools(
                forRoute: $0,
                fromTokenName: fromTokenName,
                toTokenName: toTokenName,
                solanaClient: solanaClient
            )
        }
        
        return Single.zip(requests)
    }
    
    /// Find best pool to swap from input amount
    public func findBestPoolsPairForInputAmount(
        _ inputAmount: UInt64,
        from poolsPairs: [PoolsPair]
    ) throws -> PoolsPair? {
//        var poolsPairs = poolsPairs
//
//        // filter out deprecated pools
//        let indeprecatedPools = poolsPairs.filter {!$0.contains(where: {$0.deprecated == true})}
//        if indeprecatedPools.count > 0 {
//            poolsPairs = indeprecatedPools
//        }
        
        guard poolsPairs.count > 0 else {return nil}
        
        var bestPools: [Pool]?
        var bestEstimatedAmount: UInt64 = 0
        
        for pair in poolsPairs {
            guard let estimatedAmount = pair.getOutputAmount(fromInputAmount: inputAmount)
            else {continue}
            if estimatedAmount > bestEstimatedAmount {
                bestEstimatedAmount = estimatedAmount
                bestPools = pair
            }
        }
        
        return bestPools
    }
    
    /// Find best pool to swap from estimated amount
    public func findBestPoolsPairForEstimatedAmount(
        _ estimatedAmount: UInt64,
        from poolsPairs: [PoolsPair]
    ) throws -> PoolsPair? {
//        var poolsPairs = poolsPairs
//
//        // filter out deprecated pools
//        let indeprecatedPools = poolsPairs.filter {!$0.contains(where: {$0.deprecated == true})}
//        if indeprecatedPools.count > 0 {
//            poolsPairs = indeprecatedPools
//        }
        
        guard poolsPairs.count > 0 else {return nil}
        
        var bestPools: [Pool]?
        var bestInputAmount: UInt64 = .max
        
        for pair in poolsPairs {
            guard let inputAmount = pair.getInputAmount(fromEstimatedAmount: estimatedAmount)
            else {continue}
            if inputAmount < bestInputAmount {
                bestInputAmount = inputAmount
                bestPools = pair
            }
        }
        
        return bestPools
    }
    
    /// Get liquidity provider fee
    public func getLiquidityProviderFee(
        bestPoolsPair: PoolsPair?,
        inputAmount: Double?,
        slippage: Double
    ) throws -> [UInt64] {
        try bestPoolsPair?.calculateLiquidityProviderFees(inputAmount: inputAmount ?? 0, slippage: slippage) ?? []
    }
    
    /// Get network fees from current context
    /// - Returns: transactions fees (fees for signatures), liquidity provider fees (fees in intermediary token?, fees in destination token)
    public func getNetworkFees(
        myWalletsMints: [String],
        fromWalletPubkey: String,
        toWalletPubkey: String?,
        bestPoolsPair: PoolsPair?,
        inputAmount: Double?,
        slippage: Double,
        lamportsPerSignature: UInt64,
        minRentExempt: UInt64
    ) throws -> Single<SolanaSDK.FeeAmount> {
        guard let owner = accountProvider.getNativeWalletAddress() else {throw OrcaSwapError.unauthorized}
        
        let numberOfPools = UInt64(bestPoolsPair?.count ?? 0)
        var numberOfTransactions: UInt64 = 1
        
        if numberOfPools == 2 {
            let myTokens = myWalletsMints.compactMap {getTokenFromMint($0)}.map {$0.name}
            let intermediaryTokenName = bestPoolsPair![0].tokenBName
            
            if !myTokens.contains(intermediaryTokenName) ||
                toWalletPubkey == nil
            {
                numberOfTransactions += 1
            }
        }
        
        var expectedFee = SolanaSDK.FeeAmount.zero

        // fee for owner's signature
        expectedFee.transaction += numberOfTransactions * lamportsPerSignature

        // when source token is native SOL
        if fromWalletPubkey == owner.base58EncodedString {
            // WSOL's signature
            expectedFee.transaction += lamportsPerSignature
            expectedFee.deposit += minRentExempt
        }
        
        // when there is intermediary token
        var isIntermediaryTokenCreatedRequest = Single<Bool>.just(true)
        if numberOfPools == 2,
           let decimals = bestPoolsPair![0].tokenABalance?.decimals,
           let inputAmount = inputAmount,
           let intermediaryToken = bestPoolsPair?
                .getIntermediaryToken(
                    inputAmount: inputAmount.toLamport(decimals: decimals),
                    slippage: slippage
                ),
           let mint = getMint(tokenName: intermediaryToken.tokenName)
        {
            // when intermediary token is SOL, a deposit fee for creating WSOL is needed (will be returned after transaction)
            if intermediaryToken.tokenName == "SOL" {
                expectedFee.transaction += lamportsPerSignature
                expectedFee.deposit += minRentExempt
            }
            
            // Check if intermediary token creation is needed
            else {
                isIntermediaryTokenCreatedRequest = solanaClient.checkIfAssociatedTokenAccountExists(owner: owner, mint: mint)
            }
        }
        
        // when needed to create destination
        if toWalletPubkey == nil {
            expectedFee.accountBalances += minRentExempt
        }

        // when destination is native SOL
        else if toWalletPubkey == owner.base58EncodedString {
            expectedFee.transaction += lamportsPerSignature
            expectedFee.deposit += minRentExempt
        }
        
        return isIntermediaryTokenCreatedRequest
            .map {!$0}
            .map { needsCreateIntermediaryToken in
                // Intermediary token needs to be created, so add the fee
                if needsCreateIntermediaryToken {
                    expectedFee.accountBalances += minRentExempt
                }
                return expectedFee
            }
    }
    
    /// Execute swap
    public func prepareForSwapping(
        fromWalletPubkey: String,
        toWalletPubkey: String?,
        bestPoolsPair: PoolsPair,
        amount: Double,
        feePayer: PublicKey?,
        slippage: Double
    ) -> Single<([PreparedSwapTransaction], String? /*New created account*/)> {
        guard bestPoolsPair.count > 0 else {return .error(OrcaSwapError.swapInfoMissing)}
        guard let fromDecimals = bestPoolsPair[0].tokenABalance?.decimals else {
            return .error(OrcaSwapError.invalidPool)
        }
        
        let amount = amount.toLamport(decimals: fromDecimals)
        
        let minRenExemptionRequest = solanaClient.getMinimumBalanceForRentExemption(span: 165)
        
        if bestPoolsPair.count == 1 {
            return minRenExemptionRequest.flatMap { [weak self] minRenExemption in
                guard let self = self else {throw OrcaSwapError.unknown}
                return self.directSwap(
                    pool: bestPoolsPair[0],
                    fromTokenPubkey: fromWalletPubkey,
                    toTokenPubkey: toWalletPubkey,
                    amount: amount,
                    feePayer: feePayer,
                    slippage: slippage,
                    minRenExemption: minRenExemption
                )
                    .map {([$0.0], $0.1)}
            }
        } else {
            let pool0 = bestPoolsPair[0]
            let pool1 = bestPoolsPair[1]
            
            // TO AVOID `TRANSACTION IS TOO LARGE` ERROR, WE SPLIT OPERATION INTO 2 TRANSACTIONS
            // FIRST TRANSACTION IS TO CREATE ASSOCIATED TOKEN ADDRESS FOR INTERMEDIARY TOKEN OR DESTINATION TOKEN (IF NOT YET CREATED) AND WAIT FOR CONFIRMATION **IF THEY ARE NOT WSOL**
            // SECOND TRANSACTION TAKE THE RESULT OF FIRST TRANSACTION (ADDRESSES) TO REDUCE ITS SIZE. **IF INTERMEDIATE TOKEN OR DESTINATION TOKEN IS WSOL, IT SHOULD BE INCLUDED IN THIS TRANSACTION**
            
            // First transaction
            return minRenExemptionRequest.flatMap { [weak self] minRenExemption -> Single<(PublicKey, PublicKey, AccountInstructions?, PreparedSwapTransaction?, Lamports)> in
                guard let self = self else {throw OrcaSwapError.unknown}
                return self.createIntermediaryTokenAndDestinationTokenAddressIfNeeded(
                    pool0: pool0,
                    pool1: pool1,
                    toWalletPubkey: toWalletPubkey,
                    feePayer: feePayer,
                    minRenExemption: minRenExemption
                ).map {($0.0, $0.1, $0.2, $0.3, minRenExemption)}
            }
                .flatMap {[weak self] intermediaryTokenAddress, destinationTokenAddress, wsolAccountInstructions, preparedTransaction, minRenExemption in
                    guard let self = self else {throw OrcaSwapError.unknown}
                    // Second transaction
                    return self.transitiveSwap(
                        pool0: pool0,
                        pool1: pool1,
                        fromTokenPubkey: fromWalletPubkey,
                        intermediaryTokenAddress: intermediaryTokenAddress.base58EncodedString,
                        destinationTokenAddress: destinationTokenAddress.base58EncodedString,
                        feePayer: feePayer,
                        wsolAccountInstructions: wsolAccountInstructions,
                        isDestinationNew: toWalletPubkey == nil,
                        amount: amount,
                        slippage: slippage,
                        minRenExemption: minRenExemption
                    )
                        .map {
                            var transactions = [PreparedSwapTransaction]()
                            if let preparedTransaction = preparedTransaction {
                                transactions.append(preparedTransaction)
                            }
                            transactions.append($0.0)
                            return (transactions, $0.1)
                        }
                }
        }
    }
    
    /// Prepare for swapping and swap
    public func swap(
        fromWalletPubkey: String,
        toWalletPubkey: String?,
        bestPoolsPair: PoolsPair,
        amount: Double,
        slippage: Double,
        isSimulation: Bool
    ) -> Single<SwapResponse> {
        prepareForSwapping(
            fromWalletPubkey: fromWalletPubkey,
            toWalletPubkey: toWalletPubkey,
            bestPoolsPair: bestPoolsPair,
            amount: amount,
            feePayer: nil,
            slippage: slippage
        )
            .flatMap { [weak self] params in
                guard let self = self else {throw OrcaSwapError.unknown}
                guard let owner = self.accountProvider.getAccount()?.publicKey else {throw OrcaSwapError.unauthorized}
                let swapTransactions = params.0
                guard swapTransactions.count > 0 && swapTransactions.count <= 2 else {
                    throw OrcaSwapError.invalidNumberOfTransactions
                }
                var request = self.prepareAndSend(
                    swapTransactions[0],
                    feePayer: owner,
                    isSimulation: swapTransactions.count == 2 ? false: isSimulation // the first transaction in transitive swap must be non-simulation
                )
                if swapTransactions.count == 2 {
                    request = request
                        .flatMapCompletable { [weak self] txid in
                            guard let self = self else {throw OrcaSwapError.unknown}
                            return self.notificationHandler.waitForConfirmation(signature: txid)
                        }
                        .andThen(
                            self.prepareAndSend(
                                swapTransactions[1],
                                feePayer: owner,
                                isSimulation: isSimulation
                            )
                                .retry { errors in
                                    errors.enumerated().flatMap{ (index, error) -> Observable<Int64> in
                                        if let error = error as? SolanaSDK.Error {
                                            switch error {
                                            case .invalidResponse(let error) where error.data?.logs?.contains("Program log: Error: InvalidAccountData") == true:
                                                return .timer(.seconds(1), scheduler: MainScheduler.instance)
                                            case .transactionError(_, logs: let logs) where logs.contains("Program log: Error: InvalidAccountData"):
                                                return .timer(.seconds(1), scheduler: MainScheduler.instance)
                                            default:
                                                break
                                            }
                                        }
                                        
                                        return .error(error)
                                    }
                                }
                                .timeout(.seconds(60), scheduler: MainScheduler.instance)
                        )
                }
                return request
                    .map {.init(transactionId: $0, newWalletPubkey: params.1)}
            }
    }
    
    func prepareAndSend(
        _ swapTransaction: PreparedSwapTransaction,
        feePayer: PublicKey,
        isSimulation: Bool
    ) -> Single<String> {
        solanaClient.prepareTransaction(
            instructions: swapTransaction.instructions,
            signers: swapTransaction.signers,
            feePayer: feePayer,
            accountsCreationFee: swapTransaction.accountCreationFee,
            recentBlockhash: nil,
            lamportsPerSignature: nil
        )
            .flatMap { [weak self] preparedTransaction in
                guard let self = self else {throw OrcaSwapError.unknown}
                return self.solanaClient.serializeAndSend(
                    preparedTransaction: preparedTransaction,
                    isSimulation: isSimulation
                )
            }
    }
    
    /// Find routes for from and to token name, aka symbol
    func findRoutes(
        fromTokenName: String?,
        toTokenName: String?
    ) throws -> Routes {
        guard let info = info else { throw OrcaSwapError.swapInfoMissing }
        
        // if fromToken isn't selected
        guard let fromTokenName = fromTokenName else {return [:]}

        // if toToken isn't selected
        guard let toTokenName = toTokenName else {
            // get all routes that have token A
            let routes = info.routes.filter {$0.key.components(separatedBy: "/").contains(fromTokenName)}
                .filter {!$0.value.isEmpty}
            return routes
        }

        // get routes with fromToken and toToken
        let pair = [fromTokenName, toTokenName]
        let validRoutesNames = [
            pair.joined(separator: "/"),
            pair.reversed().joined(separator: "/")
        ]
        return info.routes.filter {validRoutesNames.contains($0.key)}
            .filter {!$0.value.isEmpty}
    }
    
    /// Map mint to token info
    private func getTokenFromMint(_ mint: String) -> (name: String, info: TokenValue)? {
        let tokenInfo = info?.tokens.first(where: {$0.value.mint == mint})
        guard let name = tokenInfo?.key, let value = tokenInfo?.value else {return nil}
        return (name: name, info: value)
    }
    
    private func directSwap(
        pool: Pool,
        fromTokenPubkey: String,
        toTokenPubkey: String?,
        amount: UInt64,
        feePayer: PublicKey?,
        slippage: Double,
        minRenExemption: Lamports
    ) -> Single<(PreparedSwapTransaction, String?)> {
        guard let owner = accountProvider.getAccount() else {return .error(OrcaSwapError.unauthorized)}
        guard let info = info else {return .error(OrcaSwapError.swapInfoMissing)}
        
        return [pool]
            .constructExchange(
                tokens: info.tokens,
                solanaClient: self.solanaClient,
                owner: owner,
                fromTokenPubkey: fromTokenPubkey,
                toTokenPubkey: toTokenPubkey,
                amount: amount,
                slippage: slippage,
                feePayer: feePayer,
                minRenExemption: minRenExemption
            )
            .map {accountInstructions, accountCreationFee in
                (
                    .init(
                        instructions: accountInstructions.instructions + accountInstructions.cleanupInstructions,
                        signers: [owner] + accountInstructions.signers,
                        accountCreationFee: accountCreationFee
                    ),
                    toTokenPubkey == nil ? accountInstructions.account.base58EncodedString: nil
                 )
            }
    }
    
    private func transitiveSwap(
        pool0: Pool,
        pool1: Pool,
        fromTokenPubkey: String,
        intermediaryTokenAddress: String,
        destinationTokenAddress: String,
        feePayer: PublicKey?,
        wsolAccountInstructions: AccountInstructions?,
        isDestinationNew: Bool,
        amount: UInt64,
        slippage: Double,
        minRenExemption: Lamports
    ) -> Single<(PreparedSwapTransaction, String?)> {
        guard let owner = accountProvider.getAccount() else {return .error(OrcaSwapError.unauthorized)}
        guard let info = info else {return .error(OrcaSwapError.swapInfoMissing)}
        
        return [pool0, pool1]
            .constructExchange(
                tokens: info.tokens,
                solanaClient: solanaClient,
                owner: owner,
                fromTokenPubkey: fromTokenPubkey,
                intermediaryTokenAddress: intermediaryTokenAddress,
                toTokenPubkey: destinationTokenAddress,
                amount: amount,
                slippage: slippage,
                feePayer: feePayer,
                minRenExemption: minRenExemption
            )
            .map { accountInstructions, accountCreationFee in
                var accountCreationFee = accountCreationFee
                
                var instructions = accountInstructions.instructions + accountInstructions.cleanupInstructions
                var additionalSigners = [Account]()
                if let wsolAccountInstructions = wsolAccountInstructions {
                    additionalSigners.append(contentsOf: wsolAccountInstructions.signers)
                    instructions.insert(contentsOf: wsolAccountInstructions.instructions, at: 0)
                    instructions.append(contentsOf: wsolAccountInstructions.cleanupInstructions)
                    accountCreationFee += minRenExemption
                }
                
                return (
                    .init(
                        instructions: instructions,
                        signers: [owner] + additionalSigners + accountInstructions.signers,
                        accountCreationFee: accountCreationFee
                    ),
                    isDestinationNew ? accountInstructions.account.base58EncodedString: nil
                )
            }
    }
    
    private func createIntermediaryTokenAndDestinationTokenAddressIfNeeded(
        pool0: Pool,
        pool1: Pool,
        toWalletPubkey: String?,
        feePayer: PublicKey?,
        minRenExemption: Lamports
    ) -> Single<(PublicKey, PublicKey, AccountInstructions?, PreparedSwapTransaction?)> /*intermediaryTokenAddress, destination token address, WSOL account and instructions, account creation fee*/ {
        
        guard let owner = accountProvider.getAccount(),
              let intermediaryTokenMint = try? info?.tokens[pool0.tokenBName]?.mint.toPublicKey(),
              let destinationMint = try? info?.tokens[pool1.tokenBName]?.mint.toPublicKey()
        else {return .error(OrcaSwapError.unauthorized)}
        
        let requestCreatingIntermediaryToken: Single<AccountInstructions>
        
        if intermediaryTokenMint == .wrappedSOLMint {
            requestCreatingIntermediaryToken = solanaClient.prepareCreatingWSOLAccountAndCloseWhenDone(
                from: owner.publicKey,
                amount: 0,
                payer: feePayer ?? owner.publicKey
            )
        } else {
            requestCreatingIntermediaryToken = solanaClient.prepareForCreatingAssociatedTokenAccount(
                owner: owner.publicKey,
                mint: intermediaryTokenMint,
                feePayer: feePayer ?? owner.publicKey,
                closeAfterward: true
            )
        }
        
        return Single.zip(
            requestCreatingIntermediaryToken,
            solanaClient.prepareForCreatingAssociatedTokenAccount(
                owner: owner.publicKey,
                mint: destinationMint,
                feePayer: feePayer ?? owner.publicKey,
                closeAfterward: false
            )
        )
            .map { intAccountInstructions, desAccountInstructions -> (PublicKey, PublicKey, AccountInstructions?, PreparedSwapTransaction?) in
                // get all creating instructions, PASS WSOL ACCOUNT INSTRUCTIONS TO THE SECOND TRANSACTION
                var instructions = [TransactionInstruction]()
                var wsolAccountInstructions: AccountInstructions?
                var accountCreationFee: UInt64 = 0
                
                if intermediaryTokenMint == .wrappedSOLMint {
                    wsolAccountInstructions = intAccountInstructions
                    wsolAccountInstructions?.cleanupInstructions = []
                } else {
                    instructions.append(contentsOf: intAccountInstructions.instructions)
                    if !intAccountInstructions.instructions.isEmpty {
                        accountCreationFee += minRenExemption
                    }
                    // omit clean up instructions
                }
                if destinationMint == .wrappedSOLMint {
                    wsolAccountInstructions = desAccountInstructions
                } else {
                    instructions.append(contentsOf: desAccountInstructions.instructions)
                    if !desAccountInstructions.instructions.isEmpty {
                        accountCreationFee += minRenExemption
                    }
                }
                
                // if token address has already been created, then no need to send any transactions
                if instructions.isEmpty {
                    return (
                        intAccountInstructions.account,
                        desAccountInstructions.account,
                        wsolAccountInstructions,
                        nil
                    )
                }
                
                // if creating transaction is needed
                else {
                    return (
                        intAccountInstructions.account,
                        desAccountInstructions.account,
                        wsolAccountInstructions,
                        .init(
                            instructions: instructions,
                            signers: [owner],
                            accountCreationFee: accountCreationFee
                        )
                    )
                }
            }
    }
}

// MARK: - Helpers
private func findAllAvailableRoutes(tokens: [String: TokenValue], pools: Pools) -> Routes {
    let tokens = tokens.filter {$0.value.poolToken != true}
        .map {$0.key}
    let pairs = getPairs(tokens: tokens)
    return getAllRoutes(pairs: pairs, pools: pools)
}

private func getPairs(tokens: [String]) -> [[String]] {
    var pairs = [[String]]()
    
    guard tokens.count > 0 else {return pairs}
    
    for i in 0..<tokens.count-1 {
        for j in i+1..<tokens.count {
            let tokenA = tokens[i]
            let tokenB = tokens[j]
            
            pairs.append(orderTokenPair(tokenA, tokenB))
        }
    }
    
    return pairs
}

private func orderTokenPair(_ tokenX: String, _ tokenY: String) -> [String] {
    if (tokenX == "USDC" && tokenY == "USDT") {
        return [tokenX, tokenY];
    } else if (tokenY == "USDC" && tokenX == "USDT") {
        return [tokenY, tokenX];
    } else if (tokenY == "USDC" || tokenY == "USDT") {
        return [tokenX, tokenY];
    } else if (tokenX == "USDC" || tokenX == "USDT") {
        return [tokenY, tokenX];
    } else if tokenX < tokenY {
        return [tokenX, tokenY];
    } else {
        return [tokenY, tokenX];
    }
}

private func getAllRoutes(pairs: [[String]], pools: Pools) -> Routes {
    var routes: Routes = [:]
    pairs.forEach { pair in
        guard let tokenA = pair.first,
              let tokenB = pair.last
        else {return}
        routes[getTradeId(tokenA, tokenB)] = getRoutes(tokenA: tokenA, tokenB: tokenB, pools: pools)
    }
    return routes
}

private func getTradeId(_ tokenX: String, _ tokenY: String) -> String {
    orderTokenPair(tokenX, tokenY).joined(separator: "/")
}

private func getRoutes(tokenA: String, tokenB: String, pools: Pools) -> [Route] {
    var routes = [Route]()
    
    // Find all pools that contain the same tokens.
    // Checking tokenAName and tokenBName will find Stable pools.
    for (poolId, poolConfig) in pools {
        if (poolConfig.tokenAName == tokenA && poolConfig.tokenBName == tokenB) ||
            (poolConfig.tokenAName == tokenB && poolConfig.tokenBName == tokenA)
        {
            routes.append([poolId])
        }
    }
    
    // Find all pools that contain the first token but not the second
    let firstLegPools = pools
        .filter {
            ($0.value.tokenAName == tokenA && $0.value.tokenBName != tokenB) ||
                ($0.value.tokenBName == tokenA && $0.value.tokenAName != tokenB)
        }
        .reduce([String: String]()) { result, pool in
            var result = result
            result[pool.key] = pool.value.tokenBName == tokenA ? pool.value.tokenAName: pool.value.tokenBName
            return result
        }
    
    // Find all routes that can include firstLegPool and a second pool.
    firstLegPools.forEach { firstLegPoolId, intermediateTokenName in
        pools.forEach { secondLegPoolId, poolConfig in
            if (poolConfig.tokenAName == intermediateTokenName && poolConfig.tokenBName == tokenB) ||
                (poolConfig.tokenBName == intermediateTokenName && poolConfig.tokenAName == tokenB)
            {
                routes.append([firstLegPoolId, secondLegPoolId])
            }
        }
    }
    
    return routes
}
