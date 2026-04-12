# コードスタイル

## 命名規則
- 変数と関数：camelCase
- クラスとインターフェース：PascalCase
- 定数：UPPER_SNAKE_CASE
- ファイル名：kebab-case（例：`user-service.ts`）
- データベースカラム：snake_case

## フォーマット
- 2 スペースインデント
- 最大行長：100 文字
- 複数行の配列とオブジェクトに trailing comma
- セミコロン必須

## Import
- Import のグループ化：Node ビルトイン、外部パッケージ、内部モジュール
- named export を使用：`export { UserService }`（`export default` ではなく）
- path alias を使用：`@/services/user-service`（`../../../services/user-service` ではなく）

## 型
- オブジェクト形状には type alias より interface を優先
- Zod スキーマを信頼できる情報源として使用；`z.infer` で TypeScript 型を導出
- `any` の使用禁止 — `unknown` を使用し型ガードで絞り込むこと
