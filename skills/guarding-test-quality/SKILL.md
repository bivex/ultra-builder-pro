---
name: guarding-test-quality
description: "Validates test authenticity using TAS (Test Authenticity Score). This skill activates during /ultra-test, test file edits (*.test.ts, *.spec.ts), or task completion with tests."
---

# Test Quality Guardian (Production Absolutism)

> "There is no test code. There is no demo. There is no MVP.
> Every test is production verification. Every assertion verifies real behavior."

Ensures tests verify real behavior with real dependencies — no mock, no simulation, no degradation.

## Activation Context

This skill activates during:
- `/ultra-test` execution
- Test file modifications (*.test.ts, *.spec.ts, *.test.js, *.spec.js)
- Task completion that includes tests

## Resources

| Resource | Purpose |
|----------|---------|
| `scripts/tas_analyzer.py` | Calculate TAS scores |
| `references/complete-reference.md` | Detailed test patterns and examples |

## TAS Analysis

Run the analyzer to evaluate test quality:

```bash
python scripts/tas_analyzer.py <test-file>
python scripts/tas_analyzer.py src/  # All tests
python scripts/tas_analyzer.py --summary  # Summary only
```

## TAS Score Components (ZERO MOCK Edition)

| Component | Weight | High Score | Low Score |
|-----------|--------|------------|-----------|
| Real Data | 30% | No mocks (100) | Any mock detected (0) |
| Assertion Quality | 35% | Behavioral assertions | Mock-only assertions |
| Real Execution | 20% | >60% real code paths | <30% real code |
| Pattern Quality | 15% | Clean test structure | Anti-patterns present |

**CRITICAL**: Any `jest.mock()` or `vi.mock()` = RealData_Score = 0

## Grade Thresholds

| Grade | Score | Status |
|-------|-------|--------|
| A | 85-100% | Excellent - production ready |
| B | 70-84% | Good - minor improvements |
| C | 50-69% | Needs improvement |
| D/F | <50% | Significant issues |

## Production Absolutism Standards

**Quality Formula**:
```
Test Quality = Real Implementation × Real Dependencies × Real Assertions
If ANY component is fake/mocked/simulated → Quality = 0
```

## Good Test Characteristics

### Behavioral Assertions with Real Dependencies

Tests verify outcomes using real implementations:

```typescript
// Good: Tests actual behavior with REAL dependencies
describe('PaymentService', () => {
  it('confirms successful payment with transaction ID', async () => {
    const db = createTestDatabase();  // Real in-memory DB
    const gateway = createTestPaymentGateway();  // Real test gateway
    const service = new PaymentService(db, gateway);

    const result = await service.process(validOrder);

    expect(result.status).toBe('confirmed');
    expect(result.transactionId).toMatch(/^txn_/);

    // Verify real persistence
    const saved = await db.payments.findById(result.id);
    expect(saved.status).toBe('confirmed');
  });
});
```

### ZERO MOCK Policy (严禁模拟)

**Absolutely NO mocking allowed:**

| Prohibited | Use Instead |
|------------|-------------|
| `jest.mock()` / `vi.mock()` | Real in-memory implementations |
| `jest.fn()` for business logic | Real functions |
| Static/hardcoded data | Real data generators |
| Simplified implementations | Full production code |

**Real alternatives:**
- Databases → SQLite in-memory, testcontainers
- HTTP → supertest, nock (external APIs only)
- File system → tmp directories
- Time → real clock with controlled inputs

## Anti-Patterns to Detect

### 1. Tautology Tests

```typescript
// Always passes
expect(true).toBe(true);
```

**Fix:** Assert on actual function outputs

### 2. Empty Test Bodies

```typescript
it('should process payment', () => {
  // empty
});
```

**Fix:** Add behavioral assertions

### 3. Mock-Only Assertions (BANNED)

```typescript
// PROHIBITED: Only verifies call, not outcome
expect(mockService.process).toHaveBeenCalled();
```

**Fix:** Test real outcomes with real implementations

### 4. ANY Mocking (BANNED)

```typescript
// PROHIBITED: All mocking is forbidden
jest.mock('../services/UserService');  // ❌ REJECTED
vi.mock('../utils/validator');         // ❌ REJECTED
jest.fn().mockResolvedValue({});       // ❌ REJECTED
```

**Fix:** Use real in-memory implementations, never mock

### 5. Testing Implementation Details

```typescript
// BAD: Tests internal state, not behavior
it('should set isLoading to true when fetching', () => {
  const component = mount(<UserList />)
  component.instance().fetchUsers()
  expect(component.state('isLoading')).toBe(true)
})
```

**Fix:** Test what user sees, not internal state

### 6. Snapshot Overuse

```typescript
// BAD: 500+ line snapshots never reviewed
it('should render correctly', () => {
  const { container } = render(<ComplexDashboard data={mockData} />)
  expect(container).toMatchSnapshot()
})
```

**Fix:** Use specific behavioral assertions instead

### 7. Testing Private Methods

```typescript
// BAD: Accessing private implementation
it('should hash password internally', () => {
  // @ts-ignore - accessing private method
  const hash = service._hashPassword('password123')
})
```

**Fix:** Test through public interface only

### 8. Coupling to CSS Selectors

```typescript
// BAD: Breaks on CSS changes
await userEvent.click(document.querySelector('.btn-primary.submit-form'))
expect(document.querySelector('.error-container > .error-text')).toHaveTextContent('Required')
```

**Fix:** Use accessible queries (getByRole, getByLabelText)

### 9. Test Interdependence

```typescript
// BAD: Tests depend on shared mutable state
let userId: string
it('should create user', async () => { userId = (await createUser()).id })
it('should update user', async () => { await updateUser(userId, {...}) })
```

**Fix:** Each test self-contained with own setup

### 10. Hardcoded Waits

```typescript
// BAD: Magic number, slow, flaky
await new Promise(resolve => setTimeout(resolve, 2000))
expect(screen.getByText('Success')).toBeInTheDocument()
```

**Fix:** Use `findBy*` queries that wait dynamically

## Output Format

Provide analysis in Chinese at runtime:

```
📊 测试质量分析报告 (ZERO MOCK Edition)
========================

项目 TAS 分数：{score}% (等级：{grade})

分析摘要：
- 测试文件：{count} 个
- 平均断言数：{avg} 个/测试
- Mock 检测：{mock_count} 个 (必须为 0)

{发现的问题和改进建议}

========================
```

**Tone:** Constructive, educational, improvement-focused
