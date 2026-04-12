# TaskFlow API コンベンション

add-endpoint スキルのクイックリファレンス。完全な仕様は `docs/api-conventions.md` を参照してください。

## ルートパターン

- コレクション：`GET /api/<resource>` — ページネーション付きリスト
- 単一：`GET /api/<resource>/:id` — ID で取得
- 作成：`POST /api/<resource>` — Zod スキーマでボディをバリデーション
- 更新：`PATCH /api/<resource>/:id` — 部分更新
- 削除：`DELETE /api/<resource>/:id` — 論理削除（`deleted_at` を設定）

## レスポンスエンベロープ

すべてのレスポンスは `src/api/response.ts` の `sendSuccess()` または `sendError()` を使用：

```json
{ "ok": true, "data": { ... } }
{ "ok": false, "error": { "code": "NOT_FOUND", "message": "..." } }
```

## ファイル命名

- ハンドラ：`src/api/<resource>.ts`
- サービス：`src/services/<resource>-service.ts`
- リポジトリ：`src/repos/<resource>-repo.ts`
- モデル：`src/models/<resource>.ts`
- テスト：`tests/services/<resource>-service.test.ts`、`tests/api/<resource>.test.ts`
