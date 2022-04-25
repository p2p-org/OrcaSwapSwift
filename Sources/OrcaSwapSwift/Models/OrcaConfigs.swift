// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let orcaConfigs = try? newJSONDecoder().decode(OrcaConfigs.self, from: jsonData)

import Foundation
import SolanaSwift

// MARK: - OrcaConfigs
public struct OrcaConfigs: Codable {
    public let aquafarms: [String: Aquafarm]
    public let collectibles: Collectibles
    public let doubleDips: [String: DoubleDIP]
    public let pools: [String: Pool]
    public let programIDS: ProgramIDS
    public let tokens: [String: TokenValue]
    public let coingeckoIDS: [String: String]
    public let ftxIDS: FtxIDS

    enum CodingKeys: String, CodingKey {
        case aquafarms, collectibles, doubleDips, pools
        case programIDS = "programIds"
        case tokens
        case coingeckoIDS = "coingeckoIds"
        case ftxIDS = "ftxIds"
    }

    public init(aquafarms: [String: Aquafarm], collectibles: Collectibles, doubleDips: [String: DoubleDIP], pools: [String: Pool], programIDS: ProgramIDS, tokens: [String: TokenValue], coingeckoIDS: [String: String], ftxIDS: FtxIDS) {
        self.aquafarms = aquafarms
        self.collectibles = collectibles
        self.doubleDips = doubleDips
        self.pools = pools
        self.programIDS = programIDS
        self.tokens = tokens
        self.coingeckoIDS = coingeckoIDS
        self.ftxIDS = ftxIDS
    }
}

// MARK: - Aquafarm
public struct Aquafarm: Codable {
    public let account: String
    public let nonce: Int
    public let tokenProgramID: TokenEnum
    public let emissionsAuthority, removeRewardsAuthority: SAuthority
    public let baseTokenMint, baseTokenVault: String
    public let rewardTokenMint: RewardTokenMint
    public let rewardTokenVault, farmTokenMint: String

    enum CodingKeys: String, CodingKey {
        case account, nonce
        case tokenProgramID = "tokenProgramId"
        case emissionsAuthority, removeRewardsAuthority, baseTokenMint, baseTokenVault, rewardTokenMint, rewardTokenVault, farmTokenMint
    }

    public init(account: String, nonce: Int, tokenProgramID: TokenEnum, emissionsAuthority: SAuthority, removeRewardsAuthority: SAuthority, baseTokenMint: String, baseTokenVault: String, rewardTokenMint: RewardTokenMint, rewardTokenVault: String, farmTokenMint: String) {
        self.account = account
        self.nonce = nonce
        self.tokenProgramID = tokenProgramID
        self.emissionsAuthority = emissionsAuthority
        self.removeRewardsAuthority = removeRewardsAuthority
        self.baseTokenMint = baseTokenMint
        self.baseTokenVault = baseTokenVault
        self.rewardTokenMint = rewardTokenMint
        self.rewardTokenVault = rewardTokenVault
        self.farmTokenMint = farmTokenMint
    }
}

public enum SAuthority: String, Codable {
    case the6Ysd94BSnDknaaUitt3FyKia7BDcPjL7MseXDHSCKipV = "6Ysd94bSnDknaaUitt3FyKia7bDcPjL7MseXDHSCKipV"
}

public enum RewardTokenMint: String, Codable {
    case orcaEKTdK7LKz57VaAYr9QeNSVEPfiu6QeMU1KektZE = "orcaEKTdK7LKz57vaAYr9QeNsVEPfiu6QeMU1kektZE"
}

public enum TokenEnum: String, Codable {
    case tokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA = "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"
}

// MARK: - Collectibles
public struct Collectibles: Codable {
    public let guppy, whale, killerWhale, starfish: Clownfish
    public let clownfish, porpoise, hallowhale: Clownfish

    enum CodingKeys: String, CodingKey {
        case guppy = "GUPPY"
        case whale = "WHALE"
        case killerWhale = "KILLER WHALE"
        case starfish = "STARFISH"
        case clownfish = "CLOWNFISH"
        case porpoise = "PORPOISE"
        case hallowhale = "HALLOWHALE"
    }

    public init(guppy: Clownfish, whale: Clownfish, killerWhale: Clownfish, starfish: Clownfish, clownfish: Clownfish, porpoise: Clownfish, hallowhale: Clownfish) {
        self.guppy = guppy
        self.whale = whale
        self.killerWhale = killerWhale
        self.starfish = starfish
        self.clownfish = clownfish
        self.porpoise = porpoise
        self.hallowhale = hallowhale
    }
}

// MARK: - Clownfish
public struct Clownfish: Codable {
    public let mint: String
    public let decimals: Int

    public init(mint: String, decimals: Int) {
        self.mint = mint
        self.decimals = decimals
    }
}

// MARK: - DoubleDIP
public struct DoubleDIP: Codable {
    public let account: String
    public let nonce: Int
    public let tokenProgramID: TokenEnum
    public let emissionsAuthority: EmissionsAuthority
    public let removeRewardsAuthority: RemoveRewardsAuthority
    public let baseTokenMint, baseTokenVault, rewardTokenMint, rewardTokenVault: String
    public let farmTokenMint, dateStart, dateEnd, totalEmissions: String
    public let customGradientStartColor: String
    public let customGradientEndColor: String?

    enum CodingKeys: String, CodingKey {
        case account, nonce
        case tokenProgramID = "tokenProgramId"
        case emissionsAuthority, removeRewardsAuthority, baseTokenMint, baseTokenVault, rewardTokenMint, rewardTokenVault, farmTokenMint, dateStart, dateEnd, totalEmissions, customGradientStartColor, customGradientEndColor
    }

    public init(account: String, nonce: Int, tokenProgramID: TokenEnum, emissionsAuthority: EmissionsAuthority, removeRewardsAuthority: RemoveRewardsAuthority, baseTokenMint: String, baseTokenVault: String, rewardTokenMint: String, rewardTokenVault: String, farmTokenMint: String, dateStart: String, dateEnd: String, totalEmissions: String, customGradientStartColor: String, customGradientEndColor: String?) {
        self.account = account
        self.nonce = nonce
        self.tokenProgramID = tokenProgramID
        self.emissionsAuthority = emissionsAuthority
        self.removeRewardsAuthority = removeRewardsAuthority
        self.baseTokenMint = baseTokenMint
        self.baseTokenVault = baseTokenVault
        self.rewardTokenMint = rewardTokenMint
        self.rewardTokenVault = rewardTokenVault
        self.farmTokenMint = farmTokenMint
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.totalEmissions = totalEmissions
        self.customGradientStartColor = customGradientStartColor
        self.customGradientEndColor = customGradientEndColor
    }
}

public enum EmissionsAuthority: String, Codable {
    case the9TwucyMZQkxdmTZpCAZBatDq5EqfsaNU5JiLzRJDiYAC = "9TwucyMZQkxdmTZpCaZBatDq5EqfsaNU5JiLzRJDiYAC"
}

public enum RemoveRewardsAuthority: String, Codable {
    case eLYy1PEKynFY4QJosrniBG6BoCVMmWAw9F6B1613JBD = "eLYy1peKynFY4qJosrniBG6BoCVMmWAw9F6B1613JBD"
}

// MARK: - FtxIDS
public struct FtxIDS: Codable {
    public let atlas, btc, cope, eth: String
    public let fida, ftt, kin, maps: String
    public let media, mer, oxy, polis: String
    public let ray, slrs, sny, sol: String
    public let srm, step, usdc, usdt: String
    public let usdtSrm: String

    enum CodingKeys: String, CodingKey {
        case atlas = "ATLAS"
        case btc = "BTC"
        case cope = "COPE"
        case eth = "ETH"
        case fida = "FIDA"
        case ftt = "FTT"
        case kin = "KIN"
        case maps = "MAPS"
        case media = "MEDIA"
        case mer = "MER"
        case oxy = "OXY"
        case polis = "POLIS"
        case ray = "RAY"
        case slrs = "SLRS"
        case sny = "SNY"
        case sol = "SOL"
        case srm = "SRM"
        case step = "STEP"
        case usdc = "USDC"
        case usdt = "USDT"
        case usdtSrm = "USDT-SRM"
    }

    public init(atlas: String, btc: String, cope: String, eth: String, fida: String, ftt: String, kin: String, maps: String, media: String, mer: String, oxy: String, polis: String, ray: String, slrs: String, sny: String, sol: String, srm: String, step: String, usdc: String, usdt: String, usdtSrm: String) {
        self.atlas = atlas
        self.btc = btc
        self.cope = cope
        self.eth = eth
        self.fida = fida
        self.ftt = ftt
        self.kin = kin
        self.maps = maps
        self.media = media
        self.mer = mer
        self.oxy = oxy
        self.polis = polis
        self.ray = ray
        self.slrs = slrs
        self.sny = sny
        self.sol = sol
        self.srm = srm
        self.step = step
        self.usdc = usdc
        self.usdt = usdt
        self.usdtSrm = usdtSrm
    }
}

// MARK: - ProgramIDS
public struct ProgramIDS: Codable {
    public let serumTokenSwap, tokenSwapV2, tokenSwap: String
    public let token: TokenEnum
    public let aquafarm: String

    public init(serumTokenSwap: String, tokenSwapV2: String, tokenSwap: String, token: TokenEnum, aquafarm: String) {
        self.serumTokenSwap = serumTokenSwap
        self.tokenSwapV2 = tokenSwapV2
        self.tokenSwap = tokenSwap
        self.token = token
        self.aquafarm = aquafarm
    }
}

// MARK: - TokenValue
public struct TokenValue: Codable {
    public let mint, name: String
    public let decimals: Int
    public let fetchPrice, poolToken: Bool?
    public let wrapper: String?

    public init(mint: String, name: String, decimals: Int, fetchPrice: Bool?, poolToken: Bool?, wrapper: String?) {
        self.mint = mint
        self.name = name
        self.decimals = decimals
        self.fetchPrice = fetchPrice
        self.poolToken = poolToken
        self.wrapper = wrapper
    }
}
