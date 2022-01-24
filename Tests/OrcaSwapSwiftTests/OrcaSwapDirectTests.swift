//
//  File.swift
//  
//
//  Created by Chung Tran on 18/10/2021.
//

import Foundation
import XCTest
@testable import SolanaSwift

class OrcaSwapDirectTests: OrcaSwapSwapTests {
    // MARK: - Direct SOL to SPL
    func testDirectSwapSOLToCreatedSPL() throws {
        try doTest(testJSONFile: "direct-swap-tests", testName: "solToCreatedSpl", isSimulation: true)
    }
    
    func testDirectSwapSOLToUncreatedSPL() throws {
        try doTest(testJSONFile: "direct-swap-tests", testName: "solToNonCreatedSpl", isSimulation: true)
    }
    
    // MARK: - Direct SPL to SOL
    func testDirectSwapSPLToSOL() throws {
        try doTest(testJSONFile: "direct-swap-tests", testName: "splToSol", isSimulation: true)
    }
    
    // MARK: - Direct SPL to SPL
    func testDirectSwapSPLToCreatedSPL() throws {
//        let swapSimulation = try fillPoolsBalancesAndSwap(
//            fromWalletPubkey: socnPubkey,
//            toWalletPubkey: usdcPubkey,
//            bestPoolsPair: [.init(name: "SOCN/USDC[aquafarm]")],
//            amount: 0.01,
//            slippage: 0.5,
//            isSimulation: true
//        )
//
//        XCTAssertNoThrow(try swapSimulation.toBlocking().first())
    }
    
    func testDirectSwapSPLToUncreatedSPL() throws {
//        let swapSimulation = try fillPoolsBalancesAndSwap(
//            fromWalletPubkey: usdcPubkey,
//            toWalletPubkey: nil,
//            bestPoolsPair: [.init(name: "MNGO/USDC[aquafarm]", reversed: true)],
//            amount: 0.1,
//            slippage: 0.5,
//            isSimulation: true
//        )
//
//        XCTAssertNoThrow(try swapSimulation.toBlocking().first())
    }
}

