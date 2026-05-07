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

# Drift family — checks 4 reasons in priority order.
# Outputs a single rendered line if any reason fires, else empty.
check_drift_family() {
  local primary=""
  local primary_message=""
  local other_count=0

  # Reason 1 (highest priority): legacy_mtime — any monitored manifest newer than profile.
  # Manifest list (23 paths) preserved from the pre-rewrite hook.
  for f in package.json package-lock.json pnpm-lock.yaml yarn.lock \
           pnpm-workspace.yaml lerna.json nx.json turbo.json rush.json \
           tsconfig.json \
           pyproject.toml poetry.lock uv.lock requirements.txt \
           go.mod go.sum \
           Cargo.toml Cargo.lock \
           pom.xml \
           Gemfile Gemfile.lock \
           .mcp.json .claude/settings.json; do
    if [ -f "$f" ] && [ "$f" -nt "$PROFILE" ]; then
      primary="legacy_mtime"
      primary_message="$f newer than profile"
      break
    fi
  done

  # Reason 2: schema_version_mismatch — profile.schema_version differs from plugin's expected.
  # Canonical version is 1.2.0 (current shipped profile schema).
  local PROFILE_SV
  PROFILE_SV=$(jq -r '.schema_version // ""' < "$PROFILE" 2>/dev/null || echo "")
  local EXPECTED_SV="1.2.0"
  if [ -n "$PROFILE_SV" ] && [ "$PROFILE_SV" != "$EXPECTED_SV" ]; then
    if [ -z "$primary" ]; then
      primary="schema_version_mismatch"
      primary_message="profile.schema_version $PROFILE_SV expected $EXPECTED_SV"
    else
      other_count=$((other_count + 1))
    fi
  fi

  # Reason 3: ecosystem_change — workspace declaration file present but profile records single_project.
  local PROFILE_MONOREPO_DETECTED
  PROFILE_MONOREPO_DETECTED=$(jq -r '.project_structure.monorepo_detection.detected // false' < "$PROFILE" 2>/dev/null || echo "false")
  local has_workspace_file="false"
  for wf in pnpm-workspace.yaml lerna.json nx.json turbo.json rush.json; do
    if [ -f "$wf" ]; then has_workspace_file="true"; break; fi
  done
  if [ "$has_workspace_file" = "true" ] && [ "$PROFILE_MONOREPO_DETECTED" = "false" ]; then
    if [ -z "$primary" ]; then
      primary="ecosystem_change"
      primary_message="workspace declaration present but profile records single_project"
    else
      other_count=$((other_count + 1))
    fi
  fi

  # Reason 4: scoring_contract_bump — profile.scoring_model_ack differs from plugin's current.
  # Plugin's current scoring contract ID is audit-score-v4.1.0.
  local PROFILE_SCORE_ACK
  PROFILE_SCORE_ACK=$(jq -r '.claude_code_configuration_state.scoring_model_ack.contract_id // ""' < "$PROFILE" 2>/dev/null || echo "")
  local EXPECTED_SCORE="audit-score-v4.1.0"
  if [ -n "$PROFILE_SCORE_ACK" ] && [ "$PROFILE_SCORE_ACK" != "$EXPECTED_SCORE" ]; then
    if [ -z "$primary" ]; then
      primary="scoring_contract_bump"
      primary_message="profile.scoring_model_ack $PROFILE_SCORE_ACK expected $EXPECTED_SCORE"
    else
      other_count=$((other_count + 1))
    fi
  fi

  if [ -z "$primary" ]; then
    echo ""
    return
  fi

  if [ "$other_count" -gt 0 ]; then
    echo "Drift: $primary_message (+$other_count other drift signals); run /guardians-of-the-claude:audit."
  else
    echo "Drift: $primary_message; run /guardians-of-the-claude:audit."
  fi
}

# Unresolved + repeated-decline family stubs — subsequent commits add the family logic.
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
