import Foundation
import SolanaSwift
import OrcaSwapSwift

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
