---
description: Agile development execution with TDD workflow
argument-hint: [task-id]
allowed-tools: Read, Write, Edit, Bash, TodoWrite, Grep, Glob, Task
---

# /ultra-dev

Execute development tasks using TDD workflow.

## Arguments

- `$1`: Task ID (if empty, auto-select next pending task)

---

## Workflow

### Step 1: Task Selection

1. Read `.ultra/tasks/tasks.json`
2. Select task:
   - If task ID provided → select that task
   - Otherwise → select first task with `status: "pending"`
3. Read context file: `.ultra/tasks/contexts/task-{id}.md`
4. Display task context
5. Update task status to `in_progress` in tasks.json
6. Create todos from Acceptance section

### Step 2: Environment Setup

**Create task workspace**:
```bash
mkdir -p .ultra/changes/task-{id}
```

**Check git branch**:
- If on `main` or `master` → Create feature branch:
  ```bash
  git checkout main && git pull origin main
  git checkout -b feat/task-{id}-{slug}
  ```
- If already on feature branch → Continue

**Check dependencies** (soft validation):
- If dependency tasks incomplete → Warn but continue
- Parallel development allowed

### Step 3: TDD Cycle

**RED → GREEN → REFACTOR**

**RED Phase**: Write failing tests
- Use Acceptance section from context file as test spec
- Cover test dimensions:
  - Functional: Core feature works
  - Boundary: Edge cases handled
  - Exception: Errors handled gracefully
  - Security: No vulnerabilities
- Tests MUST fail initially
- Run tests to confirm failure

**GREEN Phase**: Write minimum code to pass
- Only enough code to pass tests
- Production-ready (no TODO, no placeholder)
- Run tests to confirm pass

**REFACTOR Phase**: Improve quality
- Apply SOLID, DRY, KISS, YAGNI
- Tests must still pass

### Step 4: Quality Gates

**Before marking complete**:

| Gate | Requirement |
|------|-------------|
| Tests pass | All tests green |
| Coverage | ≥80% (project standard) |
| No mocks on core logic | Domain/service/state paths use real deps |
| No degradation | No fallback or demo code |

**Test double policy**:
- ❌ Core logic (domain/service/state) → NO mocking
- ✅ External systems → testcontainers/sandbox/stub allowed

### Step 5: Commit and Update

1. **Commit**:
   ```bash
   git add -A
   git commit -m "feat(scope): description"
   ```

2. **Sync with main**:
   ```bash
   git fetch origin
   git rebase origin/main
   # Resolve conflicts if any
   ```

3. **Run tests** after rebase

4. **Merge to main**:
   ```bash
   git checkout main
   git pull origin main
   git merge --no-ff feat/task-{id}-{slug}
   git push origin main
   git branch -d feat/task-{id}-{slug}
   ```

5. **Update status**:
   - tasks.json: Set status to `completed`
   - context file: Update header status to `completed`

6. **Trigger syncing skills**:
   - syncing-status: Record to feature-status.json
   - syncing-docs: Update CLAUDE.md "Current Focus"

### Step 6: Report

Output:
- Commit hash
- Project progress (completed/total)
- Next task suggestion

---

## Dual-Write Mode

**When requirements change during development**:

1. **Update specs immediately** (`.ultra/specs/product.md` or `architecture.md`)
   - Keep specifications current for parallel tasks

2. **Record change in proposal.md** (`.ultra/changes/task-{id}/proposal.md`):
   ```markdown
   ## Change History

   ### {date}: {change title}
   - **Original**: {original approach}
   - **Changed to**: {new approach}
   - **Reason**: {why the change}
   - **Updated**: specs/{file} §{section}
   ```

3. **Update context file** (`.ultra/tasks/contexts/task-{id}.md`)
   - Keep implementation guidance current

**On task completion**, add to proposal.md:
```markdown
## Status: Completed

- **Date**: {date}
- **Commit**: {hash}
- **Summary**: {brief description}
```

**Key principle**: `specs/` is source of truth, `changes/` is audit trail.

---

## Integration

- **Input**:
  - `.ultra/tasks/tasks.json` (task registry)
  - `.ultra/tasks/contexts/task-{id}.md` (implementation context)
- **Output**:
  - `.ultra/tasks/tasks.json` (status update)
  - `.ultra/tasks/contexts/task-{id}.md` (updated context)
  - `.ultra/changes/task-{id}/proposal.md` (change history)
  - `.ultra/docs/feature-status.json` (tracking)
  - `CLAUDE.md` (current focus)
- **Skills**: syncing-docs, syncing-status
- **Agents**: ultra-architect-agent (for complexity ≥7)
- **Next**: `/ultra-test` or `/ultra-dev [next-task-id]`

## Usage

```bash
/ultra-dev          # Auto-select next pending task
/ultra-dev 3        # Work on task #3
```
