---
name: enforcing-workflow
description: Enforces mandatory independent-branch workflow. TRIGGERS when discussing git branches, workflow strategy, or task management. BLOCKS any suggestion of unified/long-lived branches or workflow "options". ENFORCES one-task-one-branch-merge-delete cycle.
allowed-tools: Read
---

# Workflow Enforcement Guardian

**Purpose**: Prevent AI from suggesting alternative workflows. System uses ONLY independent-branch strategy.

## Triggers

**Activate when**:
- Discussing git workflow or branch strategy
- AI about to suggest workflow "options"
- Keywords: "unified", "batch", "option", "workflow choice"

**Do NOT activate for**:
- Simple branch naming questions
- Individual git commands

## Enforcement Rules

**IMMEDIATELY BLOCK if AI attempts to**:
- Present workflow alternatives ("Option 1 vs Option 2")
- Suggest unified/long-lived branches for multiple tasks
- Recommend delaying merges until "all tasks complete"
- Suggest freezing main branch

**ENFORCE mandatory workflow**:
- Each task = independent branch (feat/task-{id}-{description})
- Complete task → merge to main → delete branch
- Main branch always deployable
- NO unified branches, NO batch merges, NO workflow choices

**Reference**: `~/.claude/guidelines/git-workflow.md` Section: "CRITICAL: Workflow is Non-Negotiable"

## Output

When triggered, provide warning message reminding system of mandatory workflow.
Language: Chinese (simplified) at runtime; keep this file English-only.

---

**Rationale**: Production systems require main branch always deployable for hotfixes. Independent branches enable parallel work and isolated rollbacks.
