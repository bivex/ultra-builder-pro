#!/bin/bash
# Ultra Builder Pro 4.3.3 - Skill Auto-Activation Hook
# Runs on UserPromptSubmit to suggest relevant skills

cd "$(dirname "$0")"

# Debug: Log environment variables (remove after debugging)
# echo "[DEBUG] CLAUDE_PROJECT_DIR=$CLAUDE_PROJECT_DIR" >> /tmp/skill-hook-debug.log
# echo "[DEBUG] CLAUDE_USER_PROMPT=${CLAUDE_USER_PROMPT:0:50}..." >> /tmp/skill-hook-debug.log

# Fallback: If CLAUDE_PROJECT_DIR is not set, try to detect it
if [ -z "$CLAUDE_PROJECT_DIR" ]; then
  # Check if we're in a project with .claude directory
  if [ -d "$PWD/.claude" ]; then
    export CLAUDE_PROJECT_DIR="$PWD"
  elif [ -d "$HOME/.claude" ]; then
    export CLAUDE_PROJECT_DIR="$HOME/.claude"
  fi
fi

# Run TypeScript hook (use npx to find ts-node from local node_modules)
npx ts-node skill-activation-prompt.ts 2>/dev/null
