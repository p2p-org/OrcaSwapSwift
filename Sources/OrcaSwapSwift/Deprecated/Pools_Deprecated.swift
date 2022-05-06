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

private extension String {
    /// Convert  SOL[aquafarm] to SOL
    var fixedTokenName: String {
        components(separatedBy: "[").first!
    }
}
