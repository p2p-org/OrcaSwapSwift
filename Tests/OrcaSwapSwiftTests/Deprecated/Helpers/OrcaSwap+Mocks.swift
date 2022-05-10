//
//  OrcaSwap+Mocks.swift
//  
//
//  Created by Chung Tran on 13/10/2021.
//

import Foundation
import RxSwift
@testable import SolanaSwift
@testable import OrcaSwapSwift

class InMemoryAccountStorage: SolanaSDKAccountStorage {
    private var _account: Account?
    func save(_ account: Account) throws {
        _account = account
    }
    var account: Account? {
        _account
    }
    func clear() {
        _account = nil
    }
}

struct MockAPIClient: OrcaSwapAPIClient {
    let network: String
    
    func reload() -> Completable {
        .empty()
    }
    
    func getTokens() -> Single<[String : TokenValue]> {
        .just(getMockConfigs(network: network).tokens)
    }
    
    func getAquafarms() -> Single<[String : Aquafarm]> {
        .just(getMockConfigs(network: network).aquafarms)
    }
    
    func getPools() -> Single<[String : OrcaSwapSwift.Pool]> {
        .just(getMockConfigs(network: network).pools)
    }
    
    func getProgramID() -> Single<ProgramIDS> {
        .just(getMockConfigs(network: network).programIDS)
    }
}

struct MockAccountProvider: OrcaSwapAccountProvider {
    func getAccount() -> Account? {
        try? .init(
            phrase: "miracle pizza supply useful steak border same again youth silver access hundred"
                .components(separatedBy: " "),
            network: .mainnetBeta,
            derivablePath: .init(type: .deprecated, walletIndex: 0)
        )
    }
    
    func getNativeWalletAddress() -> PublicKey? {
        getAccount()?.publicKey
    }
}

struct MockSolanaClient: OrcaSwapSolanaClient {
    func checkIfAssociatedTokenAccountExists(owner: PublicKey?, mint: String) -> Single<Bool> {
        fatalError()
    }
    
    func getMinimumBalanceForRentExemption(span: UInt64) -> Single<UInt64> {
        fatalError()
    }
    
    func prepareCreatingWSOLAccountAndCloseWhenDone(from owner: PublicKey, amount: Lamports, payer: PublicKey) -> Single<AccountInstructions> {
        fatalError()
    }
    
    func prepareForCreatingAssociatedTokenAccount(owner: PublicKey, mint: PublicKey, feePayer: PublicKey, closeAfterward: Bool) -> Single<AccountInstructions> {
        fatalError()
    }
    
    var endpoint: APIEndPoint {
        fatalError()
    }
    
    func serializeAndSend(instructions: [TransactionInstruction], recentBlockhash: String?, signers: [Account], isSimulation: Bool) -> Single<String> {
        fatalError()
    }
    
    func serializeAndSend(preparedTransaction: SolanaSDK.PreparedTransaction, isSimulation: Bool) -> Single<String> {
        fatalError()
    }
    
    func prepareTransaction(instructions: [TransactionInstruction], signers: [Account], feePayer: PublicKey, accountsCreationFee: Lamports, recentBlockhash: String?, lamportsPerSignature: Lamports?) -> Single<SolanaSDK.PreparedTransaction> {
        fatalError()
    }
    
    func getTokenAccountBalance(pubkey: String, commitment: SolanaSDK.Commitment?) -> Single<SolanaSDK.TokenAccountBalance> {
        // BTC/ETH
        if pubkey == "81w3VGbnszMKpUwh9EzAF9LpRzkKxc5XYCW64fuYk1jH" {
            return .just(.init(uiAmount: 0.001014, amount: "1014", decimals: 6, uiAmountString: "0.001014"))
        }
        if pubkey == "6r14WvGMaR1xGMnaU8JKeuDK38RvUNxJfoXtycUKtC7Z" {
            return .just(.init(uiAmount: 0.016914, amount: "16914", decimals: 6, uiAmountString: "0.016914"))
        }
        
        // BTC/SOL[aquafarm]
        if pubkey == "9G5TBPbEUg2iaFxJ29uVAT8ZzxY77esRshyHiLYZKRh8" {
            return .just(.init(uiAmount: 18.448748, amount: "18448748", decimals: 6, uiAmountString: "18.448748"))
        }
        if pubkey == "5eqcnUasgU2NRrEAeWxvFVRTTYWJWfAJhsdffvc6nJc2" {
            return .just(.init(uiAmount: 7218.011507888, amount: "7218011507888", decimals: 9, uiAmountString: "7218.011507888"))
        }
        
        // ETH/SOL
        if pubkey == "FidGus13X2HPzd3cuBEFSq32UcBQkF68niwvP6bM4fs2" {
            return .just(.init(uiAmount: 0.57422, amount: "574220", decimals: 6, uiAmountString: "0.57422"))
        }
        if pubkey == "5x1amFuGMfUVzy49Y4Pc3HyCVD2usjLaofnzB3d8h7rv" {
            return .just(.init(uiAmount: 13.997148152, amount: "13997148152", decimals: 9, uiAmountString: "13.997148152"))
        }
        
        // ETH/SOL[aquafarm]
        if pubkey == "7F2cLdio3i6CCJaypj9VfNDPW2DwT3vkDmZJDEfmxu6A" {
            return .just(.init(uiAmount: 4252.752761, amount: "4252752761", decimals: 6, uiAmountString: "4252.752761"))
        }
        if pubkey == "5pUTGvN2AA2BEzBDU4CNDh3LHER15WS6J8oJf5XeZFD8" {
            return .just(.init(uiAmount: 103486.885774058, amount: "103486885774058", decimals: 9, uiAmountString: "103486.885774058"))
        }
        
        // SOCN/SOL
        if pubkey == "C8DRXUqxXtUgvgBR7BPAmy6tnRJYgVjG27VU44wWDMNV" {
            return .just(.init(uiAmount: 20097.450122295, amount: "20097450122295", decimals: 9, uiAmountString: "20097.450122295"))
        }
        
        if pubkey == "DzdxH5qJ68PiM1p5o6PbPLPpDj8m1ZshcaMFATcxDZix" {
            return .just(.init(uiAmount: 27474.561069286, amount: "27474561069286", decimals: 9, uiAmountString: "27474.561069286"))
        }
        
        if pubkey == "D3Wv78j9STkfJx3vhzoCzpMZ4RqCg8oaTNGzi1rZpdJg" {
            return .just(.init(uiAmount: 26.094032, amount: "26094032", decimals: 6, uiAmountString: "26.094032"))
        }
        
        if pubkey == "HMFLg2GtbWSSEe92Vuf2LQdUpCacGj2m2PwvMqzwQFNi" {
            return .just(.init(uiAmount: 1022524.636749, amount: "1022524636749", decimals: 6, uiAmountString: "1022524.636749"))
        }
        
        if pubkey == "H9h5yTBfCHcb4eRP87fXczzXgNaMzKihr7bf1sjw7iuZ" {
            return .just(.init(uiAmount: 471.034553, amount: "471034553", decimals: 6, uiAmountString: "471.034553"))
        }
        
        if pubkey == "JA98RXv2VdxQD8pRQq4dzJ1Bp4nH8nokCGmxvPWKJ3hx" {
            return .just(.init(uiAmount: 1350604.603948, amount: "1350604603948", decimals: 6, uiAmountString: "1350604.603948"))
        }
        
        if pubkey == "8eUUP3t9nkXPub8X6aW2a2gzi82pUFqefwkSY8rCcVxg" {
            return .just(.init(uiAmount: 0.092121, amount: "92121", decimals: 6, uiAmountString: "0.092121"))
        }
        
        if pubkey == "2tNEBoEuqJ1pPmA1fpitDnowgUQZXvCT6W3fui67AFfV" {
            return .just(.init(uiAmount: 265.732429, amount: "265732429", decimals: 6, uiAmountString: "265.732429"))
        }
        
        if pubkey == "7xs9QsrxQDVoWQ8LQ8VsVjfPKBrPGjvg8ZhaLnU1i2VR" {
            return .just(.init(uiAmount: 2953.826989329, amount: "2953826989329", decimals: 9, uiAmountString: "2953.826989329"))
        }
        
        if pubkey == "FZFJK64Fk1t619zmVPqCx8Uy29zJ3WuvjWitCQuxXRo3" {
            return .just(.init(uiAmount: 300343.554305, amount: "300343554305", decimals: 6, uiAmountString: "300343.554305"))
        }
        
        fatalError()
    }
}

struct MockSocket: OrcaSwapSignatureConfirmationHandler {
    func waitForConfirmation(signature: String) -> Completable {
        fatalError()
    }
}

func getMockConfigs(network: String) -> OrcaConfigs {
    let thisSourceFile = URL(fileURLWithPath: #file)
    let thisDirectory = thisSourceFile.deletingLastPathComponent()
    let resourceURL = thisDirectory.appendingPathComponent("../../../Resources/orcaconfigs-\(network).json")
    let data = try! Data(contentsOf: resourceURL)
    return try! JSONDecoder().decode(OrcaConfigs.self, from: data)
}
