# OrcaSwapSwift
A client for OrcaSwap, written in Swift

## How to use
* Import library
```swift
import OrcaSwapSwift
```

* Create instance of orca
```swift
let orcaSwap = OrcaSwap(
    apiClient: OrcaSwap.MockAPIClient(network: "mainnet"),
    solanaClient: solanaSDK,
    accountProvider: solanaSDK,
    notificationHandler: socket
)
```
* Swap
```swift
// load any dependencies for swap to work
orcaSwap.load()

// find any destination that can be swapped to from a defined token mint
orcaSwap.findPosibleDestinationMints(fromMint: btcMint)

// get multiple tradable pools pairs (or routes) for a token pair (each pool pairs contains 1 or 2 pools for swapping)
orcaSwap.getTradablePoolsPairs(fromMint: btcMint, toMint: ethMint)

// get bestPool pair for swapping from tradable pools pairs that got from getTradablePoolsPair method, this method return a pool pair that can be used for swapping
orcaSwap.findBestPoolsPairForInputAmount(inputAmount, from: poolsPairs)
orcaSwap.findBestPoolsPairForEstimatedAmount(estimatedAmount, from: poolsPairs)

// swap
orcaSwap.swap(
    fromWalletPubkey: <BTC wallet>,
    toWalletPubkey: <ETH wallet>?,
    bestPoolsPair: <best pool pair>,
    amount: amount,
    slippage: 0.05,
    isSimulation: false
)
    .subscribe(onNext: {result in
        print(result)
    })
    .disposed(by: disposeBag)
```

## Unit testing
There are 2 unit testings that are available: `OrcaSwapAPIClientTests` and `OrcaSwapPreparationTests`, the other tests are intergration tests

## Integration tests
Integration tests now works only on mainnet, devnet and testnet would be added later

### Direct swap
Create a json file `direct-swap-tests.json` inside `Resources` folder that contains following content:
```json
{
    "solToCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": "So11111111111111111111111111111111111111112",
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Owner address>,
        "destinationAddress": <String, Destination token address>,
        "poolsPair": [
            {
                name: <String, Name of pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ]
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    },
    "solToNonCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": "So11111111111111111111111111111111111111112",
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Owner address>,
        "destinationAddress": null,
        "poolsPair": [
            {
                name: <String, Name of pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ],
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    },
    "splToSol": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": <String, Mint of token that you want to swap from>,
        "toMint": "So11111111111111111111111111111111111111112",
        "sourceAddress": <String, Source token address>,
        "destinationAddress": <String, Owner address>,
        "poolsPair": [
            {
                name: <String, Name of pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ],
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    },
    "splToCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": <String, Mint of token that you want to swap from>,
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Source token address>,
        "destinationAddress": <String, Destination token address>,
        "poolsPair": [
            {
                name: <String, Name of pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true>
            }
        ],
        "inputAmount": 1,
        "slippage": 0.05
    },
    "splToNonCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": <String, Mint of token that you want to swap from>,
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Source token address>,
        "destinationAddress": null,
        "poolsPair": [
            {
                name: <String, Name of pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true>
            }
        ],
        "inputAmount": 1,
        "slippage": 0.05
    }
}
```

### Transitive swap
Create a json file `transitive-swap-tests.json` inside `Resources` folder that contains following content:
```json
{
    "solToCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": "So11111111111111111111111111111111111111112",
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Owner address>,
        "destinationAddress": <String, Destination token address>,
        "poolsPair": [
            {
                name: <String, Name of first pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            },
            {
                name: <String, Name of second pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ]
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    },
    "solToNonCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": "So11111111111111111111111111111111111111112",
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Owner address>,
        "destinationAddress": null,
        "poolsPair": [
            {
                name: <String, Name of first pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            },
            {
                name: <String, Name of second pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ]
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    },
    "splToSol": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": <String, Mint of token that you want to swap from>,
        "toMint": "So11111111111111111111111111111111111111112",
        "sourceAddress": <String, Source token address>,
        "destinationAddress": <String, Owner address>,
        "poolsPair": [
            {
                name: <String, Name of first pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            },
            {
                name: <String, Name of second pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ]
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    },
    "splToCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": <String, Mint of token that you want to swap from>,
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Source token address>,
        "destinationAddress": <String, Destination token address>,
        "poolsPair": [
            {
                name: <String, Name of first pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            },
            {
                name: <String, Name of second pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ],
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    },
    "splToNonCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": <String, Mint of token that you want to swap from>,
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Source token address>,
        "destinationAddress": null,
        "poolsPair": [
            {
                name: <String, Name of first pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            },
            {
                name: <String, Name of second pool, for example: SOCN/SOL[stable][aquafarm], see Resources/pools/orca-pools-mainnet.json>,
                reversed: <Bool, For example: if pool name equals to SOCN/SOL, and the swap is SOL to SOCN, then reversed == true> 
            }
        ],
        "inputAmount": <Double, Input amount>,
        "slippage": <Double>
    }
}
```
### Examples
Direct swap
```json
{
    "solToCreatedSpl": {
        "comment": "Swap from SOL to USDC",
        "endpoint": "https://api.mainnet-beta.solana.com/",
        "endpointAdditionalQuery": null,
        "seedPhrase": "<secret>",
        "fromMint": "So11111111111111111111111111111111111111112",
        "toMint": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
        "sourceAddress": "5bYReP8iw5UuLVS5wmnXfEfrYCKdiQ1FFAZQao8JqY7V",
        "destinationAddress": "mCZrAFuPfBDPUW45n5BSkasRLpPZpmqpY7vs3XSYE7x",
        "poolsPair": [
            {
                "name": "SOL/USDC",
                "reversed": false
            }
        ],
        "inputAmount": 0.0001,
        "slippage": 0.05
    },
    "solToNonCreatedSpl": {
        "comment": "Swap from SOL to USDT (non created)",
        "endpoint": "https://api.mainnet-beta.solana.com/",
        "endpointAdditionalQuery": null,
        "seedPhrase": "<secret>",
        "fromMint": "So11111111111111111111111111111111111111112",
        "toMint": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
        "sourceAddress": "5bYReP8iw5UuLVS5wmnXfEfrYCKdiQ1FFAZQao8JqY7V",
        "destinationAddress": null,
        "poolsPair": [
            {
                "name": "SOL/USDT[aquafarm]",
                "reversed": false
            }
        ],
        "inputAmount": 0.0001,
        "slippage": 0.05
    },
    "splToSol": {
        "comment": "Swap from USDC to SOL",
        "endpoint": "https://api.mainnet-beta.solana.com/",
        "endpointAdditionalQuery": null,
        "seedPhrase": "<secret>",
        "fromMint": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
        "toMint": "So11111111111111111111111111111111111111112",
        "sourceAddress": "mCZrAFuPfBDPUW45n5BSkasRLpPZpmqpY7vs3XSYE7x",
        "destinationAddress": "5bYReP8iw5UuLVS5wmnXfEfrYCKdiQ1FFAZQao8JqY7V",
        "poolsPair": [
            {
                "name": "SOL/USDC",
                "reversed": true
            }
        ],
        "inputAmount": 1,
        "slippage": 0.05
    },
    "splToCreatedSpl": {
        "comment": "Swap from USDC to KURO",
        "endpoint": "https://api.mainnet-beta.solana.com/",
        "endpointAdditionalQuery": null,
        "seedPhrase": "<secret>",
        "fromMint": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
        "toMint": "2Kc38rfQ49DFaKHQaWbijkE7fcymUMLY5guUiUsDmFfn",
        "sourceAddress": "mCZrAFuPfBDPUW45n5BSkasRLpPZpmqpY7vs3XSYE7x",
        "destinationAddress": "C5B13tQA4pq1zEVSVkWbWni51xdWB16C2QsC72URq9AJ",
        "poolsPair": [
            {
                "name": "KURO/USDC[aquafarm]",
                "reversed": true
            }
        ],
        "inputAmount": 1,
        "slippage": 0.05
    },
    "splToNonCreatedSpl": {
        "comment": "Swap from USDC to MNGO (non created)",
        "endpoint": "https://api.mainnet-beta.solana.com/",
        "endpointAdditionalQuery": null,
        "seedPhrase": "<secret>",
        "fromMint": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
        "toMint": "MangoCzJ36AjZyKwVj3VnYU4GTonjfVEnJmvvWaxLac",
        "sourceAddress": "mCZrAFuPfBDPUW45n5BSkasRLpPZpmqpY7vs3XSYE7x",
        "destinationAddress": null,
        "poolsPair": [
            {
                "name": "MNGO/USDC[aquafarm]",
                "reversed": true
            }
        ],
        "inputAmount": 1,
        "slippage": 0.05
    }
}

```
