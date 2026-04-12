# ワークフロー

## 開発前チェックリスト

実装タスク開始前：

1. CLAUDE.md の関連セクションを読む
2. 修正する領域の既存テストをレビュー
3. API エンドポイント作業時は `docs/api-conventions.md` を確認
4. 変更前に `npm test` を実行してテストスイートの通過を確認

## レビューゲート

作業完了と判断する前：

- すべてのテスト通過（`npm test`）
- リント警告ゼロ（`npm run lint`）
- TypeScript がエラーなしでコンパイル（`npm run build`）
- 新しいコードが `architecture.md` のレイヤー構造に従っている
- API エンドポイントに JSDoc タグが含まれている：`@route`、`@method`、`@auth`
