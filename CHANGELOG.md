<!-- markdownlint-disable-file MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- `docs/ROADMAP.md` with governance process for community-driven roadmap proposals
- Roadmap proposals section in `docs/CONTRIBUTING.md`
- Cross-references from advanced features guide to template examples (agents, skills)
- Korean translations for all template files (`ko-KR/templates/`)

## [2.3.0] - 2026-03-30

### Added

- Bidirectional safety checks for project type detection in generate skill
- Enhanced skill patterns with auto-routing between starter and advanced paths

## [2.2.2] - 2026-03-30

### Fixed

- Plugin conventions aligned with official Claude Code standards
- Template consistency: unified `repos/` directory naming, fixed deny paths

### Added

- `allowed-tools` convention documented in CLAUDE.md
- Development Approach section added to starter template

## [2.2.1] - 2026-03-30

### Changed

- Refactored monolithic SKILL.md (393 lines) into modular subdirectories
  - `templates/starter.md` — starter path instructions
  - `templates/advanced.md` — advanced path instructions
  - `references/best-practices.md` — generation quality standards

## [2.2.0] - 2026-03-29

### Changed

- Major directory restructure: `starter/`, `advanced/`, `ecosystem/` → `templates/`
- Moved `statusline.sh` to repository root

### Added

- SessionStart hook system (`hooks.json` + `session-start.sh`)
- Plugin metadata enrichment: `$schema`, keywords, homepage, tools frontmatter
- Privacy policy (`docs/PRIVACY.md`) for plugin marketplace submission

## [2.1.0] - 2026-03-28

### Added

- Plugin marketplace integration with `/generate` command
- Starter/advanced path branching with empty project support
- Automated setup prompt for one-step project configuration

### Fixed

- Windows case-insensitive marketplace naming issue (NTFS rename failure)

### Changed

- Renamed command from `/setup` to `/generate`

## [2.0.0] - 2026-03-27

### Added

- 3-Tier architecture: `guide/` (education) + `templates/` (examples) + `plugin/` (automation)
- Community health files: CODE_OF_CONDUCT.md, CONTRIBUTING.md, SECURITY.md
- Korean translations for all 7 guides and README (`ko-KR/`)
- Korean statusline template

### Changed

- **Breaking:** Refactored `docs/` → `guide/` to reserve `docs/` for GitHub community health files
- Replaced cost display with 5-hour rate limit bar in statusline

## [1.0.0] - 2026-03-27

### Added

- Initial release with 7 configuration guides
- Starter and advanced CLAUDE.md templates for TaskFlow
- Basic plugin structure with Claude Code integration
- `.gitattributes` to enforce LF line endings
