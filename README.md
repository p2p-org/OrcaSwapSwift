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
### Direct swap
Create a json file `direct-swap-tests.json` inside `Resources` folder that contains following content:
```json
{
    "solToCreatedSpl": {
        "endpoint": <String, Solana api endpoint>,
        "endpointAdditionalQuery": <String?>,
        "seedPhrase": <String, Solana account seed phrase>,
        "fromMint": <String, Mint of token that you want to swap from>,
        "toMint": <String, Mint of token that you want to swap to>,
        "sourceAddress": <String, Source token address>,
        "destinationAddress": <String?, Destination token address>,
        "payingTokenMint": <String, Mint of token that you want to use to pay fee>,
        "payingTokenAddress": <String, Address of token that have enough balance to cover fee>,
        "inputAmount": <UInt64, Input amount in lamports>,
        "slippage": <Double>
    }
}
```
