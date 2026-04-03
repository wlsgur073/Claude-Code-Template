<!-- markdownlint-disable-file MD024 -->

# Changelog

All notable changes to this project will be documented in this file.
Format inspired by [Keep a Changelog](https://keepachangelog.com/) with feature-driven grouping.
This project adheres to [Semantic Versioning](https://semver.org/).

## v2.5.0 (2026-04-02)

### Audit & Generate Skill Improvements

- `/audit` now checks security rules, agent configuration quality, and hook configuration (exit codes, statusMessage)
- `/generate` supports incremental mode — detects existing config, shows what's configured vs missing, adds only what you need
- `/generate` self-verification phase validates output before wrapping up
- Model routing suggestion in `/audit` recommends cost-optimal model diversity for agents

### Agent & Hook Pattern Upgrades

- Agent examples expanded from 2-section to 4-section structure (Scope/Rules/Constraints/Verification)
- Hook examples now include PreToolUse file protection with `exit 2` pattern alongside PostToolUse auto-linting
- YAML model comments (`# sonnet: ...`) for self-documenting agent definitions
- Model selection guidance table (haiku/sonnet/opus) with cost tradeoff notes

### Other Changes

- Replaced YAML frontmatter `date` field with independent per-file `version` (semver)
- Security rule file option added to `/generate` advanced features (Question 6c)
- Hook exit code `exit 1` → `exit 2` for proper Claude feedback on blocked actions
- Korean translations synced for all guide and template changes

## v2.4.0 (2026-03-31)

### Audit Skill

- New `/audit` skill validates Claude Code configuration health with weighted scoring (70/30 Essential/Alignment)
- Checks: CLAUDE.md existence, test/build commands, sensitive file protection, directory references, command availability

### Project Governance

- `docs/ROADMAP.md` with community-driven proposal process via GitHub Discussions
- `docs/plans/` directory for design and planning documents
- Roadmap proposals section added to `docs/CONTRIBUTING.md`

### Documentation Quality

- Restructured directories: `guide/` → `docs/guides/`, `ko-KR/` → `docs/i18n/ko-KR/`
- Quality audit across 14 files — improved clarity, conciseness, and consistency
- Removed deprecated `allowed-tools` from all skill frontmatter

## v2.3.0 (2026-03-30)

### Skill Robustness

- Bidirectional safety checks for project type detection in `/generate`
- Auto-routing between starter and advanced paths when project state changes mid-flow

## v2.2.2 (2026-03-30)

### Convention Alignment

- Plugin conventions aligned with official Claude Code standards
- Template consistency: unified `repos/` directory naming, fixed deny paths
- Development Approach section added to starter template

## v2.2.1 (2026-03-30)

### Skill Modularization

- Refactored monolithic SKILL.md (393 lines) into modular subdirectories: `templates/starter.md`, `templates/advanced.md`, `references/best-practices.md`

## v2.2.0 (2026-03-29)

### SessionStart & Marketplace

- SessionStart hook system (`hooks.json` + `session-start.sh`) — suggests `/generate` when no config found
- Plugin marketplace integration with enriched metadata ($schema, keywords, homepage)
- Major directory restructure: `starter/`, `advanced/`, `ecosystem/` → `templates/`
- Privacy policy (`docs/PRIVACY.md`) for marketplace submission

## v2.1.0 (2026-03-28)

### Plugin Distribution

- Plugin marketplace integration with `/generate` command
- Starter/advanced path branching with empty project detection
- Automated setup prompt for one-step project configuration
- Fixed Windows case-insensitive marketplace naming issue (NTFS rename failure)
- Renamed command from `/setup` to `/generate`

## v2.0.0 (2026-03-27)

### Architecture Overhaul

- 3-Tier architecture: `guide/` (education) + `templates/` (examples) + `plugin/` (automation)
- Community health files: CODE_OF_CONDUCT.md, CONTRIBUTING.md, SECURITY.md
- Korean translations for all 7 guides and README
- **Breaking:** Refactored `docs/` → `guide/` to reserve `docs/` for GitHub community health files

## v1.0.0 (2026-03-27) [DEPRECATED]

> **Deprecated:** v1.0.0 is no longer supported. The directory structure, plugin system, and usage workflow changed significantly in v2.0.0. Please use v2.4.0 or later.

- Initial release with 7 configuration guides
- Starter and advanced CLAUDE.md templates for TaskFlow
- Basic plugin structure with Claude Code integration
