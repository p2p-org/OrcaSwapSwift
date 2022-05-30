// MARK: - Mocks generated from file: Sources/OrcaSwapSwift/OrcaSwap/OrcaSwap.swift at 2022-05-30 08:54:58 +0000

//
//  File.swift
//  
//
//  Created by Chung Tran on 06/05/2022.
//

import Cuckoo

import Foundation
import SolanaSwift


public class MockOrcaSwap: OrcaSwap, Cuckoo.ClassMock {
    
    public typealias MocksType = OrcaSwap
    
    public typealias Stubbing = __StubbingProxy_OrcaSwap
    public typealias Verification = __VerificationProxy_OrcaSwap

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: OrcaSwap?

    public func enableDefaultImplementation(_ stub: OrcaSwap) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public override var info: SwapInfo? {
        get {
            return cuckoo_manager.getter("info",
                superclassCall:
                    
                    super.info
                    ,
                defaultCall: __defaultImplStub!.info)
        }
        
        set {
            cuckoo_manager.setter("info",
                value: newValue,
                superclassCall:
                    
                    super.info = newValue
                    ,
                defaultCall: __defaultImplStub!.info = newValue)
        }
        
    }
    

    

    
    
    
    public override func load() async throws {
        
    return try await cuckoo_manager.callThrows("load() async throws",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                await super.load()
                ,
            defaultCall: await __defaultImplStub!.load())
        
    }
    
    
    
    public override func getMint(tokenName: String) -> String? {
        
    return cuckoo_manager.call("getMint(tokenName: String) -> String?",
            parameters: (tokenName),
            escapingParameters: (tokenName),
            superclassCall:
                
                super.getMint(tokenName: tokenName)
                ,
            defaultCall: __defaultImplStub!.getMint(tokenName: tokenName))
        
    }
    
    
    
    public override func findPosibleDestinationMints(fromMint: String) throws -> [String] {
        
    return try cuckoo_manager.callThrows("findPosibleDestinationMints(fromMint: String) throws -> [String]",
            parameters: (fromMint),
            escapingParameters: (fromMint),
            superclassCall:
                
                super.findPosibleDestinationMints(fromMint: fromMint)
                ,
            defaultCall: __defaultImplStub!.findPosibleDestinationMints(fromMint: fromMint))
        
    }
    
    
    
    public override func getTradablePoolsPairs(fromMint: String, toMint: String) async throws -> [PoolsPair] {
        
    return try await cuckoo_manager.callThrows("getTradablePoolsPairs(fromMint: String, toMint: String) async throws -> [PoolsPair]",
            parameters: (fromMint, toMint),
            escapingParameters: (fromMint, toMint),
            superclassCall:
                
                await super.getTradablePoolsPairs(fromMint: fromMint, toMint: toMint)
                ,
            defaultCall: await __defaultImplStub!.getTradablePoolsPairs(fromMint: fromMint, toMint: toMint))
        
    }
    
    
    
    public override func findBestPoolsPairForInputAmount(_ inputAmount: UInt64, from poolsPairs: [PoolsPair]) throws -> PoolsPair? {
        
    return try cuckoo_manager.callThrows("findBestPoolsPairForInputAmount(_: UInt64, from: [PoolsPair]) throws -> PoolsPair?",
            parameters: (inputAmount, poolsPairs),
            escapingParameters: (inputAmount, poolsPairs),
            superclassCall:
                
                super.findBestPoolsPairForInputAmount(inputAmount, from: poolsPairs)
                ,
            defaultCall: __defaultImplStub!.findBestPoolsPairForInputAmount(inputAmount, from: poolsPairs))
        
    }
    
    
    
    public override func findBestPoolsPairForEstimatedAmount(_ estimatedAmount: UInt64, from poolsPairs: [PoolsPair]) throws -> PoolsPair? {
        
    return try cuckoo_manager.callThrows("findBestPoolsPairForEstimatedAmount(_: UInt64, from: [PoolsPair]) throws -> PoolsPair?",
            parameters: (estimatedAmount, poolsPairs),
            escapingParameters: (estimatedAmount, poolsPairs),
            superclassCall:
                
                super.findBestPoolsPairForEstimatedAmount(estimatedAmount, from: poolsPairs)
                ,
            defaultCall: __defaultImplStub!.findBestPoolsPairForEstimatedAmount(estimatedAmount, from: poolsPairs))
        
    }
    
    
    
    public override func getLiquidityProviderFee(bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double) throws -> [UInt64] {
        
    return try cuckoo_manager.callThrows("getLiquidityProviderFee(bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double) throws -> [UInt64]",
            parameters: (bestPoolsPair, inputAmount, slippage),
            escapingParameters: (bestPoolsPair, inputAmount, slippage),
            superclassCall:
                
                super.getLiquidityProviderFee(bestPoolsPair: bestPoolsPair, inputAmount: inputAmount, slippage: slippage)
                ,
            defaultCall: __defaultImplStub!.getLiquidityProviderFee(bestPoolsPair: bestPoolsPair, inputAmount: inputAmount, slippage: slippage))
        
    }
    
    
    
    public override func getNetworkFees(myWalletsMints: [String], fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double, lamportsPerSignature: UInt64, minRentExempt: UInt64) async throws -> FeeAmount {
        
    return try await cuckoo_manager.callThrows("getNetworkFees(myWalletsMints: [String], fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double, lamportsPerSignature: UInt64, minRentExempt: UInt64) async throws -> FeeAmount",
            parameters: (myWalletsMints, fromWalletPubkey, toWalletPubkey, bestPoolsPair, inputAmount, slippage, lamportsPerSignature, minRentExempt),
            escapingParameters: (myWalletsMints, fromWalletPubkey, toWalletPubkey, bestPoolsPair, inputAmount, slippage, lamportsPerSignature, minRentExempt),
            superclassCall:
                
                await super.getNetworkFees(myWalletsMints: myWalletsMints, fromWalletPubkey: fromWalletPubkey, toWalletPubkey: toWalletPubkey, bestPoolsPair: bestPoolsPair, inputAmount: inputAmount, slippage: slippage, lamportsPerSignature: lamportsPerSignature, minRentExempt: minRentExempt)
                ,
            defaultCall: await __defaultImplStub!.getNetworkFees(myWalletsMints: myWalletsMints, fromWalletPubkey: fromWalletPubkey, toWalletPubkey: toWalletPubkey, bestPoolsPair: bestPoolsPair, inputAmount: inputAmount, slippage: slippage, lamportsPerSignature: lamportsPerSignature, minRentExempt: minRentExempt))
        
    }
    
    
    
    public override func prepareForSwapping(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, feePayer: PublicKey?, slippage: Double) async throws -> ([PreparedSwapTransaction], String? /*New created account*/) {
        
    return try await cuckoo_manager.callThrows("prepareForSwapping(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, feePayer: PublicKey?, slippage: Double) async throws -> ([PreparedSwapTransaction], String? /*New created account*/)",
            parameters: (fromWalletPubkey, toWalletPubkey, bestPoolsPair, amount, feePayer, slippage),
            escapingParameters: (fromWalletPubkey, toWalletPubkey, bestPoolsPair, amount, feePayer, slippage),
            superclassCall:
                
                await super.prepareForSwapping(fromWalletPubkey: fromWalletPubkey, toWalletPubkey: toWalletPubkey, bestPoolsPair: bestPoolsPair, amount: amount, feePayer: feePayer, slippage: slippage)
                ,
            defaultCall: await __defaultImplStub!.prepareForSwapping(fromWalletPubkey: fromWalletPubkey, toWalletPubkey: toWalletPubkey, bestPoolsPair: bestPoolsPair, amount: amount, feePayer: feePayer, slippage: slippage))
        
    }
    
    
    
    public override func swap(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, slippage: Double, isSimulation: Bool) async throws -> SwapResponse {
        
    return try await cuckoo_manager.callThrows("swap(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, slippage: Double, isSimulation: Bool) async throws -> SwapResponse",
            parameters: (fromWalletPubkey, toWalletPubkey, bestPoolsPair, amount, slippage, isSimulation),
            escapingParameters: (fromWalletPubkey, toWalletPubkey, bestPoolsPair, amount, slippage, isSimulation),
            superclassCall:
                
                await super.swap(fromWalletPubkey: fromWalletPubkey, toWalletPubkey: toWalletPubkey, bestPoolsPair: bestPoolsPair, amount: amount, slippage: slippage, isSimulation: isSimulation)
                ,
            defaultCall: await __defaultImplStub!.swap(fromWalletPubkey: fromWalletPubkey, toWalletPubkey: toWalletPubkey, bestPoolsPair: bestPoolsPair, amount: amount, slippage: slippage, isSimulation: isSimulation))
        
    }
    
    
    
    public override func prepareAndSend(_ swapTransaction: PreparedSwapTransaction, feePayer: PublicKey, isSimulation: Bool) async throws -> String {
        
    return try await cuckoo_manager.callThrows("prepareAndSend(_: PreparedSwapTransaction, feePayer: PublicKey, isSimulation: Bool) async throws -> String",
            parameters: (swapTransaction, feePayer, isSimulation),
            escapingParameters: (swapTransaction, feePayer, isSimulation),
            superclassCall:
                
                await super.prepareAndSend(swapTransaction, feePayer: feePayer, isSimulation: isSimulation)
                ,
            defaultCall: await __defaultImplStub!.prepareAndSend(swapTransaction, feePayer: feePayer, isSimulation: isSimulation))
        
    }
    
    
    
    public override func findRoutes(fromTokenName: String?, toTokenName: String?) throws -> Routes {
        
    return try cuckoo_manager.callThrows("findRoutes(fromTokenName: String?, toTokenName: String?) throws -> Routes",
            parameters: (fromTokenName, toTokenName),
            escapingParameters: (fromTokenName, toTokenName),
            superclassCall:
                
                super.findRoutes(fromTokenName: fromTokenName, toTokenName: toTokenName)
                ,
            defaultCall: __defaultImplStub!.findRoutes(fromTokenName: fromTokenName, toTokenName: toTokenName))
        
    }
    

	public struct __StubbingProxy_OrcaSwap: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var info: Cuckoo.ClassToBeStubbedOptionalProperty<MockOrcaSwap, SwapInfo> {
	        return .init(manager: cuckoo_manager, name: "info")
	    }
	    
	    
	    func load() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "load() async throws", parameterMatchers: matchers))
	    }
	    
	    func getMint<M1: Cuckoo.Matchable>(tokenName: M1) -> Cuckoo.ClassStubFunction<(String), String?> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tokenName) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "getMint(tokenName: String) -> String?", parameterMatchers: matchers))
	    }
	    
	    func findPosibleDestinationMints<M1: Cuckoo.Matchable>(fromMint: M1) -> Cuckoo.ClassStubThrowingFunction<(String), [String]> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: fromMint) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "findPosibleDestinationMints(fromMint: String) throws -> [String]", parameterMatchers: matchers))
	    }
	    
	    func getTradablePoolsPairs<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fromMint: M1, toMint: M2) -> Cuckoo.ClassStubThrowingFunction<(String, String), [PoolsPair]> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: fromMint) { $0.0 }, wrap(matchable: toMint) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "getTradablePoolsPairs(fromMint: String, toMint: String) async throws -> [PoolsPair]", parameterMatchers: matchers))
	    }
	    
	    func findBestPoolsPairForInputAmount<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ inputAmount: M1, from poolsPairs: M2) -> Cuckoo.ClassStubThrowingFunction<(UInt64, [PoolsPair]), PoolsPair?> where M1.MatchedType == UInt64, M2.MatchedType == [PoolsPair] {
	        let matchers: [Cuckoo.ParameterMatcher<(UInt64, [PoolsPair])>] = [wrap(matchable: inputAmount) { $0.0 }, wrap(matchable: poolsPairs) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "findBestPoolsPairForInputAmount(_: UInt64, from: [PoolsPair]) throws -> PoolsPair?", parameterMatchers: matchers))
	    }
	    
	    func findBestPoolsPairForEstimatedAmount<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ estimatedAmount: M1, from poolsPairs: M2) -> Cuckoo.ClassStubThrowingFunction<(UInt64, [PoolsPair]), PoolsPair?> where M1.MatchedType == UInt64, M2.MatchedType == [PoolsPair] {
	        let matchers: [Cuckoo.ParameterMatcher<(UInt64, [PoolsPair])>] = [wrap(matchable: estimatedAmount) { $0.0 }, wrap(matchable: poolsPairs) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "findBestPoolsPairForEstimatedAmount(_: UInt64, from: [PoolsPair]) throws -> PoolsPair?", parameterMatchers: matchers))
	    }
	    
	    func getLiquidityProviderFee<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(bestPoolsPair: M1, inputAmount: M2, slippage: M3) -> Cuckoo.ClassStubThrowingFunction<(PoolsPair?, Double?, Double), [UInt64]> where M1.OptionalMatchedType == PoolsPair, M2.OptionalMatchedType == Double, M3.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(PoolsPair?, Double?, Double)>] = [wrap(matchable: bestPoolsPair) { $0.0 }, wrap(matchable: inputAmount) { $0.1 }, wrap(matchable: slippage) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "getLiquidityProviderFee(bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double) throws -> [UInt64]", parameterMatchers: matchers))
	    }
	    
	    func getNetworkFees<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable, M8: Cuckoo.Matchable>(myWalletsMints: M1, fromWalletPubkey: M2, toWalletPubkey: M3, bestPoolsPair: M4, inputAmount: M5, slippage: M6, lamportsPerSignature: M7, minRentExempt: M8) -> Cuckoo.ClassStubThrowingFunction<([String], String, String?, PoolsPair?, Double?, Double, UInt64, UInt64), FeeAmount> where M1.MatchedType == [String], M2.MatchedType == String, M3.OptionalMatchedType == String, M4.OptionalMatchedType == PoolsPair, M5.OptionalMatchedType == Double, M6.MatchedType == Double, M7.MatchedType == UInt64, M8.MatchedType == UInt64 {
	        let matchers: [Cuckoo.ParameterMatcher<([String], String, String?, PoolsPair?, Double?, Double, UInt64, UInt64)>] = [wrap(matchable: myWalletsMints) { $0.0 }, wrap(matchable: fromWalletPubkey) { $0.1 }, wrap(matchable: toWalletPubkey) { $0.2 }, wrap(matchable: bestPoolsPair) { $0.3 }, wrap(matchable: inputAmount) { $0.4 }, wrap(matchable: slippage) { $0.5 }, wrap(matchable: lamportsPerSignature) { $0.6 }, wrap(matchable: minRentExempt) { $0.7 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "getNetworkFees(myWalletsMints: [String], fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double, lamportsPerSignature: UInt64, minRentExempt: UInt64) async throws -> FeeAmount", parameterMatchers: matchers))
	    }
	    
	    func prepareForSwapping<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable>(fromWalletPubkey: M1, toWalletPubkey: M2, bestPoolsPair: M3, amount: M4, feePayer: M5, slippage: M6) -> Cuckoo.ClassStubThrowingFunction<(String, String?, PoolsPair, Double, PublicKey?, Double), ([PreparedSwapTransaction], String? /*New created account*/)> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == PoolsPair, M4.MatchedType == Double, M5.OptionalMatchedType == PublicKey, M6.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, PoolsPair, Double, PublicKey?, Double)>] = [wrap(matchable: fromWalletPubkey) { $0.0 }, wrap(matchable: toWalletPubkey) { $0.1 }, wrap(matchable: bestPoolsPair) { $0.2 }, wrap(matchable: amount) { $0.3 }, wrap(matchable: feePayer) { $0.4 }, wrap(matchable: slippage) { $0.5 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "prepareForSwapping(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, feePayer: PublicKey?, slippage: Double) async throws -> ([PreparedSwapTransaction], String? /*New created account*/)", parameterMatchers: matchers))
	    }
	    
	    func swap<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable>(fromWalletPubkey: M1, toWalletPubkey: M2, bestPoolsPair: M3, amount: M4, slippage: M5, isSimulation: M6) -> Cuckoo.ClassStubThrowingFunction<(String, String?, PoolsPair, Double, Double, Bool), SwapResponse> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == PoolsPair, M4.MatchedType == Double, M5.MatchedType == Double, M6.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, PoolsPair, Double, Double, Bool)>] = [wrap(matchable: fromWalletPubkey) { $0.0 }, wrap(matchable: toWalletPubkey) { $0.1 }, wrap(matchable: bestPoolsPair) { $0.2 }, wrap(matchable: amount) { $0.3 }, wrap(matchable: slippage) { $0.4 }, wrap(matchable: isSimulation) { $0.5 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "swap(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, slippage: Double, isSimulation: Bool) async throws -> SwapResponse", parameterMatchers: matchers))
	    }
	    
	    func prepareAndSend<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ swapTransaction: M1, feePayer: M2, isSimulation: M3) -> Cuckoo.ClassStubThrowingFunction<(PreparedSwapTransaction, PublicKey, Bool), String> where M1.MatchedType == PreparedSwapTransaction, M2.MatchedType == PublicKey, M3.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(PreparedSwapTransaction, PublicKey, Bool)>] = [wrap(matchable: swapTransaction) { $0.0 }, wrap(matchable: feePayer) { $0.1 }, wrap(matchable: isSimulation) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "prepareAndSend(_: PreparedSwapTransaction, feePayer: PublicKey, isSimulation: Bool) async throws -> String", parameterMatchers: matchers))
	    }
	    
	    func findRoutes<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(fromTokenName: M1, toTokenName: M2) -> Cuckoo.ClassStubThrowingFunction<(String?, String?), Routes> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?)>] = [wrap(matchable: fromTokenName) { $0.0 }, wrap(matchable: toTokenName) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockOrcaSwap.self, method: "findRoutes(fromTokenName: String?, toTokenName: String?) throws -> Routes", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_OrcaSwap: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var info: Cuckoo.VerifyOptionalProperty<SwapInfo> {
	        return .init(manager: cuckoo_manager, name: "info", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func load() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("load() async throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getMint<M1: Cuckoo.Matchable>(tokenName: M1) -> Cuckoo.__DoNotUse<(String), String?> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tokenName) { $0 }]
	        return cuckoo_manager.verify("getMint(tokenName: String) -> String?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findPosibleDestinationMints<M1: Cuckoo.Matchable>(fromMint: M1) -> Cuckoo.__DoNotUse<(String), [String]> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: fromMint) { $0 }]
	        return cuckoo_manager.verify("findPosibleDestinationMints(fromMint: String) throws -> [String]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getTradablePoolsPairs<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fromMint: M1, toMint: M2) -> Cuckoo.__DoNotUse<(String, String), [PoolsPair]> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: fromMint) { $0.0 }, wrap(matchable: toMint) { $0.1 }]
	        return cuckoo_manager.verify("getTradablePoolsPairs(fromMint: String, toMint: String) async throws -> [PoolsPair]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findBestPoolsPairForInputAmount<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ inputAmount: M1, from poolsPairs: M2) -> Cuckoo.__DoNotUse<(UInt64, [PoolsPair]), PoolsPair?> where M1.MatchedType == UInt64, M2.MatchedType == [PoolsPair] {
	        let matchers: [Cuckoo.ParameterMatcher<(UInt64, [PoolsPair])>] = [wrap(matchable: inputAmount) { $0.0 }, wrap(matchable: poolsPairs) { $0.1 }]
	        return cuckoo_manager.verify("findBestPoolsPairForInputAmount(_: UInt64, from: [PoolsPair]) throws -> PoolsPair?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findBestPoolsPairForEstimatedAmount<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ estimatedAmount: M1, from poolsPairs: M2) -> Cuckoo.__DoNotUse<(UInt64, [PoolsPair]), PoolsPair?> where M1.MatchedType == UInt64, M2.MatchedType == [PoolsPair] {
	        let matchers: [Cuckoo.ParameterMatcher<(UInt64, [PoolsPair])>] = [wrap(matchable: estimatedAmount) { $0.0 }, wrap(matchable: poolsPairs) { $0.1 }]
	        return cuckoo_manager.verify("findBestPoolsPairForEstimatedAmount(_: UInt64, from: [PoolsPair]) throws -> PoolsPair?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getLiquidityProviderFee<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(bestPoolsPair: M1, inputAmount: M2, slippage: M3) -> Cuckoo.__DoNotUse<(PoolsPair?, Double?, Double), [UInt64]> where M1.OptionalMatchedType == PoolsPair, M2.OptionalMatchedType == Double, M3.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(PoolsPair?, Double?, Double)>] = [wrap(matchable: bestPoolsPair) { $0.0 }, wrap(matchable: inputAmount) { $0.1 }, wrap(matchable: slippage) { $0.2 }]
	        return cuckoo_manager.verify("getLiquidityProviderFee(bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double) throws -> [UInt64]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getNetworkFees<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable, M8: Cuckoo.Matchable>(myWalletsMints: M1, fromWalletPubkey: M2, toWalletPubkey: M3, bestPoolsPair: M4, inputAmount: M5, slippage: M6, lamportsPerSignature: M7, minRentExempt: M8) -> Cuckoo.__DoNotUse<([String], String, String?, PoolsPair?, Double?, Double, UInt64, UInt64), FeeAmount> where M1.MatchedType == [String], M2.MatchedType == String, M3.OptionalMatchedType == String, M4.OptionalMatchedType == PoolsPair, M5.OptionalMatchedType == Double, M6.MatchedType == Double, M7.MatchedType == UInt64, M8.MatchedType == UInt64 {
	        let matchers: [Cuckoo.ParameterMatcher<([String], String, String?, PoolsPair?, Double?, Double, UInt64, UInt64)>] = [wrap(matchable: myWalletsMints) { $0.0 }, wrap(matchable: fromWalletPubkey) { $0.1 }, wrap(matchable: toWalletPubkey) { $0.2 }, wrap(matchable: bestPoolsPair) { $0.3 }, wrap(matchable: inputAmount) { $0.4 }, wrap(matchable: slippage) { $0.5 }, wrap(matchable: lamportsPerSignature) { $0.6 }, wrap(matchable: minRentExempt) { $0.7 }]
	        return cuckoo_manager.verify("getNetworkFees(myWalletsMints: [String], fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double, lamportsPerSignature: UInt64, minRentExempt: UInt64) async throws -> FeeAmount", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func prepareForSwapping<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable>(fromWalletPubkey: M1, toWalletPubkey: M2, bestPoolsPair: M3, amount: M4, feePayer: M5, slippage: M6) -> Cuckoo.__DoNotUse<(String, String?, PoolsPair, Double, PublicKey?, Double), ([PreparedSwapTransaction], String? /*New created account*/)> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == PoolsPair, M4.MatchedType == Double, M5.OptionalMatchedType == PublicKey, M6.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, PoolsPair, Double, PublicKey?, Double)>] = [wrap(matchable: fromWalletPubkey) { $0.0 }, wrap(matchable: toWalletPubkey) { $0.1 }, wrap(matchable: bestPoolsPair) { $0.2 }, wrap(matchable: amount) { $0.3 }, wrap(matchable: feePayer) { $0.4 }, wrap(matchable: slippage) { $0.5 }]
	        return cuckoo_manager.verify("prepareForSwapping(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, feePayer: PublicKey?, slippage: Double) async throws -> ([PreparedSwapTransaction], String? /*New created account*/)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func swap<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable>(fromWalletPubkey: M1, toWalletPubkey: M2, bestPoolsPair: M3, amount: M4, slippage: M5, isSimulation: M6) -> Cuckoo.__DoNotUse<(String, String?, PoolsPair, Double, Double, Bool), SwapResponse> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == PoolsPair, M4.MatchedType == Double, M5.MatchedType == Double, M6.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, PoolsPair, Double, Double, Bool)>] = [wrap(matchable: fromWalletPubkey) { $0.0 }, wrap(matchable: toWalletPubkey) { $0.1 }, wrap(matchable: bestPoolsPair) { $0.2 }, wrap(matchable: amount) { $0.3 }, wrap(matchable: slippage) { $0.4 }, wrap(matchable: isSimulation) { $0.5 }]
	        return cuckoo_manager.verify("swap(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, slippage: Double, isSimulation: Bool) async throws -> SwapResponse", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func prepareAndSend<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ swapTransaction: M1, feePayer: M2, isSimulation: M3) -> Cuckoo.__DoNotUse<(PreparedSwapTransaction, PublicKey, Bool), String> where M1.MatchedType == PreparedSwapTransaction, M2.MatchedType == PublicKey, M3.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(PreparedSwapTransaction, PublicKey, Bool)>] = [wrap(matchable: swapTransaction) { $0.0 }, wrap(matchable: feePayer) { $0.1 }, wrap(matchable: isSimulation) { $0.2 }]
	        return cuckoo_manager.verify("prepareAndSend(_: PreparedSwapTransaction, feePayer: PublicKey, isSimulation: Bool) async throws -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func findRoutes<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(fromTokenName: M1, toTokenName: M2) -> Cuckoo.__DoNotUse<(String?, String?), Routes> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?)>] = [wrap(matchable: fromTokenName) { $0.0 }, wrap(matchable: toTokenName) { $0.1 }]
	        return cuckoo_manager.verify("findRoutes(fromTokenName: String?, toTokenName: String?) throws -> Routes", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class OrcaSwapStub: OrcaSwap {
        
    
    
    public override var info: SwapInfo? {
        get {
            return DefaultValueRegistry.defaultValue(for: (SwapInfo?).self)
        }
        
        set { }
        
    }
    

    

    
    
    
    public override func load() async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    public override func getMint(tokenName: String) -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    public override func findPosibleDestinationMints(fromMint: String) throws -> [String]  {
        return DefaultValueRegistry.defaultValue(for: ([String]).self)
    }
    
    
    
    public override func getTradablePoolsPairs(fromMint: String, toMint: String) async throws -> [PoolsPair]  {
        return DefaultValueRegistry.defaultValue(for: ([PoolsPair]).self)
    }
    
    
    
    public override func findBestPoolsPairForInputAmount(_ inputAmount: UInt64, from poolsPairs: [PoolsPair]) throws -> PoolsPair?  {
        return DefaultValueRegistry.defaultValue(for: (PoolsPair?).self)
    }
    
    
    
    public override func findBestPoolsPairForEstimatedAmount(_ estimatedAmount: UInt64, from poolsPairs: [PoolsPair]) throws -> PoolsPair?  {
        return DefaultValueRegistry.defaultValue(for: (PoolsPair?).self)
    }
    
    
    
    public override func getLiquidityProviderFee(bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double) throws -> [UInt64]  {
        return DefaultValueRegistry.defaultValue(for: ([UInt64]).self)
    }
    
    
    
    public override func getNetworkFees(myWalletsMints: [String], fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair?, inputAmount: Double?, slippage: Double, lamportsPerSignature: UInt64, minRentExempt: UInt64) async throws -> FeeAmount  {
        return DefaultValueRegistry.defaultValue(for: (FeeAmount).self)
    }
    
    
    
    public override func prepareForSwapping(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, feePayer: PublicKey?, slippage: Double) async throws -> ([PreparedSwapTransaction], String? /*New created account*/)  {
        return DefaultValueRegistry.defaultValue(for: (([PreparedSwapTransaction], String? /*New created account*/)).self)
    }
    
    
    
    public override func swap(fromWalletPubkey: String, toWalletPubkey: String?, bestPoolsPair: PoolsPair, amount: Double, slippage: Double, isSimulation: Bool) async throws -> SwapResponse  {
        return DefaultValueRegistry.defaultValue(for: (SwapResponse).self)
    }
    
    
    
    public override func prepareAndSend(_ swapTransaction: PreparedSwapTransaction, feePayer: PublicKey, isSimulation: Bool) async throws -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    public override func findRoutes(fromTokenName: String?, toTokenName: String?) throws -> Routes  {
        return DefaultValueRegistry.defaultValue(for: (Routes).self)
    }
    
}

