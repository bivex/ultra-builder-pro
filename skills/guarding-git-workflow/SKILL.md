---
name: guarding-git-workflow
description: "TRIGGERS when: git operations (commit/push/branch/merge/rebase/reset/delete), discussing branch strategy or merge timing, keywords 'force push'/'rebase'/'reset --hard'/'unified branch'/'batch merge'. BLOCKS dangerous operations (force push to main, hard reset on shared branches). DO NOT trigger for: code quality issues, non-git file operations."
allowed-tools: Read, Grep
---

# Git Guardian

## Purpose

Enforces git safety and workflow across two dimensions:
1. **Git Safety** - Prevent dangerous operations (force push, hard reset)
2. **Workflow Enforcement** - Mandate independent-branch workflow

## When

**Auto-triggers when**:
- Git operations: commit, push, branch, merge, rebase, reset, delete
- Discussing git workflow, branch strategy, or merge timing
- Keywords: "force push", "rebase", "reset --hard", "unified branch", "batch merge"

**Do NOT trigger for**:
- Code quality issues (handled by quality-guardian)
- Non-git file operations

## Do

### 1. Git Safety Prevention

**Load**: `REFERENCE.md` (Git Safety Rules section) when git operations detected

**Tiered Risk Management**:

**🔴 Critical Risk** (BLOCK immediately):
- `git push --force origin main/master`
- `git reset --hard` on main/shared branches
- Deleting main/master branch

**🟡 Medium Risk** (Require confirmation):
- `git rebase` on shared branches
- `git push origin --delete <branch>`
- `git commit --amend` on pushed commits
- Force push to any remote branch

**🟢 Low Risk** (Allow with reminder):
- Normal commit/push
- Local branch operations

**Output** (Chinese at runtime):
```
Dangerous operation detected message including:
- Risk level indicator (🔴/🟡/🟢)
- Command detected and risk description
- Recommended alternative action
- Reference to REFERENCE.md section
```

### 2. Workflow Enforcement

**Load**: `REFERENCE.md` (Workflow is Non-Negotiable section) when discussing workflow

**ENFORCE (mandatory)**:
```
main (always active, never frozen)
 ├── feat/task-1 (create → complete → merge → delete)
 ├── feat/task-2 (create → complete → merge → delete)
 └── feat/task-3 (create → complete → merge → delete)
```

**BLOCK immediately if**:
- Suggesting unified/long-lived feature branches
- Recommending delayed merges ("wait until all tasks complete")
- Presenting workflow "options" or "alternatives"
- Proposing to freeze main branch

**Rationale**:
- Production needs hotfix capability
- Each task independently reversible
- Main always deployable

**Output** (Chinese at runtime):
```
Workflow violation detected message including:
- Violation description
- Mandatory workflow rules (independent branches, immediate merge, deployable main)
- Correct approach pattern
- Reference to REFERENCE.md section
```

## Don't

- ❌ Trigger for code quality issues
- ❌ Trigger for non-git file operations
- ❌ Allow "workflow options" discussions (enforce one way)

## Outputs

**OUTPUT: User messages in Chinese at runtime; keep this file English-only.**

**Format**:
- Risk level emoji (🔴/🟡/🟢)
- Brief violation summary
- Specific command/proposal detected
- Actionable recommendation
- Guideline reference

**Tone**: Firm for Critical risks (block), educational for Medium/Low risks

---

**Token Efficiency**: ~150 tokens (vs 290 for 2 separate Skills). Loads git workflow guidelines on-demand.
