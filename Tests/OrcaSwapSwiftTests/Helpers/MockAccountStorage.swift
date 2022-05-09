import Foundation
import SolanaSwift

struct MockAccountStorage: SolanaAccountStorage {
    var account: Account? {
        get throws {
            try? .init(
                phrase: "miracle pizza supply useful steak border same again youth silver access hundred"
                    .components(separatedBy: " "),
                network: .mainnetBeta,
                derivablePath: .init(type: .deprecated, walletIndex: 0)
            )
        }
    }
    
    func save(_ account: Account) throws {
        // do nothing
    }
}
