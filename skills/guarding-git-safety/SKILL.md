---
name: guarding-git-safety
description: "Prevents dangerous git operations. TRIGGERS: Before force push, hard reset, or rebase commands. ACTIONS: Require confirmation for destructive operations on main branches."
allowed-tools: Bash
---

# Git Workflow Guardian

## Auto-Trigger Conditions

**Dangerous Command Detection**:
- `git push --force` - Force push
- `git reset --hard` - Hard reset
- `git rebase -i` - Interactive rebase
- `git clean -fd` - Clean untracked files
- `rm -rf .git` - Delete repository

**Smart Reminders**:
- Before commit: Check staging area
- Before push: Check unpushed commits
- Before merge: Check conflicts

## Protection Workflow

When detecting dangerous commands:
1. Display confirmation prompt (in Chinese)
2. Explain risks and suggest safe alternatives
3. Require explicit "continue" confirmation
4. Proceed only after user confirms

## Output Format

- Language: **Chinese (simplified)** at runtime
- Provide: Risk level, affected scope, safe alternatives
- Require: Explicit confirmation keyword

## Complete Reference

**Detailed documentation**: `REFERENCE.md`
- Dangerous operations analysis
- Confirmation prompt templates
- Smart suggestion workflows
- Commit message standards
- Branch strategy guide
- Recovery procedures
