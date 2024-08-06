# IllustAPIMock - pixiv/ios-tutorial

[pixiv/ios-tutorial](https://github.com/pixiv/ios-tutorial) で利用するライブラリです。学習目的でのみ利用できます

## Usage

```swift
import IllustAPIMock

let api = IllustAPIMock()

do {
    let rankingIllusts = try await api.getRanking()
    let recommendedIllusts = try await api.getRecommended()
    _ = try await api.postIsFavorited(illustID: ..., isFavorited: true)
} catch {
    ...
}
```

## Installation
Swift Package Managerを使ってインストールすることができます。Xcodeの `File > Add Packages...` から `https://github.com/pixiv/ios-tutorial-api-mock` を入力して利用できます

## Tips
有線LANを接続したMac上のiOS Simulatorで開発をしている場合、 `IllustError.networkError` が発生してAPIリクエストに失敗します。
次のコードに書き換えることで、シミュレーター上で動かすことが可能になります。

```swift
import IllustAPIMock

let api = IllustAPIMock()
api.networkMonitor = NetworkMonitorImpl(interfaceType: .wiredEthernet) // この行を追加

do {
    let rankingIllusts = try await api.getRanking()
    let recommendedIllusts = try await api.getRecommended()
    _ = try await api.postIsFavorited(illustID: ..., isFavorited: true)
} catch {
    ...
}
```

ただし、この変更を行ったコードを実機で動かした場合は、iPhone/iPadが有線LANに接続していない場合に `IllustError.networkError` が発生する点に注意して下さい。