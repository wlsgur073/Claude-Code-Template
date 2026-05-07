#!/usr/bin/env bash
# plugin/hooks/session-start.sh — Phase 6 SessionStart Orchestrator
# State-aware re-entry digest extending the prior 4-case bootstrap-detection hook.
# Read-only over canonical state. Source filter + lock-based dual-entry de-duplication.
# See docs/superpowers/v3-roadmap/phase-6-design.md v1.6.1 for full architecture.
set -e

PROFILE=".claude/.plugin-cache/guardians-of-the-claude/local/profile.json"
RECS=".claude/.plugin-cache/guardians-of-the-claude/local/recommendations.json"
LOCK_DIR=".claude/.plugin-cache/guardians-of-the-claude/local/.session-start.lock"

# Threshold constants (locked by T20 calibration; placeholders here):
N_DAYS=7      # unresolved age threshold
K_COUNT=3     # unresolved pending_count threshold
M_DECLINES=3  # repeated-decline threshold

# Wall clock with SMOKE_PINNED_UTC override for deterministic fixture runs.
if [ -n "${SMOKE_PINNED_UTC:-}" ]; then
  NOW_UTC=$(date -d "$SMOKE_PINNED_UTC" +%s 2>/dev/null \
    || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$SMOKE_PINNED_UTC" +%s 2>/dev/null \
    || echo "")
  [ -z "$NOW_UTC" ] && { echo "SMOKE_PINNED_UTC parse failed: $SMOKE_PINNED_UTC" >&2; exit 1; }
else
  NOW_UTC=$(date +%s)
fi

# Source filter (script-side; hooks.json matcher is the load-bearing first-line filter).
# Fail-open default: if jq is missing or stdin is malformed, default to startup.
SOURCE=$(jq -r '.source // "startup"' < /dev/stdin 2>/dev/null || echo "startup")
case "$SOURCE" in
  clear|compact) exit 0 ;;
esac

# Stale lock cleanup — capture mtime safely; skip cleanup on parse failure.
# Avoids the unsafe `|| echo 0` fallback that would synthesize an "ancient"
# age and falsely cleanup a valid lock.
if [ -d "$LOCK_DIR" ]; then
  LOCK_MTIME=$(stat -c %Y "$LOCK_DIR" 2>/dev/null || stat -f %m "$LOCK_DIR" 2>/dev/null || true)
  if [ -n "$LOCK_MTIME" ]; then
    LOCK_AGE=$(( NOW_UTC - LOCK_MTIME ))
    [ "$LOCK_AGE" -gt 30 ] && rmdir "$LOCK_DIR" 2>/dev/null
  fi
fi

# Parent dir ensure (in case skills haven't created local/ yet).
mkdir -p "$(dirname "$LOCK_DIR")" 2>/dev/null

# Atomic lock acquisition via mkdir; sibling entry exits silently.
# SIGKILL between mkdir and trap registration is an unrecoverable race;
# the 30s TTL stale-cleanup above is the explicit backstop.
mkdir "$LOCK_DIR" 2>/dev/null || exit 0
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT  # set ONLY after acquire

# Case 1: No Claude Code configuration at all (PRESERVED VERBATIM)
if [ ! -f "CLAUDE.md" ] && [ ! -f ".claude/settings.json" ]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "This project has no Claude Code configuration yet. The guardians-of-the-claude plugin is installed -- suggest the user run /guardians-of-the-claude:create to set up CLAUDE.md and .claude/ configuration through a guided interview."
  }
}
EOF
  exit 0
fi

# Case 2: Configuration exists but no profile yet (PRESERVED VERBATIM)
if [ ! -f "$PROFILE" ]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Claude Code configuration exists but no project profile has been generated yet. Running /guardians-of-the-claude:audit will generate a project profile for more accurate recommendations across all skills."
  }
}
EOF
  exit 0
fi

# Stackable family checks — stub implementations return empty until T12-T14.
# T15 wires emit_digest with priority order + char cap.
check_drift_family() { echo ""; }
check_unresolved_family() { echo ""; }
check_repeated_decline_family() { echo ""; }

DRIFT_LINE=$(check_drift_family)
UNRESOLVED_LINE=$(check_unresolved_family)
REPEATED_DECLINE_LINE=$(check_repeated_decline_family)

# Render digest only if at least one family fired (stub: never fires until T12-T14).
if [ -n "$DRIFT_LINE$UNRESOLVED_LINE$REPEATED_DECLINE_LINE" ]; then
  : # T15 fills in emit_digest
fi

exit 0
