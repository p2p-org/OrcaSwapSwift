//
//  OrcaSwapFeesModel.swift
//  SolanaSwift
//
//  Created by Andrew Vasiliev on 11.01.2022.
//

import SolanaSwift

public struct OrcaSwapFeesModel {
    public let fees: SolanaSDK.FeeAmount
    public let liquidityProviderFees: [UInt64]
}
