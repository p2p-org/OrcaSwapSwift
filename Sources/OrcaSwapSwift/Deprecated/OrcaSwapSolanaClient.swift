//
//  File.swift
//  
//
//  Created by Chung Tran on 13/10/2021.
//

import Foundation
import RxSwift
import SolanaSwift

@available(*, deprecated, message: "Use SolanaAPIClient instead")
public protocol OrcaSwapSolanaClient {
    func getTokenAccountBalance(pubkey: String, commitment: Commitment?) -> Single<TokenAccountBalance>
    
    func getMinimumBalanceForRentExemption(
        span: UInt64
    ) -> Single<UInt64>
    
    func checkIfAssociatedTokenAccountExists(
        owner: PublicKey?,
        mint: String
    ) -> Single<Bool>
    
    func prepareCreatingWSOLAccountAndCloseWhenDone(
        from owner: PublicKey,
        amount: Lamports,
        payer: PublicKey
    ) -> Single<AccountInstructions>
    
    func prepareForCreatingAssociatedTokenAccount(
        owner: PublicKey,
        mint: PublicKey,
        feePayer: PublicKey,
        closeAfterward: Bool
    ) -> Single<AccountInstructions>
    
    var endpoint: APIEndPoint {get}
    
    func serializeAndSend(
        preparedTransaction: PreparedTransaction,
        isSimulation: Bool
    ) -> Single<String>
    
    func prepareTransaction(
        instructions: [TransactionInstruction],
        signers: [Account],
        feePayer: PublicKey,
        accountsCreationFee: Lamports,
        recentBlockhash: String?,
        lamportsPerSignature: Lamports?
    ) -> Single<PreparedTransaction>
}

public protocol OrcaSwapAccountProvider {
    func getAccount() -> Account?
    func getNativeWalletAddress() -> PublicKey?
}

public protocol OrcaSwapSignatureConfirmationHandler {
    func waitForConfirmation(signature: String) -> Completable
}
