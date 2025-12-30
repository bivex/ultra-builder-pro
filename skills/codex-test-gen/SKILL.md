---
name: codex-test-gen
description: "Generates production-grade tests with 6-dimensional coverage (functional, boundary, exception, performance, security, compatibility). This skill enforces real implementation without TODO/mock/demo patterns and calculates TAS scores."
---

<CRITICAL_REQUIREMENT>
## ⚠️ MANDATORY: Execute Codex CLI

You MUST execute `codex exec` command to generate tests. This skill is NOT complete without actual Codex CLI execution.

```bash
# Required execution (JSONL event stream):
codex exec --json "Generate 6D tests for {file_path}. Coverage: functional, boundary, exception, performance, security, compatibility. No TODO/mock." | jq

# Or without jq parsing:
codex exec "Generate comprehensive tests for {file_path}. Include edge cases, error handling, performance tests."

# Or use the script:
~/.claude/skills/codex-test-gen/scripts/generate.sh {source_file_path}
```

**DO NOT** just read this skill and write tests manually. **YOU MUST** run Codex CLI.
</CRITICAL_REQUIREMENT>

# Codex Test Generator

## Purpose

Generate **production-grade, comprehensive tests** that verify real business functionality. Tests must exercise actual code paths with real dependencies.

**Core Principle (Production Absolutism)**:

> "There is no test code. There is no demo. There is no MVP.
> Every test is production verification. Every assertion verifies real behavior."

```
Test Quality = Real Implementation × Real Dependencies × Real Assertions
If ANY component is fake/mocked/simulated → Quality = 0
```

---

## Resources

| Resource | Purpose |
|----------|---------|
| `scripts/generate.sh` | Generate tests via codex CLI |

### Quick Start

```bash
# Generate tests for a source file
./scripts/generate.sh src/services/payment.ts

# Specify output file
./scripts/generate.sh src/services/payment.ts --output src/services/payment.test.ts
```

---

## CRITICAL: Production-Grade Requirements

### Absolute Prohibitions (Production Absolutism)

These patterns are **NEVER ALLOWED** — immediate rejection, no exceptions:

| Category | Prohibited Patterns | Detection |
|----------|---------------------|-----------|
| **Mock/Simulation** | `jest.mock()`, `vi.mock()`, `jest.fn()`, `AsyncMock` | `grep -E "jest\.mock\|vi\.mock\|jest\.fn"` |
| **Degradation** | Fallback logic, simplified implementations | Code review |
| **Static Data** | Hardcoded fixtures, inline test data | `grep -E "const.*=.*\[{.*}\]"` |
| **Placeholders** | `TODO`, `FIXME`, `// demo`, `// placeholder` | `grep -E "TODO\|FIXME\|demo\|placeholder"` |
| **Test Cheating** | Tautologies, empty bodies, skipped tests | `grep -E "expect\(true\)\|\.skip\(\)\|\.todo\(\)"` |
| **MVP Mindset** | "Good enough", partial implementations | Code review |

**Quality Formula**:
```
If ANY prohibited pattern detected → TAS = 0 → Immediate rejection
No exceptions. No "just this once". No "we'll fix it later".
```

### What Production-Grade Means

```typescript
// WRONG: Demo code - tests nothing real
it('should work', () => {
  const result = true;  // Static data
  expect(result).toBe(true);  // Tautology
});

// WRONG: Over-mocked - doesn't test real code
it('should create user', async () => {
  jest.mock('../services/user');  // Mocking internal module
  const mockCreate = jest.fn().mockResolvedValue({ id: 1 });
  await mockCreate({ name: 'test' });
  expect(mockCreate).toHaveBeenCalled();  // Only verifies mock was called
});

// CORRECT: Production-grade - tests real behavior
it('should create user with valid data', async () => {
  // Arrange - real service with only external deps mocked
  const db = createTestDatabase();  // Real in-memory DB
  const service = new UserService(db);

  // Act - real code path
  const user = await service.create({
    email: 'test@example.com',
    name: 'Test User',
    password: 'SecurePass123!'
  });

  // Assert - verifies actual behavior
  expect(user.id).toBeDefined();
  expect(user.email).toBe('test@example.com');
  expect(user.password).not.toBe('SecurePass123!');  // Should be hashed
  expect(user.password).toMatch(/^\$2[aby]?\$/);  // Bcrypt pattern

  // Verify persistence
  const found = await db.users.findById(user.id);
  expect(found).toEqual(user);
});
```

---

## Trigger Conditions

1. **Command binding**: Auto-triggers with `/ultra-test`
2. **Coverage gap**: Coverage < 80% detected
3. **GREEN phase**: After TDD GREEN phase completion
4. **Manual**: User requests test generation

---

## Test Dimensions (6D Coverage)

### 1. Functional Tests

Verify core business logic with real data flows:

```typescript
describe('PaymentService', () => {
  it('should process valid payment and update order status', async () => {
    const order = await createTestOrder({ total: 99.99 });
    const payment = await service.process(order.id, validCard);

    expect(payment.status).toBe('completed');
    expect(payment.transactionId).toMatch(/^txn_/);

    const updatedOrder = await orderRepo.findById(order.id);
    expect(updatedOrder.status).toBe('paid');
  });
});
```

### 2. Boundary Tests

Test edge cases with actual boundary values:

```typescript
describe('pagination', () => {
  it('should return empty array for page beyond data', async () => {
    await seedTestData(10);  // Real data
    const result = await service.list({ page: 999, limit: 10 });
    expect(result.items).toHaveLength(0);
    expect(result.hasMore).toBe(false);
  });

  it('should handle limit at maximum allowed value', async () => {
    await seedTestData(200);
    const result = await service.list({ page: 1, limit: 100 });
    expect(result.items).toHaveLength(100);  // Capped at max
  });
});
```

### 3. Exception Tests

Verify error handling with real error conditions:

```typescript
describe('error handling', () => {
  it('should throw ValidationError with field details', async () => {
    const invalid = { email: 'not-an-email', name: '' };

    await expect(service.create(invalid)).rejects.toMatchObject({
      name: 'ValidationError',
      fields: {
        email: 'Invalid email format',
        name: 'Name is required'
      }
    });
  });

  it('should handle database timeout gracefully', async () => {
    // Simulate real timeout condition
    db.setQueryTimeout(1);

    await expect(service.create(validData)).rejects.toMatchObject({
      name: 'ServiceUnavailableError',
      retryable: true
    });
  });
});
```

### 4. Performance Tests

Verify performance with real workloads:

```typescript
describe('performance', () => {
  it('should process batch within SLA', async () => {
    const items = generateTestItems(1000);  // Real test data

    const start = performance.now();
    await service.batchProcess(items);
    const duration = performance.now() - start;

    expect(duration).toBeLessThan(500);  // 500ms SLA
  });

  it('should handle concurrent requests', async () => {
    const requests = Array(100).fill(null).map(() =>
      service.process(generateTestOrder())
    );

    const results = await Promise.all(requests);
    expect(results.every(r => r.success)).toBe(true);
  });
});
```

### 5. Security Tests

Verify security controls with real attack vectors:

```typescript
describe('security', () => {
  it('should reject SQL injection in search', async () => {
    const malicious = "'; DROP TABLE users; --";

    // Should sanitize or reject, not execute
    await expect(service.search(malicious)).resolves.toEqual([]);

    // Verify table still exists
    const count = await db.users.count();
    expect(count).toBeGreaterThan(0);
  });

  it('should rate limit login attempts', async () => {
    const attempts = Array(10).fill(null).map(() =>
      service.login('user@test.com', 'wrong')
    );

    const results = await Promise.allSettled(attempts);
    const blocked = results.filter(r =>
      r.status === 'rejected' && r.reason.code === 'RATE_LIMITED'
    );

    expect(blocked.length).toBeGreaterThan(0);
  });
});
```

### 6. Compatibility Tests

Verify cross-environment behavior:

```typescript
describe('compatibility', () => {
  it('should handle different date formats', () => {
    const formats = [
      '2024-01-15',
      '01/15/2024',
      '15-01-2024',
      new Date('2024-01-15').toISOString()
    ];

    formats.forEach(input => {
      const result = service.parseDate(input);
      expect(result.getFullYear()).toBe(2024);
      expect(result.getMonth()).toBe(0);  // January
      expect(result.getDate()).toBe(15);
    });
  });
});
```

---

## Codex Call Template

```bash
codex -q --json <<EOF
You are a test engineering expert. Generate production-grade tests for:

Implementation Code:
\`\`\`typescript
{implementation_code}
\`\`\`

CRITICAL REQUIREMENTS:

1. **Production-Grade Only**
   - NO TODO/FIXME comments
   - NO empty test bodies
   - NO tautology tests (expect(true).toBe(true))
   - NO static/hardcoded data without source
   - NO demo or placeholder code
   - NO degraded or simplified functionality

2. **ZERO MOCK Policy** (严禁模拟)
   - NO jest.mock() or vi.mock() of ANY module
   - NO mock functions (jest.fn(), vi.fn()) for business logic
   - NO static/hardcoded test data - use real data generators
   - NO simplified or degraded implementations
   - NO spy on internal modules
   - USE real in-memory databases (SQLite, testcontainers)
   - USE real HTTP servers (supertest, nock for external APIs only)
   - USE real file system (tmp directories)

3. **Assertion Quality**
   - Use behavioral assertions (toBe, toEqual, toThrow)
   - Verify actual outcomes, not just that code ran
   - Each test must have >= 1 meaningful assertion
   - Avoid mock-only assertions (toHaveBeenCalled without behavioral check)

4. **6-Dimensional Coverage**
   - Functional: Core business logic
   - Boundary: null, empty, max, min, edge values
   - Exception: Error paths with recovery verification
   - Performance: SLA verification where applicable
   - Security: Input validation, injection prevention
   - Compatibility: Cross-environment behavior

5. **Confidence Level**
   - Output tests only with >= 90% confidence
   - Mark any uncertainty explicitly
   - Prefer fewer high-quality tests over many weak tests

Output complete test file with NO placeholders.
EOF
```

---

## Quality Gates

| Metric | Requirement | Detection |
|--------|-------------|-----------|
| TAS Score | >= 70% | Calculated per file |
| Coverage | >= 80% | `npm test -- --coverage` |
| Mock Count | **0** | `grep -c "jest.mock\|vi.mock"` - 必须为零 |
| Tautologies | 0 | `expect(true/false).toBe()` |
| Empty Tests | 0 | Test body has no assertions |
| TODO Count | 0 | `grep -c TODO` |
| Static Data | 0 | Hardcoded literals without factory |

---

## TAS Calculation

Test Authenticity Score (TAS) formula (Zero-Mock Edition):

```
TAS = (RealData_Score × 0.30) + (Assertion_Score × 0.35) +
      (Execution_Score × 0.20) + (Pattern_Score × 0.15)

RealData_Score = 100 if no mocks, 0 if any mock detected
Assertion_Score = behavioral_assertions / total_assertions × 100
Execution_Score = real_code_lines / total_test_lines × 100
Pattern_Score = 100 - (anti_patterns × 20)
```

**Anti-Patterns (每项 -20 分)**:
- jest.mock() / vi.mock()
- jest.fn() for business logic
- Static hardcoded data
- expect(true).toBe(true)
- Empty test body
- TODO/FIXME comments

### Grade Thresholds

| Grade | TAS Range | Status |
|-------|-----------|--------|
| A | 85-100 | Pass |
| B | 70-84 | Pass with minor issues |
| C | 50-69 | **BLOCKED** - Needs improvement |
| D | 30-49 | **BLOCKED** - Major issues |
| F | 0-29 | **BLOCKED** - Fake tests detected |

---

## Configuration

```json
{
  "codex-test-gen": {
    "minCoverage": 80,
    "minTAS": 70,
    "maxMockCount": 0,
    "zeroMockPolicy": true,
    "dimensions": ["functional", "boundary", "exception", "security", "performance", "compatibility"],
    "testFramework": "vitest",
    "outputPattern": "{filename}.test.ts",
    "prohibitedPatterns": [
      "TODO",
      "FIXME",
      "expect(true).toBe(true)",
      "expect(false).toBe(false)",
      "jest.mock('../",
      "vi.mock('../",
      ".skip(",
      ".todo("
    ],
    "confidenceThreshold": 0.9
  }
}
```

---

## Integration with TDD Workflow

```
Claude Code RED (write failing test)
        ↓
Claude Code GREEN (minimum passing code)
        ↓
Codex generates additional tests
        ↓
        Coverage >= 80%?
        ├─ No  → Codex generates more tests
        └─ Yes → TAS >= 70%?
                 ├─ No  → Codex regenerates with feedback
                 └─ Yes → Claude Code REFACTOR
```

---

## Honest Output

When generating tests, always include confidence assessment:

```markdown
## Test Generation Report

**Confidence**: 92%

**Generated Tests**: 12
**Coverage Impact**: +15% (65% → 80%)
**TAS Score**: 78% (Grade B)

**Uncertainty Notes**:
- Line 45-48: Edge case behavior inferred from similar patterns
- Line 82: Error message format assumed from code structure

**Verification Required**:
- Run `npm test` to confirm all tests pass
- Review security tests against actual threat model
```
