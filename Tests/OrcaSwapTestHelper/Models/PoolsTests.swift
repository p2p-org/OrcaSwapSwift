import XCTest
@testable import SolanaSwift
@testable import OrcaSwapSwift

class PoolsTestsTests: XCTestCase {
    
    override func setUp() async throws {}
    
    func testGetInputAmount() async throws {
        let api = APIClient(configsProvider: MockConfigsProvider())
        let pools = try await api.getPools()
        var pool = pools.values.first!
        pool.tokenABalance = .init(amount: 1, decimals: 1)
        pool.tokenBBalance = .init(amount: 2, decimals: 1)
        let estimatedAmount2: UInt64 = 1
        let result = try pool.getInputAmount(fromEstimatedAmount: estimatedAmount2)
        XCTAssertEqual(result, 1)
    }
    
    func testGetBaseOutputAmount() async throws {
        let api = APIClient(configsProvider: MockConfigsProvider())
        let pools = try await api.getPools()
        var pool = pools.values.first!
        pool.tokenABalance = .init(amount: 1, decimals: 1)
        pool.tokenBBalance = .init(amount: 2, decimals: 1)
        let result = try pool.getBaseOutputAmount(inputAmount: 1)
        XCTAssertEqual(result, 2)
        let result1 = try pool.getBaseOutputAmount(inputAmount: 2)
        XCTAssertEqual(result1, 4)
    }

}
