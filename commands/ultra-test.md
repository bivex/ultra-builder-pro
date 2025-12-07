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

### 5. Update Feature Status (NEW)

**After all tests pass**, update feature status for tracking:

```typescript
// Read existing feature status
const statusPath = ".ultra/docs/feature-status.json";
const status = JSON.parse(await Read(statusPath)) || { version: "1.0", features: [] };

// Get completed task info from tasks.json
const task = getTaskFromTasksJson(taskId);

// Create/update feature entry
const featureEntry = {
  id: `feat-${task.id}`,
  name: task.title,
  status: allTestsPassed ? "pass" : "fail",
  taskId: task.id,
  testedAt: new Date().toISOString(),
  commit: getCurrentCommitHash(),
  coverage: coveragePercentage,  // from test run
  coreWebVitals: {              // if frontend
    lcp: lcpValue,
    inp: inpValue,
    cls: clsValue
  }
};

// Update or add feature
const existingIdx = status.features.findIndex(f => f.taskId === task.id);
if (existingIdx >= 0) {
  status.features[existingIdx] = featureEntry;
} else {
  status.features.push(featureEntry);
}

// Write back
await Write(statusPath, JSON.stringify(status, null, 2));
```

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
