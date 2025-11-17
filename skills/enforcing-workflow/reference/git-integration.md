## Git Integration

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Integration with Git Workflow Guardian

**enforcing-workflow** and **git-workflow-guardian** work together:

**Division of responsibility**:
```
enforcing-workflow → Prevents AI from suggesting wrong workflows
git-workflow-guardian → Prevents dangerous git operations
```

---

### Example: Preventing Force Push to Main with Unified Branch

**Scenario**: User created unified branch (violating enforcing-workflow), now trying to force push

**Step 1: enforcing-workflow should have blocked**:
```
User request: "How do I handle 31 tasks?"
enforcing-workflow: Should block unified branch suggestion
```

**Step 2: If user bypasses and creates unified branch**:
```bash
$ git checkout -b feat/user-system-all-31-tasks
$ git push origin feat/user-system-all-31-tasks
```

**Step 3: User tries to merge to main**:
```bash
$ git checkout main
$ git merge feat/user-system-all-31-tasks
# Conflicts occur
$ git push --force origin main  # ← Dangerous operation
```

**git-workflow-guardian intervention**:
```
🚫 Dangerous Git Operation Detected

**Operation blocked**: git push --force origin main

**Risk**: Force push to main branch

**Consequences**:
- Overwrites commit history
- Other developers lose work
- CI/CD may break
- Production deployment risk

**Alternative**:
```bash
# Resolve conflicts properly:
git merge --abort
git rebase origin/main
# Resolve conflicts manually
git push origin main  # No --force
```

**Note**: You're using unified branch (feat/user-system-all-31-tasks) which violates workflow.
Correct approach: Use independent task branches.

**Reference**: @guidelines/ultra-git-workflow.md
```

---

### Example: Batch Merge Attempt

**Scenario**: User completed 5 tasks, trying to merge all at once

**Step 1: enforcing-workflow guidance**:
```
User: "I completed tasks 1-5, should I merge them together?"

enforcing-workflow:
"No. Each task merges immediately after completion."
```

**Step 2: User follows correct workflow**:
```bash
# Task 1
$ git checkout main
$ git merge feat/task-1
$ git push origin main
$ git branch -d feat/task-1

# Task 2
$ git checkout main
$ git merge feat/task-2
$ git push origin main
$ git branch -d feat/task-2

# ... (repeat for tasks 3-5)
```

**git-workflow-guardian monitors**:
- ✅ Each merge to main is small (one task)
- ✅ No --force flags
- ✅ Branch cleanup after merge
- ✅ main branch stays clean

---

### Example: Development Branch Integration

**Scenario**: User wants to use dev branch as staging

**enforcing-workflow evaluation**:
```
✅ ALLOWED if tasks remain independent:

main ← dev ← feat/task-{id}

✅ Each task merges independently to dev
✅ Each task merges independently to main
```

**Git workflow**:
```bash
# Task 1
$ git checkout -b feat/task-1-login
$ git commit -am "Implement login"
$ git checkout dev
$ git merge feat/task-1-login  # Independent merge
$ git push origin dev

# After testing in dev:
$ git checkout main
$ git merge feat/task-1-login  # Independent merge
$ git push origin main
$ git branch -d feat/task-1-login

# Task 2 (independent of Task 1's branch)
$ git checkout -b feat/task-2-dashboard
...
```

**git-workflow-guardian monitors**:
- ✅ No unified branches
- ✅ Each merge is independent
- ✅ Branch cleanup after merge

---

### Workflow Violation Detection Flow

```
User action
  ↓
enforcing-workflow checks
  ↓
├─ Violates workflow pattern?
│   ↓ YES
│   Block suggestion, inject enforcement message
│   ↓
└─ NO: Allowed pattern
    ↓
    User executes git commands
    ↓
    git-workflow-guardian checks
    ↓
    ├─ Dangerous operation?
    │   ↓ YES
    │   Require user confirmation
    │   ↓
    └─ NO: Safe operation
        ↓
        Execute git command
```

---

### Common Scenarios

#### Scenario 1: User Creates Unified Branch

**enforcing-workflow**: Should block AI suggestion
**If bypassed**: git-workflow-guardian warns on dangerous operations
**Result**: Double protection

#### Scenario 2: User Delays Merge

**enforcing-workflow**: Enforces immediate merge
**git-workflow-guardian**: No specific block (but workflow inefficiency noted)
**Result**: Guidance toward best practice

#### Scenario 3: User Force Pushes to Main

**enforcing-workflow**: Not involved (git operation level)
**git-workflow-guardian**: Blocks dangerous operation
**Result**: Safety net for git commands

---

### Integration Summary

```
Layer 1: enforcing-workflow (Workflow Strategy)
  └─ Prevents wrong workflow patterns from being suggested
  └─ Enforces independent branch pattern
  └─ Blocks workflow "options"

Layer 2: git-workflow-guardian (Git Safety)
  └─ Prevents dangerous git commands
  └─ Requires confirmation for destructive operations
  └─ Monitors git operations

Result: Defense in depth
```

**Both skills work together** to ensure:
1. ✅ Correct workflow strategy (enforcing-workflow)
2. ✅ Safe git operations (git-workflow-guardian)
3. ✅ No workflow alternatives
4. ✅ No dangerous git commands

---

### Developer Experience

**Positive enforcement** (not just blocking):

```
User: "How do I handle 31 tasks?"

enforcing-workflow:
"Create 31 independent branches, one per task.
Here's the workflow:
1. Task 1: Create feat/task-1 → complete → merge
2. Task 2: Create feat/task-2 → complete → merge
...

Benefits:
- Independent deployment
- Easy rollback
- Parallel development
- main always deployable"

[User follows workflow]

git-workflow-guardian:
[Monitors in background, only intervenes if dangerous operation]

Result: Smooth developer experience with safety guardrails
```

**Remember**: Skills guide toward correct workflow, not just block wrong workflows.
