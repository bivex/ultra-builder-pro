## Output Examples

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Example 1: After /ultra-init (No Research Yet)

**Project state**:
- `.ultra/` exists
- No `specs/` files
- No research reports

**Output**:
```
📋 Current Project Status

**Phase**: Project initialized, awaiting requirements research

**Completed**:
✅ Project structure initialized (.ultra/ directory)

**Pending**:
⏳ Requirements and technical research (specs/ files missing)

**Suggested next step**: /ultra-research

**Rationale**:
Specification files (specs/product.md, specs/architecture.md) do not exist. Complete specifications need to be generated through the research process.

**Estimated duration**: 50-70 minutes (4-round interactive discovery)

**ROI**: 70-minute investment saves 10+ hours of rework (8.3x return)
```

---

### Example 2: After /ultra-research (New Project, 4 Rounds Complete)

**Project state**:
- Research report exists with "New Project" indicator
- `specs/product.md` 100% complete
- `specs/architecture.md` 100% complete
- No `tasks.json`

**Output**:
```
📋 Current Project Status

**Phase**: Requirements research complete (New Project workflow)

**Completed**:
✅ 4 complete research rounds (70 minutes)
  - Round 1: Problem Discovery (20 minutes)
  - Round 2: Solution Exploration (20 minutes)
  - Round 3: Technology Selection (15 minutes)
  - Round 4: Risk & Constraints (15 minutes)
✅ specs/product.md 100% complete (no [NEEDS CLARIFICATION] markers)
✅ specs/architecture.md 100% complete (tech stack determined)

**Pending**:
⏳ Task breakdown and dependency analysis

**Suggested next step**: /ultra-plan

**Rationale**:
Specifications are 100% complete. Ready to decompose requirements into executable atomic tasks.

**Expected output**:
- .ultra/tasks/tasks.json (task list + dependencies)
- Task count: Estimated 12-20 tasks (based on project scale)
- Estimated total duration: 40-80 hours development

**Next phase preparation**:
Ensure you understand specs/ file contents. /ultra-plan will generate detailed task breakdown based on specifications.
```

---

### Example 3: After /ultra-research (Tech Decision, Round 3 Only)

**Project state**:
- Research report with "Tech Decision" indicator
- Only Round 3 executed (15 min)
- `specs/architecture.md` updated with tech choice

**Output**:
```
📋 Current Project Status

**Phase**: Technology selection complete (Tech Decision workflow)

**Completed**:
✅ Round 3: Technology Selection (15 minutes)
  - 6-dimensional comparison matrix
  - Tech stack determined: Next.js 14 + TypeScript + Tailwind
  - Decision rationale recorded to specs/architecture.md
✅ specs/architecture.md updated

**Pending**:
⏳ Validate tech choice (optional)
⏳ Task planning

**Suggested next step (2 options)**:

**Option 1** (recommended): Proceed directly to task planning
```bash
/ultra-plan
```
**Use case**: Technology choice is confident, can directly decompose tasks

**Option 2**: Validate technology choice before planning
- Create simple PoC (Proof of Concept)
- Validate core tech stack feasibility
- Run /ultra-plan after confirmation

**Use case**: First time using this tech stack, need validation

**Recommendation**:
If familiar with the tech stack (Next.js + TypeScript), directly choose Option 1.
If new tech stack, recommend Option 2 (1-2 hour PoC validation).
```

---

### Example 4: After /ultra-plan (Tasks Generated)

**Project state**:
- `tasks.json` exists with 12 tasks
- All tasks status: "pending"
- No code changes yet

**Output**:
```
📋 Current Project Status

**Phase**: Task planning complete, ready for development

**Completed**:
✅ Task breakdown complete (12 atomic tasks)
✅ Dependency analysis complete
✅ Complexity assessment complete (3 Complex, 5 Medium, 4 Simple)
✅ Estimated total duration: 48 hours

**Task overview**:
- Pending: 12 tasks (100%)
- In progress: 0 tasks
- Completed: 0 tasks

**Next task**:
Task #1: Implement user authentication (JWT)
- Complexity: Medium
- Estimated duration: 4 hours
- Dependencies: None (can start immediately)

**Suggested next step**: /ultra-dev

**TDD workflow reminder**:
/ultra-dev will automatically execute the following workflow:
1. 🔴 RED: Write failing tests (6-dimensional coverage)
2. 🟢 GREEN: Implement minimal code to pass tests
3. 🔵 REFACTOR: Optimize code quality (SOLID/DRY/KISS/YAGNI)
4. ✅ Quality gate check: All tests passing + code review
5. 🔀 Merge to main and delete branch

**Execute command**:
```bash
/ultra-dev   # Automatically selects Task #1
# or
/ultra-dev 3  # Specify Task #3 (if no dependencies, can develop in parallel)
```
```

---

### Example 5: During Development (5/12 Tasks Complete)

**Project state**:
- `tasks.json` shows 5 completed, 1 in-progress, 6 pending
- Git shows modified files

**Output**:
```
📋 Current Project Status

**Phase**: Development in progress

**Task progress**:
- ✅ Completed: 5 tasks (42%)
- 🚧 In progress: 1 task (Task #6: Create user Dashboard)
- ⏳ Pending: 6 tasks (50%)

**Completed tasks review**:
1. ✅ Task #1: User authentication (JWT) - 4h (estimated 4h)
2. ✅ Task #2: User registration API - 3h (estimated 3h)
3. ✅ Task #3: Password reset functionality - 2.5h (estimated 3h, completed early)
4. ✅ Task #4: Email service integration - 4h (estimated 4h)
5. ✅ Task #5: User profile CRUD - 3.5h (estimated 4h, completed early)

**Current task**:
🚧 Task #6: Create user Dashboard
- Complexity: Medium
- Estimated duration: 5 hours
- Progress: Estimated 60% complete (based on git diff)

**Suggested next step (2 options)**:

**Option 1**: Continue current task
```bash
/ultra-dev 6  # Continue Task #6
```

**Option 2**: Complete current task then proceed to next
- Finish Task #6 TDD workflow
- Pass quality gate checks
- Auto-suggest Task #7

**Estimated completion time**:
- Current task remaining: ~2 hours
- Remaining 6 tasks: ~22 hours
- Total remaining time: ~24 hours
- Estimated completion date: 2025-11-20 (based on 8 hours/day)

**Quality metrics**:
- Test coverage: 87% (target ≥80%) ✅
- Code quality: A grade (SOLID/DRY compliant) ✅
- Commit convention: 100% Conventional Commits ✅
```

---

### Example 6: All Tasks Complete, Ready to Test

**Project state**:
- All 12 tasks completed
- Tests exist but may need re-running
- Code committed to main

**Output**:
```
📋 Current Project Status

**Phase**: Development complete, ready for testing

**Task completion status**:
✅ 12/12 tasks all complete (100%)

**Actual vs estimated time**:
- Estimated total duration: 48 hours
- Actual total duration: 44 hours
- Efficiency: 109% (completed 4 hours early) 🎉

**Code quality**:
- Commits: 37 commits (average 3 per task)
- Branches: 12 merged and deleted
- Lines of code: +3,200 lines (code), +1,800 lines (tests)
- Test/code ratio: 56% (healthy)

**Suggested next step**: /ultra-test

**Test scope (6 dimensions)**:
1. ✅ Functional: Core business logic
2. ✅ Boundary: Edge cases (null, max values)
3. ✅ Exception: Error handling (network failure, timeout)
4. ✅ Performance: Performance tests (load, response time)
5. ✅ Security: Security tests (SQL injection, XSS)
6. ✅ Compatibility: Compatibility (browsers, platforms)

**Frontend project additional checks**:
- Core Web Vitals:
  * LCP < 2.5s (Largest Contentful Paint)
  * INP < 200ms (Interaction to Next Paint)
  * CLS < 0.1 (Cumulative Layout Shift)

**Execute command**:
```bash
/ultra-test
```

**Estimated duration**: 15-30 minutes (including Core Web Vitals measurement)
```

---

### Example 7: After Testing, Ready to Deliver

**Project state**:
- All tests passing
- Coverage ≥80%
- Core Web Vitals met

**Output**:
```
📋 Current Project Status

**Phase**: Testing complete, ready for delivery

**Test results**:
✅ All 6 dimensions tests passing
- Functional: 124 tests passed
- Boundary: 45 tests passed
- Exception: 38 tests passed
- Performance: 12 tests passed
- Security: 18 tests passed
- Compatibility: 15 tests passed

**Coverage**:
- Overall coverage: 87% (target ≥80%) ✅
- Critical paths: 100% (authentication, payment) ✅
- Branch coverage: 82% (target ≥75%) ✅

**Core Web Vitals** (frontend project):
- LCP: 2.1s < 2.5s ✅
- INP: 180ms < 200ms ✅
- CLS: 0.08 < 0.1 ✅

**Suggested next step**: /ultra-deliver

**Delivery optimization includes**:
1. 🚀 Performance optimization
   - Bundle size analysis
   - Code splitting
   - Image optimization

2. 🔒 Security audit
   - Dependency vulnerability scan (npm audit)
   - Code review (SQL injection, XSS)
   - Infrastructure checks (HTTPS, CORS, rate limiting)

3. 📚 Documentation update
   - README.md
   - CHANGELOG.md
   - API documentation
   - Architecture Decision Records (ADRs)

4. 📦 Deployment preparation
   - Environment variable checklist
   - Database migration preparation
   - Rollback plan

**Execute command**:
```bash
/ultra-deliver
```

**Estimated duration**: 1-2 hours
```

---
