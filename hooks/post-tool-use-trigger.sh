#!/bin/bash
# Ultra Builder Pro 4.3.3 - PostToolUse Trigger Hook
# Triggers skills after tool execution completes
# Skills: codex-reviewer (Edit/Write), guarding-test-quality (test files), syncing-docs (*.md)

# Source core functions
source "$(dirname "$0")/skill-trigger-core.sh"

# Read JSON input from stdin
INPUT_JSON=$(read_stdin_json)

# Tool information from JSON or env
TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.tool_name // empty' 2>/dev/null)
TOOL_NAME="${TOOL_NAME:-${CLAUDE_TOOL_NAME:-}}"
TOOL_INPUT=$(echo "$INPUT_JSON" | jq -r '.tool_input // empty' 2>/dev/null)
TOOL_INPUT="${TOOL_INPUT:-${CLAUDE_TOOL_INPUT:-}}"

# Exit if no tool name
if [ -z "$TOOL_NAME" ]; then
  exit 0
fi

TRIGGERED_SKILLS=()

# ============================================
# Edit/Write → Skill triggers based on file type
# ============================================
if [[ "$TOOL_NAME" =~ ^(Edit|Write|MultiEdit)$ ]]; then
  # Extract file path
  FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // empty' 2>/dev/null)

  if [ -z "$FILE_PATH" ]; then
    exit 0
  fi

  # ----------------------------------------
  # Test files → guarding-test-quality
  # ----------------------------------------
  if [[ "$FILE_PATH" =~ \.test\.(ts|tsx|js|jsx)$ ]] || \
     [[ "$FILE_PATH" =~ \.spec\.(ts|tsx|js|jsx)$ ]] || \
     [[ "$FILE_PATH" =~ __tests__/ ]]; then
    TRIGGERED_SKILLS+=("guarding-test-quality")
    log_skill_trigger "guarding-test-quality" "test-file-edit" "$FILE_PATH" "PostToolUse"
  fi

  # ----------------------------------------
  # Markdown files → syncing-docs
  # ----------------------------------------
  if [[ "$FILE_PATH" =~ \.md$ ]]; then
    TRIGGERED_SKILLS+=("syncing-docs")
    log_skill_trigger "syncing-docs" "doc-file-edit" "$FILE_PATH" "PostToolUse"
  fi

  # ----------------------------------------
  # Code files → codex-reviewer
  # (exclude test files and config files)
  # ----------------------------------------
  if [[ "$FILE_PATH" =~ \.(ts|tsx|js|jsx|py|go|rs|java|cpp|c|sol)$ ]] && \
     [[ ! "$FILE_PATH" =~ (\.test\.|\.spec\.|__tests__|node_modules|\.config\.) ]]; then
    TRIGGERED_SKILLS+=("codex-reviewer")
    log_skill_trigger "codex-reviewer" "code-file-edit" "$FILE_PATH" "PostToolUse"
  fi
fi

# ============================================
# Bash → Check for test execution results
# ============================================
if [ "$TOOL_NAME" = "Bash" ]; then
  COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty' 2>/dev/null)

  # Test commands → guarding-test-quality
  if echo "$COMMAND" | grep -qE "(npm test|yarn test|pnpm test|jest|vitest|pytest|go test|cargo test)"; then
    TRIGGERED_SKILLS+=("guarding-test-quality")
    log_skill_trigger "guarding-test-quality" "test-execution" "$COMMAND" "PostToolUse"
  fi
fi

# Codex skills require special output
CODEX_SKILLS=("codex-reviewer" "codex-test-gen" "codex-doc-reviewer" "codex-research-gen")
REGULAR_SKILLS=()
TRIGGERED_CODEX=()

for skill in "${TRIGGERED_SKILLS[@]}"; do
  is_codex=false
  for codex_skill in "${CODEX_SKILLS[@]}"; do
    if [ "$skill" = "$codex_skill" ]; then
      is_codex=true
      TRIGGERED_CODEX+=("$skill")
      break
    fi
  done
  if [ "$is_codex" = false ]; then
    REGULAR_SKILLS+=("$skill")
  fi
done

# Output Codex skills with mandatory execution message
if [ ${#TRIGGERED_CODEX[@]} -gt 0 ]; then
  echo ""
  echo "🔥 CODEX REQUIRED: ${TRIGGERED_CODEX[*]}"
  echo "⚠️ You MUST execute \`codex exec\` command. Manual analysis is NOT acceptable."
fi

# Output regular skills
if [ ${#REGULAR_SKILLS[@]} -gt 0 ]; then
  output_skill_activation "${REGULAR_SKILLS[@]}"
fi

exit 0
