## Enforcement Examples

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Example 1: Blocking Unified Branch Suggestion

**User message**:
```
"I have 31 tasks for user management system. How should I organize the branches?"
```

**AI's first thought** (internal, blocked before output):
```
"Let me suggest two options:
Option 1: Create one unified branch feat/user-management for all 31 tasks
Option 2: Create independent branches for each task

Option 1 pros: Fewer branches to manage...
Option 2 pros: Independent deployment...

I'll present both options to the user."
```

**enforcing-workflow detects**: Keywords "Option 1", "Option 2"

**enforcing-workflow action**: BLOCK output, inject enforcement message

**Actual output to user**:
```
🚫 Workflow Non-Negotiable Reminder

**Detected**: About to suggest alternative workflows

**Ultra Builder Pro uses single mandatory workflow**: Independent Task Branch Pattern

**For your 31 tasks, the ONLY workflow is**:

```
main (always deployable)
 ├── feat/task-1-user-model
 ├── feat/task-2-user-controller
 ├── feat/task-3-user-service
 ... (28 more independent branches)
```

**Each task follows**:
1. Create independent branch
2. Complete task (with tests)
3. Merge immediately to main
4. Delete branch

**No alternatives. No options. No exceptions.**

**Reference**: @guidelines/ultra-git-workflow.md
```

---

### Example 2: User Explicitly Requests Unified Branch

**User message**:
```
"Can I create one branch feat/payment for all payment-related tasks?"
```

**AI's first thought** (internal, checked):
```
"User explicitly wants unified branch. Should I:
A) Allow it since user specifically requested?
B) Enforce independent branch pattern?

Check enforcing-workflow..."
```

**enforcing-workflow detection**: Request for unified branch

**enforcing-workflow action**: Enforce independent pattern

**Actual output to user**:
```
🚫 Workflow Violation

**Request**: Unified branch for multiple tasks

**Answer**: No. Ultra Builder Pro uses independent branch pattern regardless of user preference.

**Why unified branch is not allowed**:

1. **Hotfix blocking risk**:
   - Payment task 5 introduces critical bug
   - Need immediate rollback
   - With unified branch → must rollback all payment tasks
   - **Production downtime: Hours vs minutes**

2. **Deployment flexibility lost**:
   - Tasks 1-3 ready for production
   - Tasks 4-7 still in testing
   - With unified branch → cannot deploy 1-3 separately
   - **Cannot ship completed work**

**Mandatory approach**:
```
main
 ├── feat/task-12-stripe-integration
 ├── feat/task-13-payment-form
 ├── feat/task-14-refund-logic
 ├── feat/task-15-payment-validation
```

Each task independent, each task deployable independently.

**This is constitutional, not configurable.**
```

---

### Example 3: User Suggests Batch Merge

**User message**:
```
"I've completed tasks 1, 2, and 3. Should I merge them all together?"
```

**AI's first thought** (internal, checked):
```
"User wants to batch merge 3 tasks. Let me check if this violates workflow..."
```

**enforcing-workflow detection**: Batch merge pattern

**enforcing-workflow action**: Enforce immediate merge

**Actual output to user**:
```
🚫 Batch Merge Violation

**Detected**: Attempt to batch merge multiple tasks

**Mandatory rule**: Each task merges immediately after completion

**Correct workflow**:
```
When you completed Task 1:
→ Merge Task 1 immediately (not wait for Task 2, 3)

When you completed Task 2:
→ Merge Task 2 immediately (not wait for Task 3)

When you completed Task 3:
→ Merge Task 3 immediately
```

**Why immediate merge is required**:
- Early integration testing
- Continuous deployment
- Risk isolation
- main branch currency

**What you should do now**:
```bash
# If tasks not yet merged:
git checkout main
git merge feat/task-1 && git push
git merge feat/task-2 && git push
git merge feat/task-3 && git push

# If tasks already in separate branches:
# Good! Merge each one separately.
```

**Never wait. Never batch. Merge immediately after each task completion.**
```

---

### Example 4: User Mentions Scale Concerns

**User message**:
```
"I have 100 tasks, creating 100 branches seems excessive"
```

**AI's first thought** (internal, checked):
```
"User concerned about scale. Should I suggest unified branches for scale? Check enforcing-workflow..."
```

**enforcing-workflow detection**: Scale-based workflow modification

**enforcing-workflow action**: Enforce independent pattern regardless of scale

**Actual output to user**:
```
🚫 Scale Does Not Change Workflow

**Concern**: 100 tasks → 100 branches seems excessive

**Answer**: Independent branch pattern scales to ANY task count

**Real-world proof**:
- Linux kernel: 100,000+ commits/year, each in independent branch
- Chromium: 50,000+ commits/year, independent branch pattern
- Android: 30,000+ commits/year, independent branch pattern

**Automation makes scale manageable**:

```bash
# Ultra Builder Pro automation:
$ ultra-dev 47  # Auto-creates feat/task-47-{description}
$ git push      # Auto-triggers CI/CD
# On CI success → Auto-merges to main
# On CI failure → Auto-blocks, notifies you

# Manual overhead per task: ~2 minutes
# 100 tasks: 200 minutes total (3.3 hours)
# Spread over weeks: Negligible
```

**Benefits increase with scale**:
- 10 tasks: 10× easier rollback
- 100 tasks: 100× easier rollback
- More tasks = MORE need for independent branches

**Scale is solved by tooling, not by compromising workflow.**
```

---

### Example 5: User Asks About Related Tasks

**User message**:
```
"Tasks 5-8 are all authentication features. Can they share a branch?"
```

**AI's first thought** (internal, checked):
```
"Tasks are functionally related. Does functional relationship justify unified branch? Check enforcing-workflow..."
```

**enforcing-workflow detection**: Justification for unified branch (task relationship)

**enforcing-workflow action**: Reject justification, enforce independence

**Actual output to user**:
```
🚫 Workflow Non-Negotiable

**Question**: Can related tasks share a branch?

**Answer**: No. Task relationship does not justify unified branch.

**Why functional relationship doesn't matter**:

1. **Deployment independence still needed**:
   - Task 5 (login) ready for production
   - Task 6 (2FA) needs more testing
   - With shared branch → cannot deploy Task 5 alone
   - **Block ready features = business loss**

2. **Rollback independence still critical**:
   - Task 7 (password reset) has bug
   - Need immediate rollback
   - With shared branch → must rollback Tasks 5, 6, 8 too
   - **Rollback blast radius: 1 task vs 4 tasks**

3. **Code dependency ≠ Branch dependency**:
   - Task 6 depends on Task 5's code
   - Solution: Merge Task 5 first, then start Task 6
   - Branch dependency is workflow-level, not code-level
   - **Independent branches preserve code dependency**

**Correct workflow for related tasks**:
```
main
 ├── feat/task-5-login-form       → merge first ✅
 ├── feat/task-6-2fa-setup        → merge second ✅
 ├── feat/task-7-password-reset   → merge third ✅
 └── feat/task-8-session-mgmt     → merge fourth ✅

Each task independent, even if functionally related.
Sequential merging maintains code dependency.
```
```

---

### Example 6: User Suggests Development Branch as Staging

**User message**:
```
"Can we use a dev branch between feature branches and main?"
```

**AI's first thought** (internal, checked):
```
"Development branch pattern. Is this compatible with independent branch workflow? Check enforcing-workflow..."
```

**enforcing-workflow detection**: Workflow modification proposal (dev branch)

**enforcing-workflow analysis**: Compatible if tasks remain independent

**Actual output to user**:
```
✅ Development Branch: Compatible Pattern

**Proposal**: Use dev branch as staging layer

**Analysis**: Compatible with independent branch workflow IF implemented correctly

**Correct pattern**:
```
main (production)
 ↑ merge after testing
dev (staging)
 ↑ merge immediately after task complete
feat/task-{id} (independent branches)
```

**Key requirement**: Tasks must still be independent

**Workflow**:
1. Task 1: Create `feat/task-1` → complete → merge to `dev` immediately
2. Test in dev → if pass → merge to `main`
3. Task 2: Create `feat/task-2` → complete → merge to `dev` immediately
4. Each task merges independently to dev

**Forbidden pattern**:
```
❌ WRONG:
feat/unified-branch (10 tasks) → dev → main

✅ CORRECT:
feat/task-1 → dev → main
feat/task-2 → dev → main
...
```

**Note**: dev branch adds complexity. Only use if staging environment truly needed.
Most projects: Direct to main is simpler and equally safe.

**Approval**: ✅ Allowed if tasks remain independent
```

---

### Example 7: AI Attempts to Present "Options"

**AI internal processing** (before output):
```typescript
// AI generates response:
const response = `
For your 31 tasks, you have two workflow options:

**Option 1: Unified Branch**
- Create one branch feat/user-system
- All 31 tasks in this branch
- Merge to main when all complete
- Pros: Simpler branch management
- Cons: Cannot deploy partial work

**Option 2: Independent Branches**
- Create 31 separate branches
- Each task in own branch
- Merge each task immediately
- Pros: Independent deployment
- Cons: More branches to manage

Which option would you prefer?
`

// enforcing-workflow intercepts BEFORE output
// Detects: "Option 1", "Option 2", "which option"
// → BLOCK OUTPUT
// → INJECT ENFORCEMENT
```

**What user actually sees**:
```
🚫 Workflow Options Blocked

**Detected**: About to present workflow alternatives

**Ultra Builder Pro has ZERO workflow options**:

There is exactly ONE workflow:
- Independent Task Branch Pattern
- Non-negotiable
- No alternatives
- No exceptions

**For your 31 tasks**:
```
main
 ├── feat/task-1 → merge immediately after complete
 ├── feat/task-2 → merge immediately after complete
 ... (29 more, each independent)
```

**This is the ONLY way.**

**Rationale**: Production systems require main always deployable. Hotfixes cannot wait for 31 tasks to complete. Independent branches enable independent deployment and rollback.

**Reference**: @guidelines/ultra-git-workflow.md - "CRITICAL: Workflow is Non-Negotiable"
```

---

### Example 8: User Proposes Feature Flag Alternative

**User message**:
```
"Instead of independent branches, can we use feature flags in one branch?"
```

**AI's first thought** (internal, checked):
```
"Feature flags as workflow alternative. Is this allowed? Check enforcing-workflow..."
```

**enforcing-workflow detection**: Workflow alternative proposal

**enforcing-workflow action**: Reject alternative, but acknowledge feature flags for different purpose

**Actual output to user**:
```
⚠️ Feature Flags vs Branch Strategy

**Proposal**: Use feature flags instead of independent branches

**Analysis**: Feature flags serve different purpose

**Feature flags are NOT workflow alternative**:
```
Feature flags = Runtime control (enable/disable features in production)
Branch strategy = Development workflow (how code reaches production)

They solve different problems.
```

**Correct usage**:
```
✅ CORRECT: Independent branches + Feature flags
main
 ├── feat/task-1-new-ui (with feature flag in code)
 ├── feat/task-2-new-api (with feature flag in code)

Each task:
1. Create independent branch
2. Implement with feature flag
3. Merge to main (flag OFF by default)
4. Turn flag ON in production when ready

Benefits: Independent development + Independent activation
```

**Forbidden usage**:
```
❌ WRONG: One branch with multiple features + feature flags
feat/unified (tasks 1-31, all with feature flags)

Problem: Still blocks hotfixes, rollbacks difficult
Feature flags don't solve branch workflow problems
```

**Answer**: Use feature flags, but MUST still use independent branches.
Feature flags complement independent branches, not replace them.
```

---

## Summary of Enforcement Patterns

**enforcing-workflow blocks**:
1. Presenting workflow "options" or "choices"
2. Suggesting unified branches (any justification)
3. Suggesting batch merges
4. Scale-based workflow modifications
5. Relationship-based branch sharing

**enforcing-workflow allows**:
1. Independent branches (only workflow)
2. Dev branch as staging (if tasks stay independent)
3. Feature flags (complementary to branches)
4. Automation tools (to make workflow easier)

**Zero tolerance for**:
- Workflow alternatives
- Workflow "options"
- Justifications for unified branches
- Compromises based on scale/complexity

**Remember**: Enforcement is automatic. No configuration. No override.
