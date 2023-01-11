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