## Blocking Scenarios

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Scenario 1: AI About to Suggest "Option 1 vs Option 2"

**Trigger**: AI detects user has 31 tasks and considers suggesting workflow options

**Guardian intervention** (BEFORE AI outputs options):

```typescript
// AI internal thought (blocked before output):
// "User has 31 tasks. I could suggest:
//  Option 1: Unified branch (all tasks in one branch)
//  Option 2: Independent branches (one branch per task)
//  Let me present both options..."

// Guardian detects keywords: "Option 1", "Option 2"
// → BLOCK OUTPUT
// → INJECT ENFORCEMENT MESSAGE
```

**Guardian output**:

```
🚫 Workflow Non-Negotiable Reminder

**Detected**: About to suggest alternative workflow (Option 1 vs Option 2)

**Ultra Builder Pro uses single mandatory workflow**:

**Independent Task Branch Pattern** (non-changeable):
```
main (always active, never frozen)
 ├── feat/task-1-xxx (create → complete → merge → delete)
 ├── feat/task-2-yyy (create → complete → merge → delete)
 └── feat/task-3-zzz (create → complete → merge → delete)
```

**Rules**:
- Each task = independent branch (`feat/task-{id}-{description}`)
- Task complete → merge immediately to main → delete branch
- main branch always deployable (for hotfixes)

**Forbidden**:
❌ Unified feature branch (multiple tasks in one branch)
❌ Delayed merge until "all tasks complete"
❌ Freeze main branch waiting for batch deployment
❌ Provide "workflow options"

**Rationale**:
Production environment requires main branch always deployable. Hotfixes cannot wait for 31 tasks to complete.
Independent branches support parallel work and independent rollback.

**Reference**: @guidelines/ultra-git-workflow.md - "CRITICAL: Workflow is Non-Negotiable"

**Correct approach (single workflow)**:
1. Task #1: Create `feat/task-1-auth` → complete → merge → delete
2. Task #2: Create `feat/task-2-dashboard` → complete → merge → delete
3. Task #3: Create `feat/task-3-payment` → complete → merge → delete
... (process all 31 tasks sequentially)
```

---

### Scenario 2: AI Suggests Unified Branch for Multiple Tasks

**Trigger**: User asks "How should I handle 31 tasks?"

**AI attempt** (blocked):
```
"Create a feature branch 'feat/user-management' containing all 31 tasks..."
```

**Guardian intervention**:

```
🚫 Workflow Violation Warning

**Detected unsafe suggestion**: Unified feature branch (31 tasks in one branch)

**Problem analysis**:

**Scenario**: 31 tasks in `feat/user-management` branch

**Risks**:
1. ❌ **Hotfixes blocked**
   - Production critical bug occurs
   - main branch needs immediate fix
   - But feat/user-management incomplete (only 15/31 tasks done)
   - Must wait for remaining 16 tasks → 2-3 day delay
   - **Business loss: Unacceptable**

2. ❌ **Rollback difficulty**
   - Task #8 introduces critical bug
   - Need to rollback Task #8
   - But Task #8 in feat/user-management (contains 31 tasks)
   - Rollback options:
     * Rollback entire branch → lose 30 tasks' work (7 days)
     * Manual revert Task #8 → complex, error-prone
   - **Rollback cost: 7 days' work**

3. ❌ **Team collaboration blocked**
   - Developer A working on Task #5
   - Developer B waiting for Task #10
   - But both in same branch → conflicts, blocking
   - **Team efficiency: -60%**

**Mandatory workflow (only option)**:

```
main (always deployable)
 ├── feat/task-1-login      → merged ✅
 ├── feat/task-2-dashboard  → in progress 🚧
 └── feat/task-3-payment    → pending ⏸️
```

**Benefits**:
- ✅ Hotfixes: Can merge to main anytime
- ✅ Rollback: Delete single branch, 2 minutes
- ✅ Collaboration: Parallel work, zero conflicts
```

---

### Scenario 3: User Asks "Can I Use Unified Branch for Related Tasks?"

**Trigger**: User: "Tasks 1-5 are all related to authentication, can I put them in one branch?"

**AI might say** (blocked):
```
"Yes, since they're related, you can use feat/auth-system for Tasks 1-5..."
```

**Guardian enforcement**:

```
🚫 Workflow Non-Negotiable

**Question detected**: Unified branch for related tasks

**Answer**: No. Ultra Builder Pro uses independent branch pattern regardless of task relationship.

**Why "related tasks" doesn't justify unified branch**:

1. **Hotfix still critical**:
   - Task 3 (password reset) introduces bug
   - Production login broken
   - Need immediate rollback
   - With unified branch → must rollback all 5 tasks
   - **Downtime: 2 hours vs 2 minutes**

2. **Task dependency ≠ Branch dependency**:
   - Task 2 depends on Task 1 (code-level)
   - But branch dependency is workflow-level
   - Solution: Merge Task 1 first, then start Task 2
   - **Independent branches preserve independence**

3. **Partial deployment impossible**:
   - Tasks 1-3 ready, 4-5 still testing
   - With unified branch → cannot deploy 1-3
   - With independent branches → deploy 1-3, continue 4-5
   - **Deployment flexibility: 100% vs 0%**

**Correct approach**:
```
main
 ├── feat/task-1-login-form       → merged ✅
 ├── feat/task-2-password-hash    → merged ✅
 ├── feat/task-3-password-reset   → in progress 🚧
 ├── feat/task-4-2fa             → pending ⏸️
 └── feat/task-5-session-mgmt    → pending ⏸️
```

Each task independent, even if functionally related.
```

---

### Scenario 4: AI Suggests Batching Tasks Before Merge

**Trigger**: User: "I've completed 5 tasks, should I merge them together?"

**AI might say** (blocked):
```
"Yes, you can merge all 5 tasks at once for efficiency..."
```

**Guardian intervention**:

```
🚫 Batch Merge Violation

**Detected pattern**: Batch merge suggestion (5 tasks together)

**Problem**: Violates independent branch workflow

**Mandatory rule**: Each task merges immediately after completion

**Why immediate merge is required**:

1. **Continuous integration**:
   - Task 1 complete → merge → CI runs → tests pass
   - Task 2 complete → merge → CI runs → tests pass
   - Early detection of integration issues
   - **Bug discovery: Real-time vs delayed**

2. **Risk isolation**:
   - Task 3 breaks tests
   - With immediate merge → easy to identify (only Task 3 changed)
   - With batch merge → hard to identify (5 tasks changed simultaneously)
   - **Debug time: 10 min vs 2 hours**

3. **main branch currency**:
   - Waiting 5 tasks → main branch outdated
   - Merge conflicts accumulate
   - **Conflict resolution: Simple vs complex**

**Correct workflow**:
```
Timeline:
Day 1, 10:00 - Task 1 complete → merge immediately ✅
Day 1, 14:00 - Task 2 complete → merge immediately ✅
Day 2, 11:00 - Task 3 complete → merge immediately ✅
Day 2, 16:00 - Task 4 complete → merge immediately ✅
Day 3, 10:00 - Task 5 complete → merge immediately ✅
```

Never wait. Never batch. Merge immediately.
```

---

### Scenario 5: User Mentions "Feature Branch"

**Trigger**: User: "I'll create a feature branch for the payment system"

**AI interpretation** (requires validation):
```
// Does user mean:
// A) One branch for one task (correct)
// B) One branch for multiple payment tasks (incorrect)
```

**Guardian clarification**:

```
⚠️ Terminology Clarification Needed

**Term detected**: "feature branch"

**In Ultra Builder Pro context**:
- ✅ "Feature branch" = One branch for ONE task
- ❌ "Feature branch" ≠ One branch for multiple tasks

**Example clarification**:

User: "I'll create a feature branch for the payment system"

**If user means** (31 payment-related tasks):
❌ WRONG: `feat/payment-system` containing 31 tasks
✅ CORRECT: 31 independent branches:
  - `feat/task-1-stripe-integration`
  - `feat/task-2-payment-form`
  - `feat/task-3-refund-logic`
  - ... (28 more)

**Recommended response**:
"I see you're working on payment system. How many tasks does this include?
If multiple tasks, please create one branch per task following the independent branch pattern."

**Never assume**: Always clarify to prevent unified branch pattern.
```

---

### Scenario 6: Complex Project with 100+ Tasks

**Trigger**: User: "I have 100 tasks, independent branches seems impractical"

**AI might think** (blocked):
```
"User has a point, maybe for 100 tasks we can allow unified branches..."
```

**Guardian enforcement**:

```
🚫 Scale Does Not Change Workflow

**Detected**: Suggestion to modify workflow based on task count

**Answer**: Independent branch pattern scales to ANY task count

**Why 100+ tasks still uses independent branches**:

1. **Real-world example**:
   - Linux kernel: 100,000+ commits/year
   - Each feature: Independent branch
   - Scale: Proves the pattern works
   - **Evidence: 30 years of success**

2. **Automation handles scale**:
   - Branch creation: `git checkout -b feat/task-{id}` (5 seconds)
   - Merge: CI/CD automated (30 seconds)
   - Per task overhead: 35 seconds
   - 100 tasks overhead: 58 minutes total
   - **Acceptable cost for risk elimination**

3. **Benefits scale linearly**:
   - 10 tasks: 10× rollback ease
   - 100 tasks: 100× rollback ease
   - More tasks = MORE need for independent branches
   - **Scale increases value, not reduces it**

**Correct approach for 100 tasks**:
```
# Use task management tool
# Auto-generate branch names
# Automate merge workflow
# Let CI/CD handle integration

Example automation:
$ ultra-dev 47  # Auto creates feat/task-47-xxx
$ git push      # Auto triggers CI/CD
# On success: Auto merges to main
# On failure: Auto notifies, blocks merge
```

**Tooling solves scale**, not workflow compromise.
```

---

### Scenario 7: User Requests "Development Branch"

**Trigger**: User: "Can we use a development branch for staging before merging to main?"

**AI might say** (blocked):
```
"Yes, you can create a dev branch as intermediary..."
```

**Guardian analysis**:

```
⚠️ Development Branch Pattern Review

**Request**: Intermediary development branch

**Analysis**:

**Compatible pattern** (allowed):
```
main (production)
 ↑
dev (staging)
 ↑
feat/task-{id} (independent task branches)
```

**Key requirement**: Task branches must still be independent

**Correct workflow**:
1. Task 1: `feat/task-1` → merge to `dev` → test → merge to `main`
2. Task 2: `feat/task-2` → merge to `dev` → test → merge to `main`
3. Each task merges independently

**Forbidden pattern**:
```
❌ WRONG:
feat/mega-feature (10 tasks) → dev → main
```

**Allowed pattern**:
```
✅ CORRECT:
feat/task-1 → dev → main
feat/task-2 → dev → main
feat/task-3 → dev → main
```

**Note**: dev branch adds complexity. Only use if truly needed for staging environment.
Simple projects: Direct to main is preferred.
```

---

## Summary: Common Blocking Patterns

**Guardian blocks when detecting**:

1. Keywords: "Option 1", "Option 2", "workflow choices"
2. Patterns: "unified branch", "batch merge", "delay merge"
3. Justifications: "related tasks", "too many tasks", "efficiency"
4. Proposals: Alternative workflows, workflow modifications

**Guardian enforces**:

- Independent branch pattern (only workflow)
- Immediate merge (no batching)
- One task per branch (no exceptions)
- main always deployable (no freezing)

**Zero tolerance for**:

- Workflow alternatives
- Workflow "options"
- Scale-based exceptions
- Efficiency-based compromises

**Remember**: Workflow is constitutional, not configurable.
