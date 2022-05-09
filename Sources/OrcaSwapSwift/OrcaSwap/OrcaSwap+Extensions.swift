import Foundation
import SolanaSwift

extension OrcaSwapV2 {
    func getPools(
        forRoute route: Route,
        fromTokenName: String,
        toTokenName: String
    ) async throws -> [Pool] {
        guard route.count > 0 else {return []}
        
        var pools = [Pool]()
        try await withThrowingTaskGroup(of: Pool?.self) { group in
            for path in route {
                group.addTask {
                    try await self.fixedPool(path: path)
                }
            }
            for try await pool in group {
                guard let pool = pool else { continue }
                pools.append(pool)
            }
        }
        
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
    
    private func fixedPool(
        path: String // Ex. BTC/SOL[aquafarm][stable]
    ) async throws -> Pool? {
        guard let allPools = info?.pools, var pool = allPools[path] else {return nil}
        
        if path.contains("[stable]") {
            pool.isStable = true
        }
        
        // get balances
        let (tokenABalance, tokenBBalance): (TokenAccountBalance, TokenAccountBalance)
        if let tab = pool.tokenABalance ?? balancesCache[pool.tokenAccountA],
           let tbb = pool.tokenBBalance ?? balancesCache[pool.tokenAccountB]
        {
            (tokenABalance, tokenBBalance) = (tab, tbb)
        } else {
            try Task.checkCancellation()
            (tokenABalance, tokenBBalance) = try await (
                solanaClient.getTokenAccountBalance(pubkey: pool.tokenAccountA, commitment: nil),
                solanaClient.getTokenAccountBalance(pubkey: pool.tokenAccountB, commitment: nil)
            )
        }
        
        locker.lock()
        balancesCache[pool.tokenAccountA] = tokenABalance
        balancesCache[pool.tokenAccountB] = tokenBBalance
        locker.unlock()
        
        pool.tokenABalance = tokenABalance
        pool.tokenBBalance = tokenBBalance
        
        return pool
    }
}

private extension String {
    /// Convert  SOL[aquafarm] to SOL
    var fixedTokenName: String {
        components(separatedBy: "[").first!
    }
}
