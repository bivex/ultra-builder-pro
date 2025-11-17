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

### 4. Coverage Gap Analysis (Serena MCP)

**Purpose**: Use semantic analysis to find untested code that traditional coverage tools miss.

#### 4.1 Find Untested Public Methods

**Traditional coverage tools show**:
- Lines executed during tests
- Branch coverage percentage
- Overall coverage number (e.g., 82%)

**What they DON'T show**:
- Which public methods have no tests
- Which critical paths are untested
- Which classes lack boundary/exception tests

**Serena Solution**:
```typescript
// Step 1: Get all public methods in a file
mcp__serena__get_symbols_overview({
  relative_path: "src/services/userService.ts"
})
// Returns: All classes and methods with line numbers

// Step 2: For each public method, check if tests exist
mcp__serena__search_for_pattern({
  substring_pattern: "describe.*UserService.*getUserById",
  relative_path: "src/__tests__/"
})
// If no results → Method is untested

// Step 3: Find all references to understand criticality
mcp__serena__find_referencing_symbols({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts"
})
// High reference count → Critical path, needs 100% coverage
```

#### 4.2 Generate Test TODO List

**Output Format Template**:
```markdown
## Test Coverage Gap Analysis

### Critical Gaps (Critical Paths, 0% Coverage)
1. **UserService.deleteUser** (23 references)
   - [ ] Functional test: Normal user deletion
   - [ ] Boundary test: Delete non-existent user
   - [ ] Exception test: Database connection failure
   - [ ] Security test: Permission validation

2. **PaymentService.processRefund** (15 references)
   - [ ] Functional test: Full refund
   - [ ] Boundary test: Partial refund
   - [ ] Exception test: Duplicate refund on already refunded order
   - [ ] Performance test: Large refund processing time

### Medium Gaps (Public Methods, <80% Coverage)
3. **OrderService.calculateTax** (8 references)
   - [x] Functional test: Basic tax rate calculation (existing)
   - [ ] Boundary test: Tax-exempt items
   - [ ] Boundary test: Cross-state tax rates
   - [ ] Exception test: Missing tax rate configuration

### Minor Gaps (Low Priority, 80-100% Coverage)
4. **EmailService.formatTemplate** (2 references)
   - [x] Functional test: Basic template substitution (existing)
   - [ ] Boundary test: Null value handling
```

**OUTPUT: User messages in Chinese at runtime; keep this file English-only.**

#### 4.3 Six-Dimensional Coverage Matrix

**For each untested method, generate dimension checklist**:

```typescript
// Example: UserService.deleteUser has 0% coverage
// Serena analysis shows it's called from 23 places → Critical path

// Auto-generate comprehensive test plan:
const testPlan = {
  method: "UserService.deleteUser",
  criticality: "HIGH", // Based on reference count
  sixDimensions: {
    functional: [
      "Delete existing user successfully",
      "Return success confirmation"
    ],
    boundary: [
      "Delete non-existent user (404 handling)",
      "Delete user with ID = 0",
      "Delete user with very long ID"
    ],
    exception: [
      "Database connection failure",
      "Concurrent deletion attempts",
      "Delete user while they're logged in"
    ],
    performance: [
      "Delete operation completes <100ms",
      "Cascade delete 1000+ related records <500ms"
    ],
    security: [
      "Verify authentication required",
      "Verify authorization (only admin can delete)",
      "Prevent SQL injection in user ID"
    ],
    compatibility: [
      "Works with PostgreSQL and MySQL",
      "Works across all API versions"
    ]
  }
}
```

#### 4.4 Workflow Integration

**Automated flow**:
1. Run traditional coverage: `npm test -- --coverage`
2. Parse coverage report → Identify files with <80% coverage
3. For each under-covered file:
   - `get_symbols_overview` → List all public methods
   - `search_for_pattern` in test files → Check if tests exist
   - `find_referencing_symbols` → Assess criticality
4. Generate prioritized test TODO list
5. For critical paths (>10 references, 0% coverage) → Auto-generate six-dimensional test plan

**Output to**:
- `.ultra/docs/test-gaps-report.md` (detailed analysis)
- Console (prioritized TODO list in Chinese)

---

### 5. Fix and Retest

Iterate until all tests pass and metrics meet baselines.

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
  - test-strategy-guardian (six-dimensional coverage enforcement)
  - playwright-skill (E2E testing, auto-activates on keywords)
- **Next**: `/ultra-deliver` for deployment prep

## Output Format

**Standard output structure**: See `@config/ultra-command-output-template.md` for the complete 6-section format.

**Command icon**: 🧪

**Example output**: See template Section 7.5 for ultra-test specific example.

## References

- @guidelines/ultra-quality-standards.md - Complete testing standards
- @config/ultra-mcp-guide.md - Testing tools and strategy guide
