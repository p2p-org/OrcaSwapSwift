import Foundation

// MARK: - SwapTest
struct SwapTest: Codable {
    let comment: String
    let endpoint: String
    let endpointAdditionalQuery, seedPhrase, fromMint, toMint: String
    let sourceAddress, destinationAddress: String
    let poolsPair: [PoolsPair]
    let inputAmount: Int
    let slippage: Double
}

// MARK: - PoolsPair
struct PoolsPair: Codable {
    let name: String
    let reversed: Bool
}
