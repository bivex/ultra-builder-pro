## FAQ

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Q1: What if research report doesn't have project type metadata?

**A**: guiding-workflow will **infer** from keywords or rounds completed:

**Inference logic**:
1. Check for keywords ("New Project", "Tech Decision", etc.)
2. If no keywords, check rounds completed:
   - 4 rounds → Assume "New Project"
   - 1 round (Round 3) → Assume "Tech Decision"
   - 2-3 rounds → Assume "Incremental Feature"
3. If still unclear, default to generic suggestion (no Scenario B context)

---

### Q2: What if specs are incomplete but user wants to plan?

**A**: guiding-workflow will **block** and suggest research:

**Output**:
```
⚠️ Specifications Incomplete

**Detected [NEEDS CLARIFICATION] markers**:
- specs/product.md: 3 locations
- specs/architecture.md: 1 location

**Issue**:
/ultra-plan requires 100% complete specifications to generate accurate task breakdown.

**Suggestion**: Complete research first

**Execute command**:
/ultra-research

**Estimated duration**: 20-30 minutes (to fill gaps)
```

**Why**: Prevent garbage-in-garbage-out (incomplete specs → bad tasks)

---

### Q3: Can guiding-workflow suggest /ultra-dev for a specific task?

**A**: YES, if task has no dependencies:

**Output**:
```
**Next task**:
Task #1: Implement user authentication (JWT)
- Complexity: Medium
- Estimated duration: 4 hours
- Dependencies: None (can start immediately)

**Suggested next step**:
/ultra-dev   # Automatically selects Task #1

**Or specify task**:
/ultra-dev 3  # If Task #3 has no dependencies, can develop in parallel
```

**Why**: Flexibility for parallel development (if no dependencies)

---

### Q4: What if user skips guiding-workflow suggestion?

**A**: guiding-workflow does NOT force workflow, it **suggests**:

**User freedom**:
- User can run any command at any time
- guiding-workflow only suggests optimal next step
- User can ignore and choose their own path

**Example**:
- guiding-workflow suggests: `/ultra-plan`
- User runs: `/ultra-dev` (skipping planning)
- Result: /ultra-dev will fail (no tasks.json), suggest /ultra-plan

**Philosophy**: Guide, don't control

---

### Q5: How does guiding-workflow handle multi-phase projects?

**A**: guiding-workflow tracks **current phase**, not entire project:

**Example**:
- Phase 1: MVP (12 tasks) → Complete → Delivered
- Phase 2: Beta features (8 tasks) → Current phase
- Phase 3: Scale (15 tasks) → Not started

**guiding-workflow focus**: Phase 2 (current)

**Output**:
```
**Current phase**: Phase 2 - Beta Features

**Phase 2 progress**:
- ✅ Completed: 3/8 tasks (38%)
- 🚧 In progress: Task #4
- ⏳ Pending: 4 tasks

**Suggested next step**: /ultra-dev 4
```

**Why**: Focus on current work, not future phases

---

### Q6: What if project uses old format (.ultra/docs/prd.md)?

**A**: guiding-workflow supports **both** formats:

**Detection order**:
1. Check for `specs/product.md` (new format)
2. If not found, check for `.ultra/docs/prd.md` (old format)
3. Use whichever exists

**Output** (old format):
```
**Completed**:
✅ .ultra/docs/prd.md 100% complete
✅ .ultra/docs/tech.md 100% complete

**Suggestion**: Consider migrating to new format (specs/)
- specs/product.md (instead of prd.md)
- specs/architecture.md (instead of tech.md)

**Migration commands**:
mv .ultra/docs/prd.md specs/product.md
mv .ultra/docs/tech.md specs/architecture.md
```

**Why**: Backward compatibility with Ultra Builder Pro 4.0 projects

---

### Q7: Can guiding-workflow suggest /ultra-status?

**A**: YES, guiding-workflow can suggest /ultra-status for progress check:

**Trigger**: User asks "What's the status?" or "How far along are we?"

**Output**:
```
**View detailed progress**: /ultra-status

/ultra-status provides:
- Task completion percentage
- Current phase analysis
- Risk warnings
- Next step suggestions

**Quick overview** (current):
- 5/12 tasks complete (42%)
- Estimated remaining time: 24 hours
```

**Why**: Complement guiding-workflow with detailed status

---
