import XCTest
@testable import SolanaSwift
@testable import OrcaSwapSwift

class OrcaSwapPreparationTests: XCTestCase {
    let btcMint = "9n4nbM75f5Ui33ZbPYXn59EwSgE8CGsHtAeTH5YFeJ9E"
    let ethMint = "2FPyTwcZLUg1MDrwsyoP4D6s1tM7hAkHYRjkNb5w6Pxk"
    let socnMint = "5oVNBeEEQvYi1cX3ir8Dx5n1P7pdxydbGF2X4TxVusJm"
    
    fileprivate var orcaSwap: OrcaSwap!
    
    var swapInfo: SwapInfo {
        orcaSwap.info!
    }
    
    override func setUp() async throws {
        let solanaAPIClient = MockSolanaAPIClient(endpoint: .init(address: "", network: .devnet))
        let blockchainClient = BlockchainClient(apiClient: solanaAPIClient)
        orcaSwap = OrcaSwap(
            apiClient: APIClient(configsProvider: MockConfigsProvider()),
            solanaClient: solanaAPIClient,
            blockchainClient: blockchainClient,
            accountStorage: await MockAccountStorage()
        )
        try await orcaSwap.load()
    }
    
    // MARK: - Swap data
    func testLoadSwap() throws {
//        print(routes.jsonString!.replacingOccurrences(of: #"\/"#, with: "/"))
        XCTAssertEqual(swapInfo.routes.count, 9870)
        XCTAssertEqual(swapInfo.tokens.count, 294)
        XCTAssertEqual(swapInfo.pools.count, 153)
        XCTAssertEqual(swapInfo.programIds.serumTokenSwap, "SwaPpA9LAaLfeLi3a68M4DjnLqgtticKg6CnyNwgAC8")
        XCTAssertEqual(swapInfo.programIds.tokenSwapV2, "9W959DqEETiGZocYWCQPaJ6sBmUzgfxXfqGeTEdp3aQP")
        XCTAssertEqual(swapInfo.programIds.tokenSwap, "DjVE6JNiYqPL2QXyCUUh8rNjHrbz9hXHNYt99MQ59qw1")
        XCTAssertEqual(swapInfo.programIds.token, .tokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA)
        XCTAssertEqual(swapInfo.programIds.aquafarm, "82yxjeMsvaURa4MbZZ7WZZHfobirZYkH1zF8fmeGtyaQ")
        XCTAssertEqual(swapInfo.tokenNames.count, 294)
    }
    
    func testGetTokenMint() throws {
        XCTAssertEqual(orcaSwap.getMint(tokenName: "BTC"), "9n4nbM75f5Ui33ZbPYXn59EwSgE8CGsHtAeTH5YFeJ9E")
    }
    
    // MARK: - Find destinations
    func testFindDestinations() throws {
        let routes = try orcaSwap.findPosibleDestinationMints(fromMint: btcMint)
        XCTAssertEqual(routes.count, 99)
    }
    
    // MARK: - BTC -> ETH
    // Order may change
//        [
//            [
//                "BTC/ETH"
//            ],
//            [
//                "BTC/SOL[aquafarm]",
//                "ETH/SOL"
//            ],
//            [
//                "BTC/SOL[aquafarm]",
//                "ETH/SOL[aquafarm]"
//            ]
//        ]
    func testGetTradablePoolsPairs() async throws {
        let pools = try await orcaSwap.getTradablePoolsPairs(fromMint: btcMint, toMint: ethMint)
        XCTAssertEqual(pools.count, 5) //
        XCTAssertEqual(pools.flatMap { $0 }.count, 9)
        
        let btcETHPool = pools.first(where: {$0.count == 1})!.first!
        XCTAssertEqual(btcETHPool.tokenAccountA, "81w3VGbnszMKpUwh9EzAF9LpRzkKxc5XYCW64fuYk1jH")
        XCTAssertEqual(btcETHPool.tokenAccountB, "6r14WvGMaR1xGMnaU8JKeuDK38RvUNxJfoXtycUKtC7Z")
        XCTAssertEqual(btcETHPool.tokenAName, "BTC")
        XCTAssertEqual(btcETHPool.tokenBName, "ETH")
        
        let btcSOLAquafarm = pools.first(where: {$0.contains(where: {$0.account == "7N2AEJ98qBs4PwEwZ6k5pj8uZBKMkZrKZeiC7A64B47u"})})!.first!
        XCTAssertEqual(btcSOLAquafarm.tokenAccountA, "9G5TBPbEUg2iaFxJ29uVAT8ZzxY77esRshyHiLYZKRh8")
        XCTAssertEqual(btcSOLAquafarm.tokenAccountB, "5eqcnUasgU2NRrEAeWxvFVRTTYWJWfAJhsdffvc6nJc2")
        XCTAssertEqual(btcSOLAquafarm.tokenAName, "BTC")
        XCTAssertEqual(btcSOLAquafarm.tokenBName, "SOL")
        
        let ethSOL = pools.first(where: {$0.contains(where: {$0.account == "4vWJYxLx9F7WPQeeYzg9cxhDeaPjwruZXCffaSknWFxy"})})!.last! // Reversed to SOL/ETH
        XCTAssertEqual(ethSOL.tokenAccountA, "5x1amFuGMfUVzy49Y4Pc3HyCVD2usjLaofnzB3d8h7rv") // originalTokenAccountB
        XCTAssertEqual(ethSOL.tokenAccountB, "FidGus13X2HPzd3cuBEFSq32UcBQkF68niwvP6bM4fs2") // originalTokenAccountA
        XCTAssertEqual(ethSOL.tokenAName, "SOL")
        XCTAssertEqual(ethSOL.tokenBName, "ETH")
        
        let ethSOLAquafarm = pools.first(where: {$0.contains(where: {$0.account == "EuK3xDa4rWuHeMQCBsHf1ETZNiEQb5C476oE9u9kp8Ji"})})!.last! // reversed to SOL/ETH
        XCTAssertEqual(ethSOLAquafarm.tokenAccountA, "5pUTGvN2AA2BEzBDU4CNDh3LHER15WS6J8oJf5XeZFD8") // originalTokenAccountB
        XCTAssertEqual(ethSOLAquafarm.tokenAccountB, "7F2cLdio3i6CCJaypj9VfNDPW2DwT3vkDmZJDEfmxu6A") // originalTokenAccountA
        XCTAssertEqual(ethSOLAquafarm.tokenAName, "SOL")
        XCTAssertEqual(ethSOLAquafarm.tokenBName, "ETH")
    }
    
    func testGetBestPoolsPair() async throws {
        // when user enter input amount = 0.1 BTC
        let inputAmount: UInt64 = 100000 // 0.1 BTC
        let poolsPairs = try await orcaSwap.getTradablePoolsPairs(fromMint: btcMint, toMint: ethMint)
        let bestPoolsPair = try orcaSwap.findBestPoolsPairForInputAmount(inputAmount, from: poolsPairs)
        let estimatedAmount = bestPoolsPair?.getOutputAmount(fromInputAmount: inputAmount)
        XCTAssertEqual(estimatedAmount, 1588996) // 1.588996 ETH
        
        // when user enter estimated amount that he wants to receive as 1.6 ETH
        let estimatedAmount2: UInt64 = 1600000
        let bestPoolsPair2 = try orcaSwap.findBestPoolsPairForEstimatedAmount(estimatedAmount2, from: poolsPairs)
        let inputAmount2 = bestPoolsPair2?.getInputAmount(fromEstimatedAmount: estimatedAmount2)
        XCTAssertEqual(inputAmount2, 100697) // 0.100697 BTC
    }
    
    // MARK: - SOCN -> SOL -> BTC (Reversed)
    // SOCN -> BTC
//        [
//            [
//                "BTC/SOL[aquafarm]",
//                "SOCN/SOL[stable][aquafarm]"
//            ]
//        ]
    // Should be considered at
//        [
//            [
//                "SOCN/SOL[stable][aquafarm]",
//                "BTC/SOL[aquafarm]"
//            ]
//        ]
    func testGetTradablePoolsPairsReversed() async throws {
        let poolsPair = try await orcaSwap.getTradablePoolsPairs(fromMint: socnMint, toMint: btcMint).sorted(by: {$0.first!.account < $1.first!.account}).first!
        XCTAssertEqual(poolsPair.count, 2) // there is only 1 pair
        
        let socnSOL = poolsPair.first!
        XCTAssertEqual(socnSOL.tokenAccountA, "C8DRXUqxXtUgvgBR7BPAmy6tnRJYgVjG27VU44wWDMNV")
        XCTAssertEqual(socnSOL.tokenAccountB, "DzdxH5qJ68PiM1p5o6PbPLPpDj8m1ZshcaMFATcxDZix")
        XCTAssertEqual(socnSOL.tokenAName, "scnSOL")
        XCTAssertEqual(socnSOL.tokenBName, "SOL")
        
        let solBTC = poolsPair.last!
        XCTAssertEqual(solBTC.tokenAccountA, "5eqcnUasgU2NRrEAeWxvFVRTTYWJWfAJhsdffvc6nJc2")
        XCTAssertEqual(solBTC.tokenAccountB, "9G5TBPbEUg2iaFxJ29uVAT8ZzxY77esRshyHiLYZKRh8")
        XCTAssertEqual(solBTC.tokenAName, "SOL")
        XCTAssertEqual(solBTC.tokenBName, "BTC")
    }
    
    func testGetBestPoolsPairReversed() async throws {
        // when user enter input amount = 419.68 SOCN
        let inputAmount: UInt64 = 419680000000 // 419.68 SOCN
        let poolsPairs = try await orcaSwap.getTradablePoolsPairs(fromMint: socnMint, toMint: btcMint)
        let bestPoolsPair = try orcaSwap.findBestPoolsPairForInputAmount(inputAmount, from: poolsPairs)
        let estimatedAmount = bestPoolsPair?.getOutputAmount(fromInputAmount: inputAmount)
        XCTAssertEqual(estimatedAmount, 1013077) // 1.013077 BTC
        
        // when user enter estimated amount that he wants to receive as 1 BTC
        let estimatedAmount2: UInt64 = 1000000 // 1 BTC
        let bestPoolsPair2 = try orcaSwap.findBestPoolsPairForEstimatedAmount(estimatedAmount2, from: poolsPairs)
        let inputAmount2 = bestPoolsPair2?.getInputAmount(fromEstimatedAmount: estimatedAmount2)
        XCTAssertEqual(inputAmount2, 413909257520) // 413.909257520 SOCN
    }
}

private class MockSolanaAPIClient: JSONRPCAPIClient {
    override func getTokenAccountBalance(pubkey: String, commitment: Commitment?) async throws -> TokenAccountBalance {
        // BTC/ETH
        if pubkey == "81w3VGbnszMKpUwh9EzAF9LpRzkKxc5XYCW64fuYk1jH" {
            return.init(amount: 0.001014, decimals: 6)
        }
        if pubkey == "6r14WvGMaR1xGMnaU8JKeuDK38RvUNxJfoXtycUKtC7Z" {
            return .init(amount: 0.016914, decimals: 6)
        }
        
        // BTC/SOL[aquafarm]
        if pubkey == "9G5TBPbEUg2iaFxJ29uVAT8ZzxY77esRshyHiLYZKRh8" {
            return .init(amount: 18.448748, decimals: 6)
        }
        if pubkey == "5eqcnUasgU2NRrEAeWxvFVRTTYWJWfAJhsdffvc6nJc2" {
            return .init(amount: 7218.011507888, decimals: 9)
        }
        
        // ETH/SOL
        if pubkey == "FidGus13X2HPzd3cuBEFSq32UcBQkF68niwvP6bM4fs2" {
            return .init(amount: 0.57422, decimals: 6)
        }
        if pubkey == "5x1amFuGMfUVzy49Y4Pc3HyCVD2usjLaofnzB3d8h7rv" {
            return .init(amount: 13.997148152, decimals: 9)
        }
        
        // ETH/SOL[aquafarm]
        if pubkey == "7F2cLdio3i6CCJaypj9VfNDPW2DwT3vkDmZJDEfmxu6A" {
            return .init(amount: 4252.752761, decimals: 6)
        }
        if pubkey == "5pUTGvN2AA2BEzBDU4CNDh3LHER15WS6J8oJf5XeZFD8" {
            return .init(amount: 103486.885774058, decimals: 9)
        }
        
        // SOCN/SOL
        if pubkey == "C8DRXUqxXtUgvgBR7BPAmy6tnRJYgVjG27VU44wWDMNV" {
            return .init(amount: 20097.450122295, decimals: 9)
        }
        
        if pubkey == "DzdxH5qJ68PiM1p5o6PbPLPpDj8m1ZshcaMFATcxDZix" {
            return .init(amount: 27474.561069286, decimals: 9)
        }
        
        if pubkey == "D3Wv78j9STkfJx3vhzoCzpMZ4RqCg8oaTNGzi1rZpdJg" {
            return .init(amount: 26.094032, decimals: 6)
        }
        
        if pubkey == "HMFLg2GtbWSSEe92Vuf2LQdUpCacGj2m2PwvMqzwQFNi" {
            return .init(amount: 1022524.636749, decimals: 6)
        }
        
        if pubkey == "H9h5yTBfCHcb4eRP87fXczzXgNaMzKihr7bf1sjw7iuZ" {
            return .init(amount: 471.034553, decimals: 6)
        }
        
        if pubkey == "JA98RXv2VdxQD8pRQq4dzJ1Bp4nH8nokCGmxvPWKJ3hx" {
            return .init(amount: 1350604.603948, decimals: 6)
        }
        
        if pubkey == "8eUUP3t9nkXPub8X6aW2a2gzi82pUFqefwkSY8rCcVxg" {
            return .init(amount: 0.092121, decimals: 6)
        }
        
        if pubkey == "2tNEBoEuqJ1pPmA1fpitDnowgUQZXvCT6W3fui67AFfV" {
            return .init(amount: 265.732429, decimals: 6)
        }
        
        if pubkey == "7xs9QsrxQDVoWQ8LQ8VsVjfPKBrPGjvg8ZhaLnU1i2VR" {
            return .init(amount: 2953.826989329, decimals: 9)
        }
        
        if pubkey == "FZFJK64Fk1t619zmVPqCx8Uy29zJ3WuvjWitCQuxXRo3" {
            return .init(amount: 300343.554305, decimals: 6)
        }
        
        fatalError()
    }
}

private struct MockAccountStorage: SolanaAccountStorage {
    var account: Account?
    
    init() async {
        account = try? await .init(
            phrase: "miracle pizza supply useful steak border same again youth silver access hundred"
                .components(separatedBy: " "),
            network: .mainnetBeta,
            derivablePath: .init(type: .deprecated, walletIndex: 0)
        )
    }
    
    func save(_ account: Account) throws {
        // do nothing
    }
}
