# Workflow Enforcement Guardian - Complete Reference

Complete guide for independent-branch workflow enforcement.

---

## Mandatory Workflow (Non-Negotiable)

```
✅ THE ONLY SUPPORTED WORKFLOW:
main (always active, never frozen)
 ├── feat/task-1-xxx (create → complete → merge → delete)
 ├── feat/task-2-yyy (create → complete → merge → delete)
 └── feat/task-3-zzz (create → complete → merge → delete)
```

---

## Forbidden Patterns (Auto-Block)

### 1. Unified Feature Branches
```bash
# ❌ FORBIDDEN: Long-lived branch for multiple tasks
git checkout -b feature/user-management
# Work on task 1, 2, 3, 4, 5...
# Merge only after ALL tasks complete

# ✅ CORRECT: Independent branches
git checkout -b feat/task-1-login
# Complete → Merge → Delete
git checkout -b feat/task-2-logout
# Complete → Merge → Delete
```

### 2. Freezing Main Branch
```bash
# ❌ FORBIDDEN: "Let's freeze main until all 31 tasks are done"
# This blocks hotfixes and urgent changes

# ✅ CORRECT: Main always deployable
# Each task merges independently
# Hotfixes can deploy immediately
```

### 3. Batch Merges
```bash
# ❌ FORBIDDEN: "Let's merge all tasks together at the end"
git merge feat/task-1
git merge feat/task-2
git merge feat/task-3  # All at once

# ✅ CORRECT: Merge each task when complete
git merge feat/task-1  # Day 1
git merge feat/task-2  # Day 2
git merge feat/task-3  # Day 3
```

---

## Why This is Mandatory

### Production Requirements
1. **Hotfix Readiness**: Main must be deployable for emergency fixes
2. **Risk Isolation**: Each task can be reverted independently
3. **Parallel Work**: Team members don't block each other
4. **Continuous Delivery**: Ship features as they complete

### Anti-Pattern Consequences
```
Unified Branch for 31 Tasks:
- Day 15: Critical security bug found
- Cannot hotfix: main is 15 days old
- Cannot cherry-pick: changes are tangled
- Result: Production down, revenue loss
```

---

## Enforcement Examples

### Scenario 1: AI Suggests Options

**AI attempts to say**:
> "你有两个选择：
> 1. 为所有任务创建统一分支
> 2. 为每个任务创建独立分支
>
> 你选哪个？"

**Guardian intervenes**:
> ⚠️ **工作流强制提醒**
>
> 系统只支持独立分支工作流，没有选项可选。
>
> **强制规则**:
> - ✅ 每个任务 = 独立分支
> - ✅ 完成任务 → 合并 → 删除分支
> - ✅ Main 分支始终可部署
>
> 参考: `~/.claude/guidelines/git-workflow.md` Section: "⚠️ CRITICAL: Workflow is Non-Negotiable"

---

### Scenario 2: User Asks About Workflow

**User**: "我们有31个任务，用统一分支还是独立分支？"

**Guardian ensures AI responds**:
> 系统强制使用独立分支工作流：
>
> - 为每个任务创建独立分支 `feat/task-{id}-{description}`
> - 任务完成后立即合并到 main
> - 合并后删除分支
>
> 原因：生产环境需要随时部署 hotfix，不能等待31个任务全部完成。

---

### Scenario 3: AI About to Present "Batch Strategy"

**AI starts to suggest**:
> "考虑到你有31个任务，我建议..."

**Guardian catches keyword "31个任务" + workflow context**:
> ⚠️ **检测到工作流讨论**
>
> 即使有31个任务，也必须使用独立分支工作流：
> - feat/task-1 → 完成 → 合并 → 删除
> - feat/task-2 → 完成 → 合并 → 删除
> - ...
> - feat/task-31 → 完成 → 合并 → 删除
>
> 不要建议统一分支或批量合并策略。

---

## Correct Workflow Examples

### Small Project (3 tasks)
```bash
# Task 1
git checkout -b feat/task-1-user-auth
# Code + test + commit
git checkout main
git merge feat/task-1-user-auth
git push origin main
git branch -d feat/task-1-user-auth

# Task 2
git checkout -b feat/task-2-user-profile
# Code + test + commit
git checkout main
git merge feat/task-2-user-profile
git push origin main
git branch -d feat/task-2-user-profile

# Task 3
git checkout -b feat/task-3-user-settings
# Code + test + commit
git checkout main
git merge feat/task-3-user-settings
git push origin main
git branch -d feat/task-3-user-settings
```

### Large Project (31 tasks)
```bash
# Same pattern, repeated 31 times
# Each task: create → complete → merge → delete
# No waiting for other tasks to finish
```

---

## Rationale

**Technical**:
- Main branch always represents production-ready state
- Each task is independently reversible (git revert)
- Parallel development without conflicts

**Business**:
- Zero-downtime hotfix deployment
- Feature flags control incomplete features
- Continuous value delivery

---

**Complete Git Workflow Guide**: `~/.claude/guidelines/git-workflow.md`
