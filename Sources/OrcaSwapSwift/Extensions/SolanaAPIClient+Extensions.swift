import Foundation
import SolanaSwift

extension SolanaAPIClient {
    func checkIfAssociatedTokenAccountExists(
        owner: PublicKey,
        mint: String
    ) async throws -> Bool {
        
        let mintAddress = try mint.toPublicKey()
        
        let associatedTokenAccount = try PublicKey.associatedTokenAddress(
            walletAddress: owner,
            tokenMintAddress: mintAddress
        )
        
        do {
            let bufferInfo: BufferInfo<AccountInfo>? = try await getAccountInfo(account: associatedTokenAccount.base58EncodedString)
            return bufferInfo?.data.mint == mintAddress
        } catch {
            if error.isEqualTo(.couldNotRetrieveAccountInfo) {
                return false
            }
            throw error
        }
    }
}
