# Project Overview

TaskFlow monorepo — API + web frontend. Root workspace manages shared
tooling; per-package CLAUDE.md files own package-specific conventions.

## Build & Run

pnpm install                   # install across all workspaces
pnpm --filter api dev          # run API in dev mode
pnpm --filter web dev          # run web in dev mode

## Testing

pnpm --filter api test
pnpm --filter web test

## Code Style & Conventions

- TypeScript strict mode across all packages
- Workspace imports via package name (not relative paths)
- Shared config lives in root (tsconfig.base.json, eslint.config.js)

## Important Context

- Monorepo — do not cross package boundaries without updating
  package.json dependencies
- Per-package CLAUDE.md files may override root defaults
