//
//  OrcaSwapSwapTests.swift
//  
//
//  Created by Chung Tran on 19/10/2021.
//

import Foundation
import XCTest
import RxSwift
@testable import SolanaSwift
@testable import OrcaSwapSwift

class OrcaSwapSwapTests: XCTestCase {
    // MARK: - Properties
    var solanaSDK: SolanaSDK!
    var orcaSwap: OrcaSwap!
    var endpoint: SolanaSDK.APIEndPoint! {
        .init(address: "https://p2p.rpcpool.com/", network: .mainnetBeta)
    }
    var phrase: String {
        "miracle pizza supply useful steak border same again youth silver access hundred"
    }
    
    var poolsRepository: [String: OrcaSwap.Pool]!
    
    // MARK: - Setup
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let accountStorage = InMemoryAccountStorage()
        
        solanaSDK = SolanaSDK(
            endpoint: endpoint,
            accountStorage: accountStorage
        )
        
        let account = try SolanaSDK.Account(
            phrase: phrase.components(separatedBy: " "),
            network: endpoint.network
        )
        try accountStorage.save(account)
        
        orcaSwap = OrcaSwap(
            apiClient: OrcaSwap.MockAPIClient(network: "mainnet"),
            solanaClient: solanaSDK,
            accountProvider: solanaSDK,
            notificationHandler: solanaSDK
        )
        
        _ = orcaSwap.load().toBlocking().materialize()
        
        poolsRepository = try JSONDecoder().decode([String: OrcaSwap.Pool].self, from: OrcaSwap.getFileFrom(type: "pools", network: "mainnet"))
    }
    
    // MARK: - Helper
    struct RawPool {
        init(name: String, reversed: Bool = false) {
            self.name = name
            self.reversed = reversed
        }
        
        let name: String
        let reversed: Bool
    }
    
    func fillPoolsBalancesAndSwap(
        fromWalletPubkey: String,
        toWalletPubkey: String?,
        bestPoolsPair: [RawPool],
        amount: Double,
        slippage: Double,
        isSimulation: Bool
    ) throws -> Single<OrcaSwap.SwapResponse> {
        let bestPoolsPair = try Single.zip(
            bestPoolsPair.map { rawPool -> Single<OrcaSwap.Pool> in
                var pool = poolsRepository[rawPool.name]!
                if rawPool.reversed {
                    pool = pool.reversed
                }
                return pool.filledWithUpdatedBalances(solanaClient: solanaSDK)
            }
        ).toBlocking().first()!
        
        let swapSimulation = orcaSwap.swap(
            fromWalletPubkey: fromWalletPubkey,
            toWalletPubkey: toWalletPubkey,
            bestPoolsPair: bestPoolsPair,
            amount: amount,
            slippage: 0.5,
            isSimulation: isSimulation
        )
        
        return swapSimulation
    }
}
