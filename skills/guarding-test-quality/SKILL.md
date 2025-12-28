---
name: guarding-test-quality
description: "TRIGGERS when: running /ultra-test, editing test files (*.test.ts/*.spec.ts/*.test.js/*.spec.js), marking tasks complete with tests, keywords 'test quality'/'TAS score'/'mock ratio'/'fake tests'/'assertion count'/'over-mocking'. Detects fake/useless tests through TAS (Test Authenticity Score) analysis. DO NOT trigger for: reading test files for understanding, documentation-only changes, non-test code."
allowed-tools: Read, Grep, Glob
---

# Test Quality Guardian

Detect and prevent fake tests that achieve coverage without testing real behavior.

## When Triggered

- `/ultra-test` execution
- Test file modifications (*.test.ts, *.spec.ts, *.test.js, *.spec.js)
- Task completion with tests
- Keywords: "test quality", "TAS score", "mock ratio", "fake tests"

## Core Validations

**When this skill activates, you MUST check for these issues. If any critical issue is found, report it to the user and block task completion.**

### Critical Issue 1: Tautology Tests

**What to search for**: Patterns like `expect(true).toBe(true)` or `expect(1).toBe(1)` that always pass regardless of code behavior.

**How to detect**: Use Grep to search test files for:
- `expect(true).toBe(true)` or `expect(false).toBe(false)`
- `expect(1).toBe(1)` or any literal compared to itself

**If found**:
- Report: "❌ 检测到恒真测试：{file}:{line}"
- Impact: TAS 自动判定 F 级
- Block task completion

### Critical Issue 2: Empty Test Bodies

**What to search for**: Test cases with no assertions inside.

**How to detect**: Use Grep to find `it('...', () => {})` or `test('...', () => {})` with empty bodies.

**If found**:
- Report: "❌ 检测到空测试体：{file}:{line}"
- Impact: TAS 自动判定 F 级
- Block task completion

### Critical Issue 3: Zero Assertions

**What to search for**: Test files that have `it()` or `test()` blocks but no `expect()` calls.

**How to detect**: Count `it(`/`test(` occurrences vs `expect(` occurrences. If tests > 0 but expects = 0, flag.

**If found**:
- Report: "❌ 测试文件无断言：{file}"
- Block task completion

### Critical Issue 4: Assertion Reduction Without Spec Change

**What to check**: When test files are modified, compare assertion count before and after. If assertions reduced by >30%, verify that specification was also modified.

**Why this matters**: Reducing tests without changing specs indicates test weakening to pass quality gates, not legitimate requirement changes.

**If found**:
- Report: "❌ 断言减少 {percentage}% 但规范未变更"
- Solution: "先更新 specs/ 或恢复被删除的断言"
- Block task completion

---

## TAS Calculation

### Component Weights

| Component | Weight | Good Score | Poor Score |
|-----------|--------|------------|------------|
| Mock Ratio | 25% | <30% internal mocks | >50% internal mocks |
| Assertion Quality | 35% | >80% behavioral | <50% behavioral |
| Real Execution | 25% | >60% real code | <30% real code |
| Pattern Compliance | 15% | No anti-patterns | Multiple anti-patterns |

### Mock Classification

**External (OK to mock)**: HTTP clients (axios, fetch), databases, third-party SDKs, file system

**Internal (Should NOT mock)**: Your own modules (`../services/`, `../utils/`), business logic, custom hooks

### Assertion Classification

**Behavioral (Good)**: `.toBe()`, `.toEqual()`, `.toContain()`, `.toThrow()`, Testing Library queries

**Mock-Only (Problematic)**: `.toHaveBeenCalled()` alone, `.toHaveBeenCalledTimes()` alone

### Grade Thresholds

| Grade | Score | Action |
|-------|-------|--------|
| A | 85-100% | Pass |
| B | 70-84% | Pass with notes |
| C | 50-69% | **BLOCKED** |
| D/F | <50% | **BLOCKED** |

---

## Output Format (Chinese)

```
📊 测试质量分析报告
========================

项目 TAS 分数：{score}% (等级：{grade})

📁 分析文件：{count} 个
├── A 级：{a_count} 个 ✅
├── B 级：{b_count} 个 ✅
├── C 级：{c_count} 个 ❌ (阻断)
└── D/F 级：{df_count} 个 ❌ (阻断)

发现的问题：
{issue_list}

========================
质量门禁结果：{PASS ✅ | BLOCKED ❌}
```

---

## Don't

- Do not trigger for non-test files
- Do not block for Grade B (only C/D/F)
- Do not count external module mocks as violations
- Do not flag integration tests with real database

---

## Reference

See `REFERENCE.md` for:
- Testing philosophy details
- 10 anti-pattern examples with fixes
- Mock boundary definitions
