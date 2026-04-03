<!-- markdownlint-disable-file MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [2.5.0] - 2026-04-02

### Added

- Security rules, agent quality, and hook quality checks in `/audit`
- Incremental mode in `/generate` — detects existing config, adds only what's missing
- Self-verification phase (3.5) in `/generate` — validates output before wrapping up
- Model routing guidance (haiku/sonnet/opus) with cost tradeoff notes in advanced features guide
- Security rule file option in `/generate` advanced features

### Changed

- Agent examples: 2-section → 4-section (Scope/Rules/Constraints/Verification)
- Hook examples: added PreToolUse file protection with `exit 2` alongside PostToolUse auto-linting
- YAML model comments (`# sonnet: ...`) for self-documenting agent definitions
- Replaced YAML frontmatter `date` field with independent per-file `version` (semver)
- `/audit` scoring rebalanced to 70/30 (Essential/Alignment)

### Fixed

- Hook exit code `exit 1` → `exit 2` for proper Claude feedback on blocked actions
- Missing YAML frontmatter in 4 Korean rule files

## [2.4.0] - 2026-03-31

### Added

- `/audit` skill for validating Claude Code configuration health with weighted scoring
- `docs/ROADMAP.md` with community-driven proposal process
- `docs/plans/` directory for design and planning documents

### Changed

- Restructured directories: `guide/` → `docs/guides/`, `ko-KR/` → `docs/i18n/ko-KR/`
- Documentation quality audit across 14 files — improved clarity, conciseness, and consistency

### Fixed

- Removed deprecated `allowed-tools` from all skill frontmatter
- Updated stale path references in CONTRIBUTING.md

## [2.3.0] - 2026-03-30

### Added

- Bidirectional safety checks for project type detection in `/generate`
- Auto-routing between starter and advanced paths when project state changes mid-flow

## [2.2.2] - 2026-03-30

### Added

- Development Approach section in starter template

### Fixed

- Plugin conventions aligned with official Claude Code standards
- Template consistency: unified `repos/` directory naming, fixed deny paths

## [2.2.1] - 2026-03-30

### Changed

- Refactored monolithic SKILL.md (393 lines) into modular subdirectories: `templates/starter.md`, `templates/advanced.md`, `references/best-practices.md`

## [2.2.0] - 2026-03-29

### Added

- SessionStart hook system (`hooks.json` + `session-start.sh`)
- Plugin marketplace metadata enrichment ($schema, keywords, homepage)
- Privacy policy (`docs/PRIVACY.md`) for marketplace submission

### Changed

- Major directory restructure: `starter/`, `advanced/`, `ecosystem/` → `templates/`

## [2.1.0] - 2026-03-28

### Added

- Plugin marketplace integration with `/generate` command
- Starter/advanced path branching with empty project detection

### Changed

- Renamed command from `/setup` to `/generate`

### Fixed

- Windows case-insensitive marketplace naming issue (NTFS rename failure)

## [2.0.0] - 2026-03-27

### Added

- 3-Tier architecture: `guide/` (education) + `templates/` (examples) + `plugin/` (automation)
- Community health files: CODE_OF_CONDUCT.md, CONTRIBUTING.md, SECURITY.md
- Korean translations for all 7 guides and README

### Changed

- **Breaking:** Refactored `docs/` → `guide/` to reserve `docs/` for GitHub community health files

## [1.0.0] - 2026-03-27 [DEPRECATED]

> **Deprecated:** v1.0.0 is no longer supported. Please use v2.4.0 or later.

- Initial release with 7 configuration guides
- Starter and advanced CLAUDE.md templates for TaskFlow
- Basic plugin structure with Claude Code integration
