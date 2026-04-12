---
name: "add-endpoint"
description: "TaskFlow 用の REST API エンドポイントをハンドラ、サービス、リポジトリ、テスト、Zod スキーマとともにスキャフォールド"
argument-hint: "<resource> [operations]"
---

# ステップ

## Step 1: 情報収集

TaskFlow API パターンのために `references/api-conventions.md` を読みます。

`$ARGUMENTS` からリソース名と操作をパース（例：`/add-endpoint comment create,read,list,delete`）。`$ARGUMENTS` が空の場合、ユーザーに質問：
- リソース名は何ですか？（例："comment"）
- どの CRUD 操作が必要ですか？（例："create, read, list, delete"）
- 既存のエンティティに属しますか？（例：タスクコメントなら "tasks"）

## Step 2: 検証

- `src/api/` に当該リソースが既に存在しないことを確認
- ネストされたリソースの場合、親エンティティが存在することを確認
- 変更前にテストスイートが通過することを確認（`npm test`）

## Step 3: 実行

既存のパターンに従い、以下のファイルを作成：

1. `src/models/<resource>.ts` -- Zod スキーマと TypeScript 型
2. `src/repos/<resource>-repo.ts` -- データベースクエリを含むリポジトリクラス
3. `src/services/<resource>-service.ts` -- ビジネスロジックを含むサービスクラス
4. `src/api/<resource>.ts` -- asyncHandler ラッパーを使用するルートハンドラ
5. `tests/services/<resource>-service.test.ts` -- サービスユニットテスト
6. `tests/api/<resource>.test.ts` -- Supertest を使用した API 統合テスト

`src/api/index.ts` に新しいルートを登録。

## Step 4: 検証

- `npm run build` を実行して TypeScript コンパイルを確認
- `npm test` を実行してすべてのテスト通過を確認
- `src/api/index.ts` に新しいルートが登録されていることを確認
