import XCTest
import OrcaSwapSwift

class APIClientTests: XCTestCase {
    private let client = APIClientV2(configsProvider: MockConfigsProvider())

    func testRetrievingTokens() async throws {
        let tokens = try await client.getTokens()
        XCTAssertEqual(tokens.count, 246)
    }
    
    func testRetrievingAquafarms() async throws {
        let aquafarms = try await client.getAquafarms()
        XCTAssertEqual(aquafarms.count, 127)
    }
    
    func testRetrievingPools() async throws {
        let pools = try await client.getPools()
        XCTAssertEqual(pools.count, 146)
    }
    
    func testRetrievingProgramId() async throws {
        let programId = try await client.getProgramID()
        XCTAssertEqual(.tokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA, programId.token)
    }
}

// MARK: - Mocking
class MockConfigsProvider: OrcaSwapConfigsProvider {
    func getData(reload: Bool) async throws -> Data {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../../Resources/orcaconfigs-mainnet.json")
        let data = try! Data(contentsOf: resourceURL)
        return data
    }
}
