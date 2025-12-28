---
name: guarding-git-workflow
description: "Ensures safe git operations and consistent branch workflow. This skill activates during git commands (commit, push, merge, rebase, reset), branch strategy discussions, or workflow planning."
---

# Git Workflow Guardian

Maintains git safety and workflow consistency for production-grade development.

## Activation Context

This skill activates during:
- Git operations: commit, push, branch, merge, rebase, reset
- Branch strategy or workflow discussions
- Merge timing decisions

## Resources

| Resource | Purpose |
|----------|---------|
| `scripts/git_safety_check.py` | Analyze git commands for risk |
| `REFERENCE.md` | Detailed branch strategies and conventions |

## Parallel Development Workflow

### Branch Lifecycle

Multiple tasks can run in parallel:

```
main (always deployable)
 ├── feat/task-1 ──────→ rebase → merge    (Developer A)
 ├── feat/task-2 ──────→ rebase → merge    (Developer B / parallel)
 └── feat/task-3 ──────→ rebase → merge    (same developer / parallel)
```

**Key principles:**
- All branches created from latest main (`git checkout main && git pull` first)
- Multiple tasks can run simultaneously
- Rebase from main before merge to handle conflicts
- Each merge is atomic and independently reversible

**Benefits:**
- Parallel development for team/multi-task scenarios
- Main stays deployable for hotfixes
- Each task independently reversible
- Conflicts resolved before merge (not after)

### Branch Naming Convention

```
feat/task-{id}-{slug}     # New feature
fix/bug-{id}-{slug}       # Bug fix
refactor/{slug}           # Refactoring
```

### Operation Risk Assessment

Before executing git operations, assess risk level:

**High-risk (require user confirmation):**

| Operation | Risk | Action |
|-----------|------|--------|
| `git push --force origin main` | Data loss | Explain impact, suggest `--force-with-lease` |
| `git reset --hard` on main | Loses work | Suggest stash first |
| `git rebase` on pushed branch | Rewrites history | Explain downstream impact |
| Deleting remote branches | Permanent | Confirm branch name |

**Standard operations (provide context):**

| Operation | Guidance |
|-----------|----------|
| Normal commit/push | Verify conventional commit format |
| Local branch creation | Suggest naming convention |
| Merge to main | Remind to delete branch after |

### Safety Check Script

Run before high-risk operations:

```bash
python scripts/git_safety_check.py "git push --force origin main"
python scripts/git_safety_check.py --analyze-repo
python scripts/git_safety_check.py --parallel-status  # Check parallel branches
```

### Parallel Branch Sync (Before Merge)

Always sync with main before merging:

```bash
git fetch origin
git rebase origin/main
# Resolve conflicts if any
git checkout main && git merge --no-ff feat/task-{id}
```

### Conflict Resolution

When parallel branches modify same files:

1. **Rebase first**: `git rebase origin/main`
2. **Resolve conflicts**: Edit conflicted files, `git add`, `git rebase --continue`
3. **Test after resolve**: Run tests to verify integration
4. **Then merge**: `git checkout main && git merge --no-ff <branch>`

## Commit Convention

Follow Conventional Commits format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Co-author footer:**
```
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Workflow Guidance

When discussing branch strategies, recommend independent branches:

**Pattern:**
```
每个任务独立分支 → 完成即合并 → 合并后删除
```

**Rationale:**
- Smaller, focused code reviews
- Faster feedback loops
- Easier rollback if issues found
- Main always production-ready

## Output Format

Provide context in Chinese at runtime:

```
Git 操作检查
========================

风险等级：{level}
操作：{command}

{warnings if any}

建议：
- {recommendations}

========================
```

**Tone:** Informative and helpful, not alarming
