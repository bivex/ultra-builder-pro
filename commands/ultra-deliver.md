---
description: Delivery optimization (performance + security + documentation)
argument-hint: [version-type]
allowed-tools: TodoWrite, Task, Read, Write, Edit, Bash, Grep, Glob
---

# /ultra-deliver

Prepare for delivery with performance optimization, security audit, and documentation updates.

---

## Pre-Delivery Validations

**Before proceeding, you MUST verify these conditions. If any fails, report and block.**

### Validation 1: /ultra-test Passed

Verify `/ultra-test` was run and all gates passed:
- No CRITICAL anti-patterns detected
- No HIGH priority coverage gaps
- E2E tests pass (if applicable)
- Core Web Vitals pass (if frontend)
- No critical/high security vulnerabilities

If not run or failed:
- Report: "❌ Run /ultra-test first"
- Block delivery

### Validation 2: No Uncommitted Changes

Run `git status` and verify working directory is clean.

If unclean:
- Report: "⚠️ Uncommitted changes exist"
- Ask user to commit or stash

### Validation 3: Specs Up-to-Date

Verify specs/ reflects current state (Dual-Write Mode ensures this during development).

Check `.ultra/tasks/contexts/task-*.md` Change Log sections for any untracked spec updates.

If inconsistency found:
- Report: "⚠️ Context files reference spec changes not reflected in specs/"
- List affected sections
- Ask user to verify

---

## Delivery Workflow

### Step 1: Performance Optimization

Delegate to ultra-performance-agent:

```
Task(subagent_type="ultra-performance-agent",
     prompt="Analyze and optimize performance. Focus on Core Web Vitals (LCP<2.5s, INP<200ms, CLS<0.1) and bottleneck identification.")
```

### Step 2: Verify Security (from /ultra-test)

Security audit was performed in `/ultra-test`. Review results and ensure no blockers remain.

If new dependencies added after `/ultra-test`:
- Re-run security check (auto-detect package manager)
- Block if critical/high issues found

### Step 3: Documentation Update

**Step 3.1: Draft Documentation**

**CHANGELOG.md**:
1. Run `git log --oneline` since last release tag
2. Categorize by Conventional Commit prefix (feat→Added, fix→Fixed, etc.)
3. Update CHANGELOG.md with new version section

**Technical Debt**:
1. Use Grep to find TODO/FIXME/HACK markers in code
2. Generate `.ultra/docs/technical-debt.md` with categorized items

**API Documentation / README updates**:
1. Draft based on code changes
2. Include basic usage examples

**Step 3.2: Review Documentation**

Check for:
1. Technical accuracy (code examples work)
2. Completeness (all APIs documented)
3. Clarity (no ambiguity)
4. Practical examples

**Step 3.3: Enhance Documentation**

Add:
1. More code examples (covering edge cases)
2. FAQ section (common questions)
3. Best practices
4. Troubleshooting guide
5. Migration notes (if applicable)

**Step 3.4: Final Review**

- Ensure consistent style and tone
- Verify accuracy
- Final approval before commit

### Step 4: Production Build

**Auto-detect build command**:
- Node.js: Read `scripts.build` from `package.json`
- Python: `python -m build` or project-specific
- Go: `go build ./...`
- Rust: `cargo build --release`

Verify build succeeds before proceeding.

### Step 5: Prepare Release

1. Determine version bump (patch/minor/major) based on commits
2. Update version (auto-detect):
   - Node.js: `npm version {type}`
   - Python: Update `pyproject.toml` or `setup.py`
   - Go: Create git tag
3. Report release readiness

---

## Deliverables Checklist

- [ ] `/ultra-test` passed (Anti-Pattern, Coverage, E2E, Perf, Security)
- [ ] No uncommitted changes
- [ ] Specs up-to-date (Dual-Write verified)
- [ ] Documentation updated (CHANGELOG, README)
- [ ] Production build successful
- [ ] Version bumped

---

## Integration

- **Prerequisites**: `/ultra-test` must pass first
- **Agents**: ultra-performance-agent for optimization
- **Next**: Deploy or create release PR

**Workflow**:
```
/ultra-dev (tasks) → /ultra-test (audit) → /ultra-deliver (release)
```

## Output Format

Display delivery report in Chinese including:
- Merge status
- Performance scores
- Security audit results
- Documentation updates
- Release readiness
