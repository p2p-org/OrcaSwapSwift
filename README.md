# OrcaSwapSwift
A client for OrcaSwap, written in Swift

## How to use
```swift
import OrcaSwapSwift
```

* To test transitive swap with orca, the account must have some `SOL`, `SLIM` and `KURO` token
```swift
extension OrcaSwapTransitiveTests {
    var kuroPubkey: String {
        <KURO-pubkey-here>
    }
    
    var secretPhrase: String {
        <account-seed-phrases>
    }
    
    var slimPubkey: String {
        <SLIM-pubkey-here>
    }
}
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
