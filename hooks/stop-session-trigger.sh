#!/bin/bash
# Ultra Builder Pro 4.3.3 - Stop Session Trigger Hook
# Triggers skills when conversation/session ends
# Skills: syncing-status (update feature-status.json), codex-test-gen (final test validation)

# Source core functions
source "$(dirname "$0")/skill-trigger-core.sh"

# Read JSON input from stdin
INPUT_JSON=$(read_stdin_json)

# Get session info
STOP_REASON=$(echo "$INPUT_JSON" | jq -r '.stop_reason // "unknown"' 2>/dev/null)

TRIGGERED_SKILLS=()

# ============================================
# Session End → syncing-status
# Always update status on session end
# ============================================
TRIGGERED_SKILLS+=("syncing-status")
log_skill_trigger "syncing-status" "session-end" "$STOP_REASON" "Stop"

# ============================================
# Note: codex-test-gen removed from Stop hook
# Now only triggers via /ultra-test command
# ============================================

# ============================================
# Output reminder for session summary
# ============================================
if [ ${#TRIGGERED_SKILLS[@]} -gt 0 ]; then
  echo ""
  echo "📊 SESSION ENDING - SYNC REQUIRED"
  echo "⚡ USING SKILLS: ${TRIGGERED_SKILLS[*]}"
  echo "📌 Please ensure status is synced before session ends."
fi

exit 0
