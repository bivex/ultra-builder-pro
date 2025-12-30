# Quality Guardian - Complete Reference

**Ultra Builder Pro 4.2** - Universal quality enforcement reference for SOLID principles, code quality, and testing.

> **Note**: Language/framework-specific patterns are in `frontend` and `backend` skills.
> This reference focuses on **principles** that apply to ALL code.

---

## Part 1: SOLID Principles

### Overview

SOLID principles are **mandatory**. Every code change must demonstrate adherence. Enforced by quality-guardian skill.

---

### S - Single Responsibility Principle

**Definition**: Each function/class does exactly one thing and has only one reason to change.

#### Rules
- ✅ Split immediately when a function exceeds 50 lines
- ✅ One class = one reason to change
- ✅ Extract helper functions aggressively

#### Example

**Bad** ❌:
```typescript
class User {
  saveToDatabase() { /* ... */ }
  sendWelcomeEmail() { /* ... */ }
  generateReport() { /* ... */ }
}
// Multiple responsibilities: persistence, email, reporting
```

**Good** ✅:
```typescript
class User { /* Only user data */ }
class UserRepository { save(user: User) { /* ... */ } }
class EmailService { sendWelcome(user: User) { /* ... */ } }
class ReportGenerator { generateUserReport(user: User) { /* ... */ } }
```

#### Detection Signals
- Function/class exceeds 50 lines
- Multiple unrelated methods in one class
- Class changes for multiple unrelated reasons

---

### O - Open/Closed Principle

**Definition**: Software entities should be open for extension, but closed for modification.

#### Rules
- ✅ Use interfaces/protocols for extensibility
- ✅ Strategy pattern over if-else chains
- ✅ Add new features without changing existing code

#### Example

**Bad** ❌:
```typescript
class PaymentProcessor {
  process(type: string, amount: number) {
    if (type === 'credit') { /* ... */ }
    else if (type === 'paypal') { /* ... */ }
    else if (type === 'bitcoin') { /* ... */ } // ← Modified existing code
  }
}
```

**Good** ✅:
```typescript
interface PaymentMethod {
  process(amount: number): Promise<void>;
}

class CreditCardPayment implements PaymentMethod {
  async process(amount: number) { /* ... */ }
}

class PayPalPayment implements PaymentMethod {
  async process(amount: number) { /* ... */ }
}

class BitcoinPayment implements PaymentMethod { // ← Extended without modifying
  async process(amount: number) { /* ... */ }
}

class PaymentProcessor {
  constructor(private method: PaymentMethod) {}
  async process(amount: number) {
    await this.method.process(amount);
  }
}
```

#### Detection Signals
- Frequent modifications to stable classes
- Long if-else or switch statements
- Fear of breaking existing functionality

---

### L - Liskov Substitution Principle

**Definition**: Subtypes must be substitutable for their base types without altering program correctness.

#### Rules
- ✅ Child classes must honor parent contracts
- ✅ No strengthening preconditions in overrides
- ✅ Preserve invariants of the parent class

#### Example

**Bad** ❌:
```typescript
class Rectangle {
  setWidth(w: number) { this.width = w; }
  setHeight(h: number) { this.height = h; }
  getArea(): number { return this.width * this.height; }
}

class Square extends Rectangle {
  setWidth(w: number) {
    this.width = w;
    this.height = w; // ← Violates LSP: unexpected side effect
  }
}

// This will fail:
function testRectangle(r: Rectangle) {
  r.setWidth(5);
  r.setHeight(10);
  console.assert(r.getArea() === 50); // ✅ Rectangle, ❌ Square (returns 100)
}
```

**Good** ✅:
```typescript
interface Shape {
  getArea(): number;
}

class Rectangle implements Shape {
  constructor(private width: number, private height: number) {}
  setWidth(w: number) { this.width = w; }
  setHeight(h: number) { this.height = h; }
  getArea(): number { return this.width * this.height; }
}

class Square implements Shape { // ← Not extending Rectangle
  constructor(private size: number) {}
  setSize(s: number) { this.size = s; }
  getArea(): number { return this.size * this.size; }
}
```

#### Detection Signals
- Subclass throws exceptions parent doesn't
- Need to check instance type before using

---

### I - Interface Segregation Principle

**Definition**: Keep interfaces focused and minimal. Clients should not depend on methods they don't use.

#### Rules
- ✅ No "fat interfaces" with 10+ methods
- ✅ Client-specific interfaces over general-purpose ones
- ✅ Multiple small interfaces over one large interface

#### Example

**Bad** ❌:
```typescript
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
  getPaid(): void;
  writeCode(): void;
  designUI(): void;
  testSoftware(): void;
}

class Developer implements Worker {
  work() { /* ... */ }
  writeCode() { /* ... */ }
  designUI() { throw new Error('Not applicable'); } // ← Forced to implement
}
```

**Good** ✅:
```typescript
interface Workable { work(): void; }
interface Programmer { writeCode(): void; }
interface Designer { designUI(): void; }

class Developer implements Workable, Programmer {
  work() { /* ... */ }
  writeCode() { /* ... */ }
}

class UIDesigner implements Workable, Designer {
  work() { /* ... */ }
  designUI() { /* ... */ }
}
```

#### Detection Signals
- Implementing empty or throwing methods
- Interface has many methods (>5)
- Different clients use different subsets

---

### D - Dependency Inversion Principle

**Definition**: Depend on abstractions, not concrete implementations.

#### Rules
- ✅ Inject dependencies through constructors
- ✅ Use interfaces for all external dependencies
- ✅ Configuration over hardcoded values

#### Example

**Bad** ❌:
```typescript
class UserService {
  private emailSender = new EmailSender(); // ← Hardcoded dependency

  registerUser(user: User) {
    // ...
    this.emailSender.send('Welcome!'); // ← Depends on concrete class
  }
}
```

**Good** ✅:
```typescript
interface MessageSender {
  send(message: string): Promise<void>;
}

class EmailSender implements MessageSender {
  async send(message: string) { /* ... */ }
}

class UserService {
  constructor(private messageSender: MessageSender) {} // ← Injected abstraction

  async registerUser(user: User) {
    // ...
    await this.messageSender.send('Welcome!'); // ← Depends on interface
  }
}

// Usage
const emailSender = new EmailSender();
const userService = new UserService(emailSender); // ← Easy to swap
```

#### Detection Signals
- Direct instantiation with `new` inside classes
- Hardcoded configuration values
- Difficulty testing (can't mock dependencies)

---

### Complementary Principles

#### DRY - Don't Repeat Yourself
- No code duplication >3 lines
- Abstract repeated patterns immediately

#### KISS - Keep It Simple
- Cyclomatic complexity <10 per function
- Maximum 3 levels of nesting

#### YAGNI - You Aren't Gonna Need It
- Only implement current requirements
- Delete unused code immediately

---

### Philosophy Priority

```
User Value > Technical Showoff
Code Quality > Development Speed
Systems Thinking > Fragmented Execution
Proactive Communication > Silent Work
Test-First > Ship-Then-Test
```

---

## Part 2: Code Quality Standards

### Core Requirements

- ✅ **Follow SOLID/DRY/KISS/YAGNI** - See Part 1 above
- ✅ **All public functions must have clear comments** - JSDoc/docstring format
- ✅ **Unit test coverage ≥80%** - Enforced by quality-guardian skill

### Code Smells Detection

Immediately fix when detected:

| Smell | Threshold | Fix |
|-------|-----------|-----|
| Long function | >50 lines | Split by responsibility |
| Deep nesting | >3 levels | Early return, extract |
| Magic numbers | Any | Named constants |
| Commented-out code | Any | Delete (use git) |
| God class | >500 lines | Split by responsibility |
| Long parameters | >5 params | Object parameters |
| Cryptic names | Any | Descriptive naming |
| Duplicate code | >3 lines | Extract to function |

### Code Documentation

```typescript
/**
 * Brief description of what function does.
 * @param paramName - Description
 * @returns Description of return value
 * @example
 * functionName(arg)  // Brief usage example
 */
```

---

## Part 3: Testing Standards

### Test Authenticity Score (TAS)

**Delegated to**: `guarding-test-quality` skill

Detects fake/useless tests through static analysis:

| Component | Weight | Pass Threshold |
|-----------|--------|----------------|
| Real Data | 30% | No mocks = 100, Any mock = 0 (ZERO MOCK) |
| Assertion Quality | 35% | >50% behavioral assertions |
| Real Execution | 20% | >50% real code paths |
| Pattern Compliance | 15% | 0 critical anti-patterns |

**Grade Thresholds**:
- A (85-100): ✅ High quality tests
- B (70-84): ✅ Pass with minor issues
- C (50-69): ❌ **BLOCKED** - Needs improvement
- D/F (<50): ❌ **BLOCKED** - Fake tests detected

### Realistic Test Execution (ZERO MOCK Policy)

- ✅ Execute tests 100% realistically
- ❌ NO jest.mock() or vi.mock() - use real implementations
- ❌ NO jest.fn() for business logic - use real functions
- ✅ Use real in-memory databases (SQLite, testcontainers)
- ✅ Use real HTTP servers (supertest, nock for external APIs only)
- ✅ Test environment approximates production

**Why**: Mocked tests give false confidence. Real tests catch real bugs.

### Six-Dimensional Test Coverage

**All six dimensions mandatory**:

| Dimension | Focus | Examples |
|-----------|-------|----------|
| **Functional** | Core business logic | Happy paths, integration |
| **Boundary** | Edge cases | Empty, max, min, null |
| **Exception** | Error handling | Network errors, timeouts |
| **Performance** | Speed/memory | Load tests, N+1 queries |
| **Security** | Protection | SQL injection, XSS, auth |
| **Compatibility** | Cross-platform | Browser, mobile, API versions |

### Coverage Requirements

| Scope | Target |
|-------|--------|
| Overall coverage | ≥80% |
| Critical paths | 100% |
| Branch coverage | ≥75% |
| Function coverage | ≥85% |

---

## Part 4: Quality Enforcement

### Automated Checks

| Check | Tool | Threshold |
|-------|------|-----------|
| Test coverage | CI/CD | ≥80% |
| Code smells | quality_analyzer.py | 0 violations |
| Complexity | ESLint/Pylint/golint | ≤10 |
| Security | SAST tools | 0 high/critical |

### Violation Consequences

| Violation | Consequence |
|-----------|-------------|
| Code quality violations | Task cannot complete |
| Test coverage <80% | PR blocked |
| Security issues | Immediate rollback |

---

## Quality Metrics Summary

| Metric | Target |
|--------|--------|
| Test Coverage | ≥80% |
| Code Smells | 0 |
| Cyclomatic Complexity | ≤10 |
| Function Lines | ≤50 |
| Nesting Depth | ≤3 |
| Build Time | <5min |

---

**Remember**: Quality is not negotiable. It's the foundation of sustainable software development.
