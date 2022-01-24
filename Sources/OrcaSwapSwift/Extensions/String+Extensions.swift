import Foundation
import SolanaSwift

extension String {
    func toPublicKey() throws -> SolanaSDK.PublicKey {
        try SolanaSDK.PublicKey(string: self)
    }
}
