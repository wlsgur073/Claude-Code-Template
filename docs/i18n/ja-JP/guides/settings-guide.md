---
title: "settings.json の設定方法"
description: "設定ファイルで Claude Code の動作を構成する方法"
version: 1.0.0
---

# settings.json の設定方法

設定ファイルは Claude Code の動作 -- 権限、各種スイッチ、機能の構成 -- をコントロールします。指示を提供する CLAUDE.md とは異なり、設定は Claude が「何を行ってよいか」「どう動作するか」を構成するものです。

## 設定ファイルの場所

Claude Code は 4 つの場所から設定を読み込みます。スコープが広い順に並べると次のとおりです。

| スコープ | 場所 | git にコミット? | 用途 |
| ------- | --- | -------------- | ---- |
| 管理ポリシー | プラットフォーム固有のシステムパス | -- | 管理者が設定する組織全体のポリシー |
| ユーザー | `~/.claude/settings.json` | しない | すべてのプロジェクトに適用される個人の好み |
| プロジェクト | `.claude/settings.json` | する | チームで共有するプロジェクト構成 |
| ローカル | `.claude/settings.local.json` | しない | このプロジェクトに対する個人の上書き |

同じ設定が複数のレベルに登場した場合、より限定的なスコープが広いほうを上書きします。すべてのレベルの設定はマージされるため、変更したい設定だけを記述すれば十分です。

## どこに何を書くか

**プロジェクト** (`.claude/settings.json`) -- プロジェクトに関わる全員が使うチーム共有の構成です。よく使うコマンドの権限や、共有する deny ルールなど。このファイルはコミットしてください。

**ローカル** (`.claude/settings.local.json`) -- チームメイトに影響しないようにしたい個人の上書きです。`.gitignore` に追加してください。

**ユーザー** (`~/.claude/settings.json`) -- すべてのプロジェクトに適用される好みです。初心者がここを触る必要はめったにありません。

## $schema フィールド

`$schema` フィールドを追加すると、エディタの自動補完と検証が有効になります。

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [],
    "deny": []
  }
}
```

入力中にエディタが有効なキーを提案し、エラーを指摘してくれます。

## 初心者向けの主要オプション

### permissions.allow と permissions.deny

特定のツール操作を `Tool(specifier)` 構文で事前承認またはブロックします。

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test)",
      "Bash(npm run lint)",
      "Bash(npm run build)",
      "Bash(git diff *)",
      "Bash(git log *)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)"
    ]
  }
}
```

`allow` リストは、信頼するコマンドに対する権限プロンプトをなくします。`deny` リストは、Claude に絶対に実行させたくない操作をブロックします。まずはテストとビルドのコマンドから始めてください。最も安全で頻度の高いものです。

代表的なツール名: `Bash(command)`、`Read(path)`、`Edit(path)`、`Write(path)`。

権限ルールの完全な構文は [公式の権限ドキュメント](https://code.claude.com/docs/en/permissions#permission-rule-syntax)を参照してください。

### autoMemoryEnabled

Claude がプロジェクトに関する学びをメモリシステムに自動保存するかどうかを制御します。デフォルトでは有効です。

```json
{
  "autoMemoryEnabled": false
}
```

詳細は[自動メモリのドキュメント](https://code.claude.com/docs/en/memory#enable-or-disable-auto-memory)を参照してください。

### claudeMdExcludes

特定の CLAUDE.md ファイルをパスまたは glob パターンでスキップします。モノレポで自分の作業に関係のない CLAUDE.md がある場合に便利です。

```json
{
  "claudeMdExcludes": [
    "packages/legacy-app/CLAUDE.md",
    "vendor/**/CLAUDE.md"
  ]
}
```

詳細は[メモリのドキュメント](https://code.claude.com/docs/en/memory#exclude-specific-claudemd-files)を参照してください。

### hooks、env、enabledPlugins（高度）

`hooks` キーはツール使用の前後にシェルコマンドを実行します（自動 lint など）。`env` キーは Claude のコマンドに環境変数を設定します。`enabledPlugins` キーは公式プラグインをリストします。詳細と例は [Advanced Features ガイド](advanced-features-guide.md)を参照してください。

## プロジェクト設定に書いてはいけないもの

一部の設定はセキュリティ上の理由から `.claude/settings.json` で利用できません。たとえば `autoMemoryDirectory` はプロジェクト設定で指定できません。共有リポジトリが、開発者のマシン上の機密性のある場所にメモリ書き込みをリダイレクトしてしまう恐れがあるためです。

プロジェクト設定で制限されたオプションを指定しようとすると、Claude Code はそれを無視します。これらのオプションには、ユーザーレベルまたはローカルの設定を使ってください。

## さらに読む

- [はじめに](getting-started.md) -- 権限を含むセットアップ全体のウォークスルー
- [Directory Structure ガイド](directory-structure-guide.md) -- `.claude/` エコシステムにおける設定ファイルの位置
- [Rules ガイド](rules-guide.md) -- モジュール化された指示ファイル（設定とは別物）
