---
title: Per-Package Scoring Procedure
description: Per-sub-package CLAUDE.md scoring procedure for /audit Phase 3.6 hook. Defines mechanical T1+T2+T3 (package-rebased), LAV evaluation per-package with LAV/T3 boundary rule, Synergy Bonus from package-local T1.2/T1.3 + T2.1/T2.2 pairs, cap tier resolution, Final formula, and degraded state handling. Consumed when /audit iterates monorepo_detection.package_roots_for_scoring[].
version: 1.0.0
applies_to: audit-score-v4.1.0
---

# Per-Package Scoring Procedure

This document defines the per-sub-package CLAUDE.md scoring procedure invoked by /audit Phase 3.6 (see `Detection-Spec-2b.md` §5 L577-594). For each package root in `monorepo_detection.package_roots_for_scoring[]` (capped at scored=50), if the sub-package's `CLAUDE.md` exists and is parseable, this procedure produces one entry in `claude_code_configuration_state.claude_md.subpackages[]` with required fields `[path, claude_md_path, final_score (0-100), cap_tier (50|60|100), lav_breakdown (L1-L6)]`.

## §0. Scope

**Authority**: Phase 2b spec phase DEC-5 (ALL L1-L6 package-local, NO root inheritance), DEC-6 (cap tier per-package independent), DEC-7 (no aggregate score; rollup is min/median/worst/counts only — see `per-package-rollup.md`).

**Inputs**:
- `package_root`: repo-relative path from `monorepo_detection.package_roots_for_scoring[i]`
- `sub_claude_md_path`: `<package_root>/CLAUDE.md`
- Sub-package directory tree rooted at `package_root` (for mechanical T1/T2/T3 file lookups)

**Output (when sub_claude_md exists and parseable)**:
- One `subpackages[]` entry: `{path, claude_md_path, final_score, cap_tier, lav_breakdown, source_evidence_indices?}`

**Output (when sub_claude_md missing or unparseable)**:
- No `subpackages[]` entry. Coverage counters updated (see `per-package-rollup.md` §1). For unparseable case, `monorepo_detection.notes[]` entry with stable code (see §7 below).

## §1. Mechanical T1+T2+T3 (Package-Rebased)

The package root is treated as the project root for mechanical evaluation. Root state is NEVER inherited (DEC-5).

### §1.1 T1 Foundation (per-package)

Apply `t1-foundation.md` rules with `<package_root>` as the project root:

- **T1.1 CLAUDE.md existence**: PASS (sub-package CLAUDE.md existence is the precondition for entering Phase 3.6 procedure; this is always PASS for entries that reach §1.1).
- **T1.2 Test command**: search sub-package CLAUDE.md (i.e., `<package_root>/CLAUDE.md`) for test commands. If found and runnable against package-local manifests (e.g., `<package_root>/package.json`) → PASS. If not found and sub-package has application code → FAIL. If sub-package is documentation/config only → SKIP.
- **T1.3 Build command**: same package-rebased logic against sub-package CLAUDE.md + manifests.
- **T1.4 Project overview**: search sub-package CLAUDE.md first 20 lines for description.

### §1.2 T2 Protection (per-package)

Apply `t2-protection.md` rules with `<package_root>` as the project root:

- **T2.1 Sensitive file protection**: check `<package_root>/.claude/settings.json` deny patterns. If sub-package has no `.claude/settings.json` → all T2 items SKIP. Root `.claude/settings.json` is NEVER inherited.
- **T2.2 Security rules**: check `<package_root>/.claude/rules/security.md` or sub-package CLAUDE.md security keywords.
- **T2.3 Hook configuration quality**: check `<package_root>/.claude/settings.json` hooks section.

When all T2 items SKIP (typical case — sub-packages rarely have own .claude/), DS falls back to T3 only per `scoring-model.md` L83-L85.

### §1.3 T3 Optimization (per-package)

Apply `t3-optimization.md` rules with `<package_root>` as the project root:

- **T3.1 Directory references**: extract paths from sub-package CLAUDE.md, check existence under `<package_root>/`.
- **T3.2 CLAUDE.md length**: count lines of sub-package CLAUDE.md.
- **T3.3 Command availability**: check sub-package CLAUDE.md commands against `<package_root>/package.json` etc.
- **T3.4-T3.7**: same package-rebased logic against `<package_root>/.claude/rules/`, `<package_root>/.claude/agents/`, `<package_root>/.mcp.json`, sub-package env-var files.

### §1.4 DS Computation (per-package)

After T1/T2/T3 evaluation:

```
T2_Score = sum(s_i × w_i) / sum(w_i)   for non-SKIP T2 items
T3_Score = sum(s_i × w_i) / sum(w_i)   for non-SKIP T3 items
DS = (T2_Score × 0.60 + T3_Score × 0.40) × 100

If T2 is all SKIP: DS = T3_Score × 100
If T3 is all SKIP: DS = T2_Score × 100
If both are all SKIP: DS = 0
```

This is identical to root DS formula (`scoring-model.md` L78-L85).

## §2. LAV/T3 Boundary Rule (per-package)

Apply `lav.md` L7-L15 boundary rule with sub-package context:

- If sub-package T3.1 detected missing directory (PARTIAL/FAIL) → sub-package L1 scores **0** for that issue. Sub-package L1 penalizes only structural inaccuracies beyond T3.1's mechanical scope.
- If sub-package T3.3 detected missing tool config (PARTIAL/FAIL) → sub-package L2 scores **0** for that issue.
- If sub-package T3.7 detected undocumented env vars (PARTIAL/FAIL) → sub-package L2 scores 0 (same axis).

**Critical**: T3 mechanical detection happens BEFORE LAV evaluation per `scoring-model.md` precedent. The boundary rule is applied per-sub-package independently. Root T3 detections do NOT suppress sub-package LAV (DEC-5: NO root inheritance).

Mechanical and LAV layers are complementary per-package, not redundant.
