import Foundation

// MARK: - SwapTest
struct SwapTest: Codable {
    let comment: String
    let endpoint: String
    let endpointAdditionalQuery, seedPhrase, fromMint, toMint: String
    let sourceAddress: String
    let destinationAddress: String?
    let poolsPair: [OrcaSwapSwapTests.RawPool]
    let inputAmount: Double
    let slippage: Double
}
