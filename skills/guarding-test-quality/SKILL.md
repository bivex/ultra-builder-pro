---
name: guarding-test-quality
description: "TRIGGERS when: running /ultra-test, editing test files (*.test.ts/*.spec.ts/*.test.js/*.spec.js), marking tasks complete with tests, keywords 'test quality'/'TAS score'/'mock ratio'/'fake tests'/'assertion count'/'over-mocking'. Detects fake/useless tests through TAS (Test Authenticity Score) analysis. DO NOT trigger for: reading test files for understanding, documentation-only changes, non-test code."
allowed-tools: Read, Grep, Glob
---

# Test Quality Guardian

## Purpose

Detect and prevent fake tests that achieve coverage without testing real behavior. Calculates Test Authenticity Score (TAS) to measure test meaningfulness. **Enforces hard blocks on critical violations**.

## When

**Auto-triggers when**:
- `/ultra-test` execution starts
- Test files modified (`*.test.ts`, `*.spec.ts`, `*.test.js`, `*.spec.js`)
- Task marked complete with tests
- Keywords: "test quality", "TAS score", "mock ratio", "fake tests"

**Do NOT trigger for**:
- Reading test files for understanding
- Documentation-only changes
- Non-test code changes

---

## HARD BLOCKS (Non-Bypassable)

**These checks are MANDATORY. Task completion BLOCKED until resolved.**

### BLOCK 1: Critical Anti-Patterns Detected

**Check**: Tautology tests or empty test bodies

```bash
# Tautology pattern detection
grep -rE "expect\((true|false|1|0|'[^']*'|\"[^\"]*\")\)\.toBe\(\1\)" **/*.test.{ts,js,tsx,jsx}
grep -rE "expect\((true|false)\)\.toBe(Truthy|Falsy)\(\)" **/*.test.{ts,js,tsx,jsx}

# Empty test body detection
grep -rE "it\([^)]+,\s*(async\s*)?\(\)\s*=>\s*\{\s*\}\)" **/*.test.{ts,js,tsx,jsx}
grep -rE "test\([^)]+,\s*(async\s*)?\(\)\s*=>\s*\{\s*\}\)" **/*.test.{ts,js,tsx,jsx}
```

**Block Message (Chinese)**:
```
❌ 测试质量阻断：检测到致命反模式

文件：{file_path}:{line_number}
类型：{TAUTOLOGY | EMPTY_TEST}

发现的问题：
- expect(true).toBe(true) // 恒真测试，永远通过
- it('test name', () => {}) // 空测试体，无任何断言

影响：
- TAS 分数自动判定为 F 级 (0%)
- 任务无法标记为完成

修复方案：
1. 删除恒真断言，替换为实际行为验证
2. 添加有意义的断言到空测试体
3. 如测试不需要，直接删除而非留空

阻断原因：这类测试提供虚假的覆盖率，掩盖真实问题。
```

### BLOCK 2: TAS Score Below Threshold

**Check**: Overall TAS < 70%

**Block Message (Chinese)**:
```
❌ 测试质量阻断：TAS 分数不达标

当前分数：{score}% (等级：{grade})
最低要求：70% (等级：B)

各维度得分：
- Mock 比率：{mock_ratio}% (权重 25%)
- 断言质量：{assertion_quality}% (权重 35%)
- 真实执行：{real_execution}% (权重 25%)
- 模式合规：{pattern_compliance}% (权重 15%)

主要问题：
{issues_list}

修复建议：
{recommendations_list}

阻断原因：低质量测试会导致虚假的信心，无法捕获真实 bug。
```

### BLOCK 3: Zero Assertions in Test File

**Check**: Test file has `it()` or `test()` blocks but no `expect()` calls

**Block Message (Chinese)**:
```
❌ 测试质量阻断：测试文件无断言

文件：{file_path}
测试用例数：{test_count}
断言数量：0

问题：测试运行但不验证任何结果

修复方案：
- 为每个测试用例添加至少 1 个断言
- 使用 expect().toBe/toEqual/toContain 等

阻断原因：无断言的测试等于没有测试。
```

### BLOCK 4: Spec-Test Binding Violation (NEW)

**Check**: Test modification without corresponding spec change

```bash
# Check if test file was modified
git diff --name-only HEAD~1 | grep -E "\.test\.(ts|js|tsx|jsx)$"

# For each modified test, check if assertions decreased
git diff HEAD~1 -- {test_file} | grep -E "^-\s*expect\(" | wc -l  # removed
git diff HEAD~1 -- {test_file} | grep -E "^\+\s*expect\(" | wc -l  # added

# If assertions decreased >30%, check if spec was also modified
git diff --name-only HEAD~1 | grep -E "specs/|\.ultra/changes/"
```

**Block Message (Chinese)**:
```
❌ 测试质量阻断：规范-测试绑定违规

检测到测试断言减少但规范未变更：

文件：{test_file}
- 移除的断言：{removed_count}
- 新增的断言：{added_count}
- 净减少：{net_decrease} ({percentage}%)

关联规范：{spec_file}
- 规范变更：未检测到

问题：测试被弱化以通过验证，但需求规范未变更

修复方案：
1. 如果需求确实变更 → 先更新 specs/product.md
2. 如果需求未变更 → 恢复被删除的测试断言
3. 如果测试重构 → 确保新测试覆盖相同场景

阻断原因：降低测试标准必须伴随规范变更，否则视为降级编码。
```

---

## TAS Calculation

### Component Scoring

| Component | Weight | Calculation | Good | Bad |
|-----------|--------|-------------|------|-----|
| Mock Ratio | 25% | 100 - (internal_mocks / total_imports * 100) | >70% | <50% |
| Assertion Quality | 35% | behavioral_assertions / total_assertions * 100 | >80% | <50% |
| Real Execution | 25% | real_code_lines / total_test_lines * 100 | >60% | <30% |
| Pattern Compliance | 15% | 100 - (anti_patterns * 20) | 100% | <60% |

### Mock Classification

**External (OK to mock)**:
- HTTP clients (axios, fetch)
- Databases (mongoose, prisma, typeorm)
- Third-party SDKs (stripe, aws-sdk)
- File system (fs)
- Environment variables

**Internal (Should NOT mock)**:
- Your own modules (`../services/`, `../utils/`)
- Project utilities
- Business logic classes
- Custom hooks

### Assertion Classification

**Behavioral (Good)**:
- `.toBe()`, `.toEqual()`, `.toContain()`
- `.toThrow()`, `.toMatch()`
- `.toHaveLength()`, `.toHaveProperty()`
- Testing Library queries (`getByRole`, `getByText`)

**Mock-Only (Problematic)**:
- `.toHaveBeenCalled()` without value checks
- `.toHaveBeenCalledTimes()` alone
- Only verifying mock was invoked

### Anti-Pattern Penalties

| Pattern | Penalty | Auto Grade |
|---------|---------|------------|
| Tautology test | -100% | **F** (BLOCK) |
| Empty test body | -100% | **F** (BLOCK) |
| Zero assertions | -100% | **F** (BLOCK) |
| Commented expect | -20% | - |
| Skipped test | -15% | - |
| Mock-only assertions | -10% each | - |

### Grade Thresholds

| Grade | Score | Status | Action |
|-------|-------|--------|--------|
| A | 85-100% | Excellent | Pass |
| B | 70-84% | Good | Pass with notes |
| C | 50-69% | Poor | **BLOCKED** |
| D | 30-49% | Very Poor | **BLOCKED** |
| F | 0-29% | Failed | **BLOCKED** |

---

## Detection Patterns

### Mock Analysis (Grep)

```bash
# Internal module mocking (high risk)
grep -rE "jest\.mock\(['\"]\.\./" **/*.test.{ts,js}
grep -rE "vi\.mock\(['\"]\.\./" **/*.test.{ts,js}

# Mock function count
grep -rE "jest\.fn\(\)" **/*.test.{ts,js} | wc -l
grep -rE "vi\.fn\(\)" **/*.test.{ts,js} | wc -l

# Factory mock pattern (often problematic)
grep -rE "jest\.mock\([^)]+,\s*\(\)\s*=>" **/*.test.{ts,js}
```

### Assertion Analysis

```bash
# Total assertions
grep -rE "expect\(" **/*.test.{ts,js} | wc -l

# Behavioral assertions (good)
grep -rE "\.(toBe|toEqual|toContain|toThrow|toMatch|toHaveLength)\(" **/*.test.{ts,js} | wc -l

# Mock-only assertions (problematic)
grep -rE "\.toHaveBeenCalled\(\)(?!With)" **/*.test.{ts,js} | wc -l
grep -rE "\.toHaveBeenCalledTimes\([0-9]+\)$" **/*.test.{ts,js} | wc -l
```

### Critical Anti-Pattern Detection

```bash
# Tautology tests (CRITICAL - auto F grade)
grep -rEn "expect\((true|false)\)\.toBe\((true|false)\)" **/*.test.{ts,js}
grep -rEn "expect\(1\)\.toBe\(1\)" **/*.test.{ts,js}
grep -rEn "expect\(['\"][^'\"]+['\"]\)\.toBe\(\1\)" **/*.test.{ts,js}

# Empty test body (CRITICAL - auto F grade)
grep -rEn "it\([^)]+,\s*(async\s*)?\(\)\s*=>\s*\{\s*\}\)" **/*.test.{ts,js}
grep -rEn "test\([^)]+,\s*(async\s*)?\(\)\s*=>\s*\{\s*\}\)" **/*.test.{ts,js}

# Skipped tests (warning)
grep -rEn "(it|test)\.skip\(" **/*.test.{ts,js}
grep -rEn "x(it|describe)\(" **/*.test.{ts,js}

# Commented assertions (warning)
grep -rEn "//\s*expect\(" **/*.test.{ts,js}
```

---

## Spec-Test Binding (NEW)

### Trace-To Verification

Every acceptance test should reference its source specification:

```typescript
/**
 * @trace_to specs/product.md#user-authentication
 */
describe('User Authentication', () => {
  // Tests must validate spec requirements
});
```

### Binding Rules

1. **New tests**: Must include `@trace_to` comment
2. **Modified tests**: Check if spec also modified
3. **Assertion reduction >30%**: Requires spec change or explicit justification
4. **Spec change**: Should trigger test review

### Validation Process

```bash
# 1. List test files with @trace_to
grep -rEl "@trace_to" **/*.test.{ts,js}

# 2. For each test, verify spec exists
SPEC_REF=$(grep -oP "@trace_to\s+\K[^\s]+" {test_file})
[ -f "$SPEC_REF" ] || echo "Missing spec: $SPEC_REF"

# 3. Check assertion delta on modification
git diff --stat HEAD~1 -- {test_file}
```

---

## Output Format

### TAS Report (Chinese at runtime)

```
📊 测试质量分析报告
========================

项目 TAS 分数：{score}% (等级：{grade})

📁 分析文件：{count} 个
├── A 级 (85+)：{a_count} 个 ✅
├── B 级 (70-84)：{b_count} 个 ✅
├── C 级 (50-69)：{c_count} 个 ❌ (阻断)
└── D/F 级 (<50)：{df_count} 个 ❌ (阻断)

🔍 发现的问题：

{file_path} - TAS {score}% ({grade})
├── 问题：{issue_description}
├── 位置：第 {line} 行
├── 影响：{impact}
└── 修复：{recommendation}

========================
质量门禁结果：{PASS ✅ | BLOCKED ❌}

{如果阻断，显示修复优先级列表}
```

---

## Configuration

Thresholds in `.ultra/config.json`:

```json
{
  "testQuality": {
    "minTAS": 70,
    "maxMockRatio": 0.5,
    "minAssertionsPerTest": 1,
    "blockGrade": "C",
    "assertionReductionThreshold": 0.3,
    "requireTraceToForAcceptance": true
  }
}
```

---

## Don't

- Do not trigger for non-test files
- Do not block if only warnings (Grade B)
- Do not count external module mocks as violations
- Do not flag integration tests with real database usage
- Do not block for missing @trace_to in unit tests (only acceptance tests)

---

## Reference

See `guidelines/ultra-testing-philosophy.md` for:
- Core testing philosophy
- Mock boundary definitions
- 10 anti-pattern examples with fixes
- Testing Trophy model explanation

---

**OUTPUT: User messages in Chinese at runtime; keep this file English-only.**
