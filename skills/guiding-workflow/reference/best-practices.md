## Best Practices

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Practice 1: Always Read Latest Research Report

**Why**: Project type determines next-step rationale

**How**:
```typescript
const researchFiles = await glob(".ultra/docs/research/*.md");
const latestReport = researchFiles[researchFiles.length - 1];
const projectType = await detectProjectType(latestReport);
```

**Benefit**: Tailored suggestions (avoid suggesting skipped rounds)

---

### Practice 2: Provide Context-Aware Rationale

**Bad** ❌:
```
Suggested next step: /ultra-plan
```

**Good** ✅:
```
Suggested next step: /ultra-plan

**Rationale**:
Specifications are 100% complete (specs/product.md has no [NEEDS CLARIFICATION] markers). Ready to decompose requirements into executable atomic tasks.

**Expected output**:
- .ultra/tasks/tasks.json (12-20 tasks)
- Estimated total duration: 40-80 hours
```

**Why**: User understands **why** this is the next step

---

### Practice 3: Respect User's Scenario B Choices

**Scenario**: User chose "Incremental Feature" → Only Round 2-3 executed

**Wrong behavior** ❌:
```
Suggested next step: Complete Round 1 and Round 4
```

**Correct behavior** ✅:
```
Suggested next step: /ultra-plan

**Rationale**:
Incremental feature development has completed core rounds (Round 2-3). Solution and tech stack are clear. Can proceed directly to task planning.

**Skipped rounds**:
- Round 1 (Problem Discovery): Existing project already has context, no need to repeat
- Round 4 (Risk Mapping): Incremental development has controlled risks
```

**Why**: Don't force workflow, respect user's Scenario B selection

---

### Practice 4: Provide Alternative Paths When Appropriate

**Scenario**: After Tech Decision research

**Output**:
```
**Suggested next step (2 options)**:

**Option 1** (recommended): Proceed directly to task planning
/ultra-plan

**Option 2**: Validate technology choice before planning
- Create simple PoC (1-2 hours)
- Validate core tech stack
- Run /ultra-plan after confirmation
```

**Why**: User has choice based on confidence level

---

### Practice 5: Show Progress Metrics

**During development**:
```
**Task progress**:
- ✅ Completed: 5 tasks (42%)
- 🚧 In progress: 1 task
- ⏳ Pending: 6 tasks (50%)

**Actual vs estimated**:
- Completed 5 tasks: 17h (estimated 18h, 1h ahead)
- Remaining 7 tasks: Estimated 26h
- Estimated total completion date: 2025-11-20
```

**Why**: User can track progress and adjust timeline

---
