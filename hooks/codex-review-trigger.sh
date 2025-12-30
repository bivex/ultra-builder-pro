#!/bin/bash
# Ultra Builder Pro 4.3 - Codex Review Trigger Hook
# Triggers Codex code review after Edit/Write operations on code files
# Part of Dual-Engine Collaborative Development System

set -e

# Get project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
if [[ "$PROJECT_DIR" == */.claude ]]; then
  CLAUDE_DIR="$PROJECT_DIR"
  CACHE_DIR="$PROJECT_DIR/cache"
  LOGS_DIR="$PROJECT_DIR/logs"
else
  CLAUDE_DIR="$PROJECT_DIR/.claude"
  CACHE_DIR="$PROJECT_DIR/.claude/cache"
  LOGS_DIR="$PROJECT_DIR/.claude/logs"
fi

# Create directories if needed
mkdir -p "$CACHE_DIR" "$LOGS_DIR"

# Configuration
REVIEW_TRIGGER_FILE="$CACHE_DIR/codex-review-pending.json"
ERROR_HISTORY_FILE="$CACHE_DIR/error-history.json"
MAX_RETRIES=3
SAME_ERROR_THRESHOLD=2

# Auto-execution settings (set via environment or config)
# CODEX_AUTO_REVIEW=true  - Enable automatic codex review
# CODEX_AUTO_REVIEW=false - Only show reminder (default)
AUTO_REVIEW="${CODEX_AUTO_REVIEW:-false}"
REVIEW_SCRIPT="$CLAUDE_DIR/skills/codex-reviewer/scripts/review.sh"

# Tool information from Claude Code
TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
TOOL_RESULT="${CLAUDE_TOOL_RESULT:-}"

# Code file extensions that trigger review
CODE_EXTENSIONS="ts|tsx|js|jsx|py|go|rs|java|cpp|c|cs|rb|php|swift|kt"

# Extract file path from tool result
extract_file_path() {
  local result="$1"
  # Try jq first
  local file_path=$(echo "$result" | jq -r '.file_path // .path // empty' 2>/dev/null)

  # Fallback to sed if jq fails
  if [ -z "$file_path" ]; then
    file_path=$(echo "$result" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
  fi

  echo "$file_path"
}

# Check if file is a code file
is_code_file() {
  local file="$1"
  if [[ "$file" =~ \.($CODE_EXTENSIONS)$ ]]; then
    # Exclude test files and node_modules
    if [[ "$file" =~ (\.test\.|\.spec\.|__tests__|node_modules) ]]; then
      return 1
    fi
    return 0
  fi
  return 1
}

# Add file to review queue
add_to_review_queue() {
  local file="$1"
  local tool="$2"
  local timestamp=$(date +%s)

  # Initialize or read existing queue
  local queue="[]"
  if [ -f "$REVIEW_TRIGGER_FILE" ]; then
    queue=$(cat "$REVIEW_TRIGGER_FILE")
  fi

  # Add new entry
  local new_entry=$(jq -n \
    --arg file "$file" \
    --arg tool "$tool" \
    --arg time "$timestamp" \
    '{file: $file, tool: $tool, timestamp: $time, reviewed: false}')

  # Append and keep last 10 files
  echo "$queue" | jq \
    --argjson entry "$new_entry" \
    '. += [$entry] | unique_by(.file) | .[-10:]' \
    > "$REVIEW_TRIGGER_FILE" 2>/dev/null
}

# Track error for stuck detection
track_error() {
  local error="$1"
  local timestamp=$(date +%s)

  # Initialize or read existing history
  local history="[]"
  if [ -f "$ERROR_HISTORY_FILE" ]; then
    history=$(cat "$ERROR_HISTORY_FILE")
  fi

  # Add new error
  local new_entry=$(jq -n \
    --arg error "$error" \
    --arg time "$timestamp" \
    '{error: $error, timestamp: $time}')

  # Keep last 10 errors
  echo "$history" | jq \
    --argjson entry "$new_entry" \
    '. += [$entry] | .[-10:]' \
    > "$ERROR_HISTORY_FILE" 2>/dev/null
}

# Check if stuck (same error repeated)
is_stuck() {
  if [ ! -f "$ERROR_HISTORY_FILE" ]; then
    echo "false"
    return
  fi

  # Count similar errors in recent history
  local recent_errors=$(cat "$ERROR_HISTORY_FILE" | jq -r '.[].error' | tail -$MAX_RETRIES)
  local unique_count=$(echo "$recent_errors" | sort -u | wc -l | tr -d ' ')
  local total_count=$(echo "$recent_errors" | wc -l | tr -d ' ')

  # If same error appears more than threshold times
  if [ "$total_count" -ge "$MAX_RETRIES" ] && [ "$unique_count" -le "$SAME_ERROR_THRESHOLD" ]; then
    echo "true"
  else
    echo "false"
  fi
}

# Execute auto review if enabled
execute_auto_review() {
  local file="$1"

  if [ "$AUTO_REVIEW" != "true" ]; then
    return 1
  fi

  if [ ! -x "$REVIEW_SCRIPT" ]; then
    echo "⚠️ Review script not found or not executable: $REVIEW_SCRIPT"
    return 1
  fi

  echo ""
  echo "🤖 AUTO-EXECUTING CODEX REVIEW..."
  echo ""

  # Run review script in background to not block
  "$REVIEW_SCRIPT" "$file" --auto >> "$LOGS_DIR/codex-review.log" 2>&1 &

  echo "📋 Review started in background. Check logs: $LOGS_DIR/codex-review.log"
  return 0
}

# Generate review reminder
generate_review_reminder() {
  local file="$1"

  cat <<EOF

🔍 CODEX REVIEW TRIGGERED

**Modified File**: $file

**Dual-Engine Protocol**:
1. Claude Code completed implementation
2. → Codex should review for:
   - Logic errors
   - Security vulnerabilities
   - Performance issues
   - Edge cases

**To trigger Codex review**, run:
\`\`\`bash
# Using skill script (recommended)
$REVIEW_SCRIPT "$file"

# Or using codex CLI directly
codex -q "Review the following file for bugs and security issues: $file"
\`\`\`

**To enable auto-review**, set environment variable:
\`\`\`bash
export CODEX_AUTO_REVIEW=true
\`\`\`

EOF
}

# Main logic
main() {
  # Only process Edit and Write tools
  if [[ ! "$TOOL_NAME" =~ ^(Edit|Write)$ ]]; then
    exit 0
  fi

  # Extract file path
  local modified_file=$(extract_file_path "$TOOL_RESULT")

  if [ -z "$modified_file" ]; then
    exit 0
  fi

  # Check if it's a code file
  if is_code_file "$modified_file"; then
    # Add to review queue
    add_to_review_queue "$modified_file" "$TOOL_NAME"

    # Log the trigger
    echo "[$(date -Iseconds)] Codex review triggered for: $modified_file" >> "$LOGS_DIR/codex-review.log"

    # Try auto-review first, fall back to reminder
    if ! execute_auto_review "$modified_file"; then
      # Auto-review disabled or failed, show reminder
      generate_review_reminder "$modified_file"
    fi
  fi

  # Check for stuck state
  if [ "$(is_stuck)" = "true" ]; then
    cat <<EOF

⚠️ STUCK DETECTION: Same error repeated $MAX_RETRIES times

**Role Swap Activated**:
- Previous: Claude Code → fix → fail
- Now: Codex → fix → Claude Code review

**Action**: Let Codex attempt the fix:
\`\`\`bash
codeagent-wrapper --backend codex - <<< "Fix the issue in $modified_file"
\`\`\`

EOF
  fi
}

# Run main
main

# Always exit successfully to not block workflow
exit 0
