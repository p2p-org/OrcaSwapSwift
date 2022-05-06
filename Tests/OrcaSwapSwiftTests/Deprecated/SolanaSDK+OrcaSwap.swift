//
//  File.swift
//  
//
//  Created by Chung Tran on 18/10/2021.
//

import Foundation
import RxSwift
import OrcaSwapSwift
import SolanaSwift

extension SolanaSDK: OrcaSwapSolanaClient {}
extension SolanaSDK: OrcaSwapAccountProvider {}
extension SolanaSDK: OrcaSwapSignatureConfirmationHandler {}
