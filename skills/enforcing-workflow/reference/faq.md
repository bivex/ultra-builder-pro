## FAQ

### Q1: What if I really need a unified branch for tightly coupled tasks?

**A**: **No exceptions.** Even tightly coupled tasks use independent branches.

**Reasoning**:
- "Tightly coupled" often means poor separation of concerns (SOLID violation)
- If tasks are truly coupled, they should be **one task** (not multiple)
- If they are separate tasks, they can be developed independently with clear interfaces

**Example**:

**Scenario**: "Task #5 (frontend) and Task #6 (backend API) are tightly coupled"

**Wrong approach** ❌:
```
Create feat/user-profile (includes both Task #5 and #6)
```

**Correct approach** ✅:
```
1. Task #5: feat/task-5-profile-api (backend API)
   - Define clear API contract (OpenAPI spec)
   - Implement API
   - Merge to main

2. Task #6: feat/task-6-profile-ui (frontend)
   - Consume API defined in Task #5
   - Implement UI
   - Merge to main
```

**Key**: Define interface first (API contract), then develop independently

---

### Q2: What if the project is a personal side project with no team?

**A**: **Still use independent branches.** Workflow discipline benefits solo developers too.

**Benefits for solo developers**:
1. **Clear history**: Each task has its own branch and PR
2. **Easy rollback**: Revert one task without affecting others
3. **Incremental deployment**: Deploy features one by one
4. **Good habits**: Prepare for future collaboration

**Habit formation**: If you train yourself on "lax" workflow for side projects, you'll struggle in professional settings.

---

### Q3: Why can't AI just warn me instead of blocking?

**A**: **Warning is insufficient.** Users often ignore warnings.

**Research** (DevOps surveys):
- 70% of developers ignore Git workflow warnings
- 90% of production incidents trace back to ignored warnings

**Guardian philosophy**: **Prevent errors, don't just warn**

**Analogy**: Compiler errors vs warnings
- Error: "Cannot compile, must fix"
- Warning: "Might be a problem, but can ignore"
- Result: 95% of warnings ignored

**Git workflow errors are like compiler errors**: Must be fixed, not optional.

---

### Q4: What if I'm using GitHub Flow or GitFlow?

**A**: **Ultra Builder Pro enforces its own workflow** (independent-branch pattern).

**Comparison**:

| Workflow | Main Always Deployable | Feature Branches | Long-lived Branches | Ultra Builder Compatible |
|----------|----------------------|-----------------|---------------------|--------------------------|
| **Ultra Builder** | ✅ Yes | ✅ Per-task | ❌ No | ✅ **Standard** |
| GitHub Flow | ✅ Yes | ✅ Per-feature | ❌ No | ✅ Compatible |
| GitFlow | ❌ No (uses develop) | ✅ Per-feature | ✅ Yes (develop, release) | ❌ Not compatible |
| Trunk-Based | ✅ Yes | ✅ Short-lived | ❌ No | ✅ Compatible |

**If you're using GitFlow**: Ultra Builder will block it (develop branch = long-lived, violates workflow)

**Migration**: GitFlow → Ultra Builder independent-branch pattern

---

### Q5: Can I disable enforcing-workflow?

**A**: **Technically yes, but strongly discouraged.**

**How to disable**:
```bash
# Move skill to deprecated (NOT recommended)
mv ~/.claude/skills/enforcing-workflow \
   ~/.claude/skills/.deprecated/enforcing-workflow
```

**Consequences**:
- AI may suggest unsafe workflows
- Production risks (as detailed in blocking scenarios)
- You lose safety enforcement

**When to consider disabling**:
- Educational purposes (studying alternative workflows)
- Research projects (not production)
- **Never for production code**

**Recommendation**: Keep enabled for all production work

---

### Q6: What if I'm contributing to an open-source project with different workflow?

**A**: **Ultra Builder is for YOUR projects.** External projects follow their own rules.

**Scenario**:
- You contribute to Project X (uses GitFlow)
- You develop your own Project Y (uses Ultra Builder)

**Solution**: Use Ultra Builder for Project Y, follow Project X's workflow when contributing to X

**Guardian behavior**: Only enforces in Ultra Builder projects (detects `.ultra/` directory)

---

### Q7: Is there any scenario where unified branch is acceptable?

**A**: **Only one scenario: Single task treated as one unit.**

**Acceptable** ✅:
```
Task #5: "Implement user profile feature"
- Includes: API + UI + tests
- Treated as ONE atomic task
- ONE branch: feat/task-5-user-profile
```

**Not acceptable** ❌:
```
Tasks #5-10: "User management features"
- Task #5: User model
- Task #6: User CRUD
- Task #7: Auth
- ...
- ONE branch: feat/user-management (contains 6 tasks)
```

**Key distinction**: One task = one branch (acceptable). Multiple tasks = multiple branches (mandatory).

---

