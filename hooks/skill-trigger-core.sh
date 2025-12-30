#!/bin/bash
# Ultra Builder Pro 4.3.3 - Skill Trigger Core
# Shared functions for skill triggering across all hook types

HOOKS_DIR="$(dirname "$0")"
SKILL_RULES="$HOME/.claude/skills/skill-rules.json"

# Read JSON from stdin if available
read_stdin_json() {
  if [ -t 0 ]; then
    echo "{}"
  else
    cat
  fi
}

# Get skill description from rules
get_skill_description() {
  local skill="$1"
  jq -r ".skills[\"$skill\"].description // \"\"" "$SKILL_RULES" 2>/dev/null
}

# Output skill activation message
output_skill_activation() {
  local skills=("$@")

  if [ ${#skills[@]} -eq 0 ]; then
    return
  fi

  echo ""
  echo "⚡ USING SKILLS: ${skills[*]}"
  echo "📌 You MUST invoke these skills using the Skill tool before responding."
}

# Log skill trigger to project log
log_skill_trigger() {
  local skill="$1"
  local match_reason="$2"
  local prompt_preview="$3"
  local hook_type="$4"

  local project_dir="${CLAUDE_PROJECT_DIR:-$HOME/.claude}"
  local log_dir="$project_dir"

  # Handle if project_dir ends with .claude
  if [[ "$project_dir" != */.claude ]]; then
    log_dir="$project_dir/.claude"
  fi

  local log_file="$log_dir/logs/skill-triggers.jsonl"

  mkdir -p "$(dirname "$log_file")" 2>/dev/null

  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
  local enforcement=$(jq -r ".skills[\"$skill\"].enforcement // \"auto\"" "$SKILL_RULES" 2>/dev/null)
  local priority=$(jq -r ".skills[\"$skill\"].priority // \"medium\"" "$SKILL_RULES" 2>/dev/null)

  echo "{\"timestamp\":\"$timestamp\",\"skill\":\"$skill\",\"matchReason\":\"$match_reason\",\"enforcement\":\"$enforcement\",\"priority\":\"$priority\",\"promptPreview\":\"$prompt_preview\",\"hookType\":\"$hook_type\"}" >> "$log_file" 2>/dev/null
}

# Check if file matches pattern
file_matches_pattern() {
  local file="$1"
  local pattern="$2"

  case "$pattern" in
    *.test.*|*.spec.*)
      [[ "$file" == *.test.* ]] || [[ "$file" == *.spec.* ]]
      ;;
    *.md)
      [[ "$file" == *.md ]]
      ;;
    *.sol)
      [[ "$file" == *.sol ]]
      ;;
    *.tsx|*.vue)
      [[ "$file" == *.tsx ]] || [[ "$file" == *.vue ]]
      ;;
    *)
      [[ "$file" == *"$pattern"* ]]
      ;;
  esac
}
