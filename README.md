# GitHubClientAppWithGraphQL
### 概要
- GitHub API v4を利用したリポジトリを検索できるアプリ
- GraphQL + apollo-iosのサンプル

### 目的
- apollo-iosでキャッシュを制御するサンプルコードをシェア
- キャッシュポリシーによる挙動の違いを動作確認

### 準備
GitHubAccountのtokenが必要なので[こちら](https://github.com/settings/tokens)から作成してください。

<BR>

## 画面仕様

|トークン入力画面|検索画面（未取得状態）|検索画面（取得状態）|
|:-:|:-:|:-:|
|![Simulator Screenshot - iPhone 14 Pro - 2023-08-14 at 09 53 22](https://github.com/terry-private/GitHubClientAppWithGraphQL/assets/57483158/1eed837a-2864-4118-a992-0e2ef631c185)|![Simulator Screenshot - iPhone 14 Pro - 2023-08-10 at 17 21 40](https://github.com/terry-private/GitHubClientAppWithGraphQL/assets/57483158/f4aad89d-5918-4060-90f0-3b1cdac858d5)|![Simulator Screenshot - iPhone 14 Pro - 2023-08-10 at 17 28 45](https://github.com/terry-private/GitHubClientAppWithGraphQL/assets/57483158/7deae303-c6c4-4100-a6f5-63524263802c)|

### トークン入力画面
ユーザーデフォルトにトークンがない場合に表示

|||
|:-|:-|
|トークン入力フィールド|ユーザーデフォルトから初期値を取得|
|set!! ボタン|ユーザーデフォルトにセット|

### 検索画面
#### ２種類のClientを比較できるようにしている
- メモリキャッシュ: `InMemoryNormalizedCache`を使ったApolloClientを利用
- SQLiteキャッシュ: `SQLiteNormalizedCache`を使ったApolloClientを利用

|||
|:-|:-|
| 検索ワード | 初期値 "swift" |
| CachePolicy | 初期値 "returnCacheDataElseFetch" |
|| 選択しているCachePolicyの説明 |
| Clientメソッド | ***fetch***: API or キャッシュ(CachePolicyによる)からリポジトリのリストを取得 |
|| ***read cache***: キャッシュからリポジトリのリストを取得 |
|| ***clear cache***: キャッシュを削除する |
| clear list | 画面が保持しているリポジトリのリストを削除して未取得状態にする |
| リポジトリ一覧 | 画面が保持しているリポジトリのリストを表示 |
|reset token　| ユーザデフォルトに保存されているトークンを削除（トークン入力画面に表示切り替え） |

<BR>

## 動作確認例

### APIから取得するのか、キャッシュから取得するのか制御
- CachePolicyによっては最新の取得をできないケースがある
  - 例えば`returnCacheDataElseFetch`だと、キャッシュがある場合は必ずキャッシュから取得する
  - キャッシュを削除すればできるが、オフライン時にキャッシュを表示したい場合などを考慮すると、必要なキャッシュが無い瞬間ができてしまう
- オフライン時はAPIでの取得を試さず（エラーのアラートが出てしまうなどを回避したい）にいきなりキャッシュから取得したいケース

#### 実現例
- キャッシュポリシー`fetchIgnoringCacheData`を選択
- APIを使う場合は`fetch`, キャッシュから取得したい場合は`read`
- キャッシュから取得した結果、キャッシュがない場合に自動でAPIから取得する挙動はないので、使う側で判定してfetch
