---
title: "TaskFlow API エンドポイントルール"
description: "API ハンドラファイル作業時にのみ適用されるルール"
paths:
  - "src/api/**/*.ts"
---

# API エンドポイントルール

- すべてのエンドポイントは `src/models/` の Zod スキーマで入力をバリデーションすること
- すべてのルートハンドラで `asyncHandler` ラッパーを使用：
  ```typescript
  router.get('/tasks', asyncHandler(async (req, res) => { ... }))
  ```
- レスポンスは `src/api/response.ts` の `sendSuccess()` または `sendError()` を使って返す
- ハンドラから直接リポジトリメソッドを呼び出さない — サービスを経由すること
- パブリックエンドポイントには `src/api/middleware/rateLimit.ts` でレートリミットを適用
- すべてのエンドポイントに JSDoc タグで文書化：`@route`、`@method`、`@auth`
