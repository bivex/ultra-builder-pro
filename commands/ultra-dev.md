---
description: Agile development execution with native task management and simplified TDD workflow
argument-hint: [task-id]
allowed-tools: Read, Write, Edit, Bash, TodoWrite, Grep, Glob, Task
---

# /ultra-dev

Execute development tasks using TDD workflow with native task management.

## Arguments

- `$1`: Task ID (if empty, auto-select next pending task)

---

## Pre-Execution Validation (MANDATORY)

**Before writing ANY code, you MUST perform these three validations. If any validation fails, STOP and report the failure to the user with the solution. Do NOT proceed with development.**

### Validation 1: Specification Exists

**What to check**: Read `.ultra/tasks/tasks.json` and verify the target task has a `trace_to` field pointing to a valid specification file.

**Why this matters**: Development without specification leads to mock code, hardcoded values, and degraded implementations. The spec provides the contract that tests verify against.

**If validation fails**:
- Report: "❌ 任务 #{id} 没有关联规范 (trace_to 字段缺失)"
- Solution: "请先运行 /ultra-research 建立规范，或在 tasks.json 中添加 trace_to 字段"
- STOP here. Do not proceed.

**If validation passes**: Continue to Validation 2.

### Validation 2: Feature Branch Active

**What to check**: Run `git branch --show-current` and verify the result is NOT `main` or `master`.

**Why this matters**: Main branch must remain deployable at all times. Each task requires an independent branch so changes can be reverted individually without affecting other work.

**If validation fails**:
- Report: "❌ 当前在 main/master 分支，禁止直接开发"
- Solution: "请运行: git checkout -b feat/task-{id}-{slug}"
- STOP here. Do not proceed.

**If validation passes**: Continue to Validation 3.

### Validation 3: Dependencies Completed

**What to check**: Read `.ultra/tasks/tasks.json`, find the target task's `dependencies` array, and verify each dependency task has `status: "completed"`.

**Why this matters**: Building on incomplete dependencies forces mock implementations or static workarounds. Complete dependencies provide real APIs and data structures to code against.

**If validation fails**:
- Report: "❌ 依赖任务未完成: Task #{dep_id} (状态: {status})"
- Solution: "请先完成依赖任务，或使用 /ultra-plan 调整任务顺序"
- STOP here. Do not proceed.

**If all validations pass**: Proceed to Development Workflow.

---

## Development Workflow

### Step 1: Task Selection and Context

1. Read `.ultra/tasks/tasks.json`
2. If task ID provided, select that task; otherwise select first task with `status: "pending"`
3. Display task context to user: ID, title, complexity, dependencies, description
4. Update task status to `"in_progress"` in tasks.json
5. Use TodoWrite to track progress

**For complex tasks** (complexity >= 7 AND type == "architecture"):
Delegate to ultra-architect-agent using the Task tool:
```
Task(subagent_type="ultra-architect-agent",
     prompt="Design implementation approach for task #{id}: {title}.
             Provide SOLID compliance analysis and trade-off recommendations.")
```

### Step 2: Create Feature Branch

Run: `git checkout -b feat/task-{id}-{slug}`

Where `{slug}` is a 2-3 word lowercase hyphenated description of the task.

### Step 3: Create Changes Directory

Create the OpenSpec workspace:
```
.ultra/changes/task-{id}/
├── proposal.md     # Feature overview and rationale
├── tasks.md        # Copy task details from tasks.json
└── specs/          # Only if modifying specifications
```

### Step 4: TDD Development Cycle

**You MUST follow RED → GREEN → REFACTOR strictly. Do NOT write implementation before tests.**

**RED Phase**: Write failing tests first
- Cover 6 dimensions: Functional, Boundary, Exception, Performance, Security, Compatibility
- Tests MUST fail initially (verifies tests are meaningful)
- Run tests to confirm failure

**GREEN Phase**: Write minimum code to pass tests
- Only enough code to make tests pass
- No premature optimization or extra features
- Run tests to confirm all pass

**REFACTOR Phase**: Improve code quality
- Apply SOLID principles
- Remove duplication (DRY)
- Simplify complexity (KISS)
- Remove unused code (YAGNI)
- Tests must still pass after refactoring

### Step 5: Quality Gates

**Before marking task complete, verify ALL gates pass:**

| Gate | Requirement | How to Verify |
|------|-------------|---------------|
| G1 | Tests pass | `npm test` exits with 0 |
| G2 | Coverage ≥80% | `npm test -- --coverage` |
| G3 | TDD verified | RED→GREEN→REFACTOR completed |
| G4 | No tautologies | No `expect(true).toBe(true)` patterns |
| G5 | No skipped tests | Max 1 `.skip()` allowed |
| G6 | 6D coverage | All dimensions have tests |

**TAS Score Requirement**: guarding-test-quality skill calculates Test Authenticity Score.
- TAS ≥70% required (Grade A/B)
- TAS <70% blocks completion (Grade C/D/F)

### Step 6: Commit and Merge

1. Commit with conventional format: `feat(scope): description`
2. Switch to main: `git checkout main`
3. Pull latest: `git pull origin main`
4. Merge with history: `git merge --no-ff feat/task-{id}-{slug}`
5. Push: `git push origin main`
6. Delete branch: `git branch -d feat/task-{id}-{slug}`
7. Update task status to `"completed"` in tasks.json
8. Archive changes: `mv .ultra/changes/task-{id} .ultra/changes/archive/`

### Step 7: Report Completion

Display completion message in Chinese including:
- Commit hash
- Branch merge status
- Project progress (completed/total tasks)
- Next steps suggestion

---

## Integration

- **Skills activated**: guarding-quality, guarding-git-workflow, guarding-test-quality
- **Agents available**: ultra-architect-agent (for complexity >= 7)
- **Next command**: `/ultra-test` or `/ultra-dev [next-task-id]`

## Usage

```bash
/ultra-dev              # Auto-select next pending task
/ultra-dev 5            # Work on task #5
```
