---
description: Comprehensive testing (six-dimensional coverage + Core Web Vitals)
allowed-tools: TodoWrite, Bash, Read, Write, Task, Grep, Glob
---

# /ultra-test

## Purpose

Execute comprehensive testing with six-dimensional coverage and Core Web Vitals monitoring.

## Pre-Execution Checks

- Check for code changes via `git status`
- Assess existing test coverage (read coverage report if available)
- Detect frontend vs backend: Frontend requires Core Web Vitals testing
- Verify test frameworks configured

## Workflow

### 1. Design Test Strategy

Design comprehensive strategy covering all six dimensions:
**Functional, Boundary, Exception, Performance, Security, Compatibility**

**Reference**: See `guidelines/quality-standards.md#six-dimensional-test-coverage` for complete details.

### 2. Execute Tests

**Unit/Integration** (Built-in Bash):
```bash
npm test -- --coverage  # JavaScript/TypeScript (≥80% coverage)
pytest --cov=src --cov-report=html  # Python
go test -coverprofile=coverage.out ./...  # Go
```

**E2E Testing** (Playwright Skill auto-activates):
When you mention "E2E test" or "browser automation":
1. Playwright Skill generates test code (TypeScript)
2. Run tests: `npx playwright test`
3. Reports results in Chinese

**Performance** (Frontend only - Lighthouse CLI):
```bash
lighthouse http://localhost:3000 --only-categories=performance --output=json
```

**Reference**: `@config/ultra-mcp-guide.md` for complete testing tools guide

### 3. Analyze Results

- Collect metrics from all test types
- Identify failures and root causes
- Generate fix recommendations

---

### 3.5 Test Coverage Gap Analysis (AI Automated)

**AI Workflow** (executes automatically after test execution):

```typescript
// Step 1: Find all exported functions, classes, and methods
const exports = Grep({
  pattern: "export (function|const|class)",
  path: "src/",
  type: "ts",
  output_mode: "content",
  "-n": true
});

// Step 2: Extract symbol names
// Example matches:
// - "export function login(" → "login"
// - "export class UserService" → "UserService"
// - "export const getUserById =" → "getUserById"
const symbolNames = [];
exports.split('\n').forEach(line => {
  const match = line.match(/export\s+(function|const|class)\s+(\w+)/);
  if (match) symbolNames.push(match[2]);
});

// Step 3: Search for each symbol in test files
const gaps = [];
for (const symbol of symbolNames) {
  const testMatches = Grep({
    pattern: symbol,
    path: "**/*.test.ts",
    output_mode: "count"
  });

  if (testMatches === 0) {
    gaps.push({
      symbol,
      file: extractFileFromGrep(symbol),  // Helper to get file path
      status: 'UNTESTED'
    });
  }
}

// Step 4: Generate gap report
const gapReport = `
# Test Coverage Gaps Report

Generated: ${new Date().toISOString()}

## Summary
- Total Exported Symbols: ${symbolNames.length}
- Untested Symbols: ${gaps.length}
- Coverage: ${((1 - gaps.length / symbolNames.length) * 100).toFixed(1)}%

## Untested Methods/Functions

${gaps.map(gap => `- ❌ **${gap.symbol}** (\`${gap.file}\`) - 0 test cases found`).join('\n')}

## Recommendations

${gaps.slice(0, 5).map(gap => `
### ${gap.symbol}
**File**: \`${gap.file}\`
**Priority**: ${gap.symbol.includes('delete') || gap.symbol.includes('remove') ? 'HIGH' : 'MEDIUM'}
**Suggested Test Dimensions**:
1. Functional: Core logic validation
2. Boundary: Edge cases (null, empty, max values)
3. Exception: Error handling
4. Security: Input validation
`).join('\n')}
`;

Write(".ultra/docs/test-coverage-gaps.md", gapReport);
```

**Output**: `.ultra/docs/test-coverage-gaps.md`

**Accuracy**: ~90%
- ✅ Detects most untested exports
- ⚠️ May miss: Methods inside classes (requires deeper analysis), private functions (not exported), dynamic exports

**Token cost**: ~8000 tokens

**When to use**:
- After running `npm test -- --coverage`
- Before marking task as complete
- During /ultra-test Phase 3

**Optional: User Review for Higher Accuracy**:
- Review AI-generated gap report
- Compare with coverage report HTML for detailed line-by-line coverage
- Add missed methods identified by AI to test suite

---

### 4. Fix and Retest

Iterate until all tests pass and metrics meet baselines.

### 5. Update Feature Status (MANDATORY)

**⚠️ CRITICAL: This step is NON-OPTIONAL. Execute AFTER all test results are collected.**

**Status Mapping**:
| Condition | Status |
|-----------|--------|
| All tests pass AND coverage ≥80% | "pass" |
| Any test fails OR coverage <80% | "fail" |

**Step 1: Identify tested tasks**
Read completed tasks from tasks.json that need status update:
```bash
cat .ultra/tasks/tasks.json | jq '.tasks[] | select(.status == "completed")'
```

**Step 2: Read existing feature status**
```bash
cat .ultra/docs/feature-status.json
```

**Step 3: Update each task's feature status** (execute, not just describe)
For each completed task:
1. Find entry in feature-status.json by taskId
2. If found → Update existing entry:
   - `status`: "pass" or "fail" (based on test results)
   - `testedAt`: current ISO timestamp
   - `coverage`: percentage from test run
   - `coreWebVitals`: {lcp, inp, cls} (frontend only)
3. If NOT found → Create new entry with test results

**Step 4: Write updated feature-status.json**

**Step 5: Verify update succeeded**
```bash
cat .ultra/docs/feature-status.json | grep "testedAt"
# Must show updated timestamps
```

**Output Format** (Chinese at runtime):
```
Test completion message including:
   - Feature status updates: feat-{id} ({name}): pass/fail (coverage: X%)
   - Test summary: Unit tests X/Y passed, E2E tests X/Y passed
   - Total coverage: X%
   - Core Web Vitals: LCP, INP, CLS values
   - Issues to fix (if any): Coverage below 80%
```

**Failure Handling**:
If feature-status.json update fails:
1. Display warning (Chinese at runtime)
2. Log error to .ultra/docs/status-sync.log
3. Continue with test report (do NOT block)
4. syncing-status Skill will auto-fix on next trigger

**Benefits**:
- Track pass/fail status per feature
- Historical verification records
- Commit traceability for debugging

## Quality Gates (All Must Pass)

- ✅ Unit coverage ≥80%
- ✅ All E2E tests pass
- ✅ **Frontend only**: Core Web Vitals:
  - LCP (Largest Contentful Paint) <2.5s
  - INP (Interaction to Next Paint) <200ms
  - CLS (Cumulative Layout Shift) <0.1
- ✅ No critical security issues

**Reference**: `@guidelines/ultra-quality-standards.md` for detailed requirements

## Integration

- **Skills**:
  - guarding-quality (six-dimensional coverage enforcement)
  - playwright-skill (E2E testing, auto-activates on keywords)
- **Next**: `/ultra-deliver` for deployment prep

## Output Format

**Standard output structure**: See `@config/ultra-command-output-template.md` for the complete 6-section format.

**Command icon**: 🧪

**Example output**: See template Section 7.5 for ultra-test specific example.

## References

- @guidelines/ultra-quality-standards.md - Complete testing standards
- @config/ultra-mcp-guide.md - Testing tools and strategy guide
