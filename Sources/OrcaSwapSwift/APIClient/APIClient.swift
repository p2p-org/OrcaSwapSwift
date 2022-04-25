//
//  OrcaSwap+Data.swift
//  
//
//  Created by Chung Tran on 13/10/2021.
//

import Foundation
import RxSwift
import RxAlamofire

public protocol OrcaSwapAPIClient {
    var network: String {get}
    func reload() -> Completable
    func getTokens() -> Single<[String: TokenValue]>
    func getAquafarms() -> Single<[String: Aquafarm]>
    func getPools() -> Single<[String: Pool]>
    func getProgramID() -> Single<ProgramIDS>
}

public class APIClient: OrcaSwapAPIClient {
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
    public func reload() -> Completable {
        getConfigs(reload: true)
            .asCompletable()
    }
    
    public func getTokens() -> Single<[String : TokenValue]> {
        getConfigs().map {$0.tokens}
    }
    
    public func getAquafarms() -> Single<[String : Aquafarm]> {
        getConfigs().map {$0.aquafarms}
    }
    
    public func getPools() -> Single<[String : Pool]> {
        getConfigs().map {$0.pools}
    }
    
    public func getProgramID() -> Single<ProgramIDS> {
        getConfigs().map {$0.programIDS}
    }
    
    // MARK: - Helpers
    private func getConfigs(reload: Bool = false) -> Single<OrcaConfigs> {
        if !reload, let cache = cache {
            return .just(cache)
        }
        // hack: network
        var network = network
        if network == "mainnet-beta" {network = "mainnet"}
        
        // prepare url
        let url = URL(string: urlString)!
        
        // get
        return URLSession.shared.rx.data(.get, url)
            .take(1)
            .asSingle()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .map { try JSONDecoder().decode(OrcaConfigs.self, from: $0) }
            .do(onSuccess: { [weak self] configs in
                self?.locker.lock(); defer {self?.locker.unlock()}
                self?.cache = configs
            })
    }
}
