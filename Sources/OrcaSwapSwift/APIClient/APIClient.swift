//
//  OrcaSwap+Data.swift
//  
//
//  Created by Chung Tran on 13/10/2021.
//

import Foundation

public protocol OrcaSwapAPIClientV2 {
    var configsProvider: OrcaSwapConfigsProvider {get}
    func reload() async throws
    func getTokens() async throws -> [String: TokenValue]
    func getAquafarms() async throws -> [String: Aquafarm]
    func getPools() async throws -> [String: Pool]
    func getProgramID() async throws -> ProgramIDS
}

extension OrcaSwapAPIClientV2 {
    // MARK: - Methods
    public func reload() async throws {
        _ = try await configsProvider.getData(reload: true)
    }
    
    public func getTokens() async throws -> [String: TokenValue] {
        let data = try await configsProvider.getConfigs()
        let configs = try JSONDecoder().decode(OrcaConfigs.self, from: data)
        return configs.tokens
    }
    
    public func getAquafarms() async throws -> [String: Aquafarm] {
        let data = try await configsProvider.getConfigs()
        let configs = try JSONDecoder().decode(OrcaConfigs.self, from: data)
        return configs.aquafarms
    }
    
    public func getPools() async throws -> [String: Pool] {
        let data = try await configsProvider.getConfigs()
        let configs = try JSONDecoder().decode(OrcaConfigs.self, from: data)
        return configs.pools
    }
    
    public func getProgramID() async throws -> ProgramIDS {
        let data = try await configsProvider.getConfigs()
        let configs = try JSONDecoder().decode(OrcaConfigs.self, from: data)
        return configs.programIDS
    }
}

public class APIClientV2: OrcaSwapAPIClientV2 {
    // MARK: - Properties
    
    public let configsProvider: OrcaSwapConfigsProvider
    
    // MARK: - Initializers
    
    public init(configsProvider: OrcaSwapConfigsProvider) {
        self.configsProvider = configsProvider
    }
}
