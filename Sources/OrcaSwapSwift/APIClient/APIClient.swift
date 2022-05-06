//
//  OrcaSwap+Data.swift
//  
//
//  Created by Chung Tran on 13/10/2021.
//

import Foundation
import RxSwift

public protocol OrcaSwapAPIClientV2 {
    var network: String {get}
    func reload() async throws
    func getTokens() async throws -> [String: TokenValue]
    func getAquafarms() async throws -> [String: Aquafarm]
    func getPools() async throws -> [String: Pool]
    func getProgramID() async throws -> ProgramIDS
}

public class APIClientV2: OrcaSwapAPIClientV2 {
    // MARK: - Properties
    
    private let urlString = "https://api.orca.so/configs"
    private let locker = NSLock()
    private let disposeBag = DisposeBag()
    
    public let network: String
    private var cache: OrcaConfigs?
    
    // MARK: - Initializers
    
    public init(network: String) {
        self.network = network
    }
    
    // MARK: - Methods
    public func reload() async throws {
        _ = try await getConfigs(reload: true)
    }
    
    public func getTokens() async throws -> [String: TokenValue] {
        try await getConfigs().tokens
    }
    
    public func getAquafarms() async throws -> [String: Aquafarm] {
        try await getConfigs().aquafarms
    }
    
    public func getPools() async throws -> [String: Pool] {
        try await getConfigs().pools
    }
    
    public func getProgramID() async throws -> ProgramIDS {
        try await getConfigs().programIDS
    }
    
    // MARK: - Helpers
    private func getConfigs(reload: Bool = false) async throws -> OrcaConfigs {
        if !reload, let cache = cache {
            return cache
        }
        // hack: network
        var network = network
        if network == "mainnet-beta" {network = "mainnet"}
        
        // prepare url
        let url = URL(string: urlString)!
        
        // get
        let (data, _): (Data, URLResponse)
        if #available(iOS 15.0, macOS 12.0, *) {
            (data, _) = try await URLSession.shared.data(for: .init(url: url))
        } else {
            (data, _) = try await URLSession.shared.data(from: url)
        }
        let configs = try JSONDecoder().decode(OrcaConfigs.self, from: data)
        
        locker.lock()
        cache = configs
        locker.unlock()
        
        return configs
    }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
    
    func data(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }

}
