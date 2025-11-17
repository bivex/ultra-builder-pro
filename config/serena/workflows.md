# Serena MCP Workflow Integration

**Ultra Builder Pro 4.1** - Serena integration across all 7 development phases

> **Prerequisites**: Complete [Quick Start Guide](quick-start.md) first to understand name_path and basic commands.

---

## Part 2: Workflow Integration (By Phase)

### 2.1 /ultra-init - Project Initialization

**Scenario 1: New project startup**
```typescript
// 1. Activate project
mcp__serena__activate_project("my-new-project")

// 2. Initialize project memory (set coding conventions)
mcp__serena__write_memory("coding-conventions", `
## Coding Conventions

### Naming
- Files: kebab-case (user-service.ts)
- Classes: PascalCase (UserService)
- Functions/variables: camelCase (getUserById)
- Constants: UPPER_SNAKE_CASE (MAX_RETRY_COUNT)

### ESLint
- Rules: Airbnb
- Max lines: 50 lines/function
- Max complexity: 10

### Testing
- Framework: Vitest + React Testing Library
- Coverage: ≥80%
- File naming: *.test.ts
`)
```

**Scenario 2: Taking over legacy project**
```typescript
// 1. Activate project
mcp__serena__activate_project("legacy-crm-system")

// 2. Check onboarding status
mcp__serena__check_onboarding_performed()
// If returns false → need onboarding

// 3. Perform onboarding
mcp__serena__onboarding()
// Serena automatically analyzes project structure, generates report

// 4. Incremental codebase understanding
// Step 1: Find entry file
mcp__serena__find_file({
  file_mask: "index.ts",
  relative_path: "src/"
})

// Step 2: Understand entry file structure
mcp__serena__get_symbols_overview({
  relative_path: "src/index.ts"
})

// Step 3: Dive into key modules
mcp__serena__find_symbol({
  name_path: "App",
  relative_path: "src/index.ts",
  depth: 2  // See two levels of substructure
})

// 5. Record discovered architecture patterns
mcp__serena__write_memory("architecture-insights", `
## Architecture Discovery 2024-11-17

### Core Pattern
- **MVC Architecture**: Controllers → Services → Repositories
- **State Management**: Redux + Redux-Saga
- **API Layer**: Centralized in src/api/

### Technical Debt
- ⚠️ Missing type definitions (lots of any)
- ⚠️ Unit test coverage < 30%
- ⚠️ Average component 300+ lines (violates SOLID-S)

### Improvement Plan
1. Add TypeScript strict mode
2. Supplement core module tests
3. Refactor long components (extract logic)
`)
```

---

### 2.2 /ultra-research - Technical Research

**Scenario: Analyze existing system, choose tech stack**

```typescript
// 1. Understand existing state management
mcp__serena__search_for_pattern({
  substring_pattern: "createStore|useSelector|useDispatch",
  relative_path: "src/"
})
// Discovery: Heavy Redux usage

// 2. Assess migration impact
mcp__serena__find_referencing_symbols({
  name_path: "store",
  relative_path: "src/store/index.ts"
})
// Returns: 120 references across 45 files
// Conclusion: High migration cost, keep Redux

// 3. Record decision
mcp__serena__write_memory("tech-decision-state-mgmt", `
## State Management Decision 2024-11-17

### Current Status
- Redux + Redux-Saga: 120 references, 45 files
- Team familiar with Redux

### Options Evaluated
1. **Keep Redux** (recommended)
   - Pros: Zero migration cost, team familiar
   - Cons: Boilerplate heavy

2. **Migrate to Zustand**
   - Pros: Cleaner code, better performance
   - Cons: 40+ hours migration cost

### Decision
**Keep Redux**, because:
- Migration cost > benefits
- High team familiarity
- Performance bottleneck not in state management
`)
```

---

### 2.3 /ultra-plan - Task Planning

**Scenario: Assess refactoring task impact**

```typescript
// Task: Rename getUserById to fetchUserById

// Step 1: Find symbol definition
mcp__serena__find_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts"
})

// Step 2: Analyze reference impact
mcp__serena__find_referencing_symbols({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts"
})
// Returns: 78 references across 23 files

// Step 3: Group by file and count
// Most referenced files:
// - src/components/UserProfile.tsx: 12 references
// - src/components/UserList.tsx: 8 references
// - src/api/userController.ts: 15 references

// Step 4: Generate task plan
// Task complexity: Medium
// Estimated time: 5 minutes with Serena, 2 hours with Grep
// Dependencies: None
// Recommendation: Use Serena rename_symbol (zero risk)
```

---

### 2.4 /ultra-dev - TDD Development

#### RED Phase: Understand code to test

```typescript
// Task: Write test for processPayment

// Step 1: Understand function implementation
mcp__serena__find_symbol({
  name_path: "processPayment",
  relative_path: "src/services/payment.ts",
  include_body: true
})

// Returns:
// function processPayment(data: PaymentData): Promise<PaymentResult> {
//   validatePaymentData(data);           // Step 1: Validate
//   const transaction = createTransaction(data);  // Step 2: Create transaction
//   return executePayment(transaction);  // Step 3: Execute payment
// }

// Step 2: Find dependency functions
mcp__serena__find_symbol({
  name_path: "validatePaymentData",
  include_body: true
})

// Step 3: Write test (6-dimensional coverage)
// - Functional: Normal payment flow
// - Boundary: Amount 0, negative, overflow
// - Exception: Invalid card, insufficient balance
// - Performance: 1000 concurrent payments
// - Security: SQL injection, XSS attack
// - Compatibility: Multiple payment methods (credit card, PayPal, Alipay)
```

#### GREEN Phase: Incremental dependency understanding

```typescript
// When implementing feature, understand dependencies on demand

// Step 1: Check if similar implementation exists
mcp__serena__search_for_pattern({
  substring_pattern: "Stripe|PayPal|Payment",
  relative_path: "src/"
})

// Step 2: Understand existing payment integration
mcp__serena__find_symbol({
  name_path: "StripeService",
  depth: 1  // Only see method list
})
```

#### REFACTOR Phase: Safe refactoring

**Scenario 1: Function exceeds 50 lines, violates SOLID-S**

```typescript
// Detected: processPayment has 80 lines

// Step 1: Analyze function structure
mcp__serena__find_symbol({
  name_path: "processPayment",
  include_body: true
})

// Step 2: Extract validation logic
mcp__serena__insert_after_symbol({
  name_path: "processPayment",
  relative_path: "src/services/payment.ts",
  body: `
function validatePaymentData(data: PaymentData): ValidationResult {
  if (!data.cardNumber || data.cardNumber.length !== 16) {
    return { isValid: false, error: "Invalid card number" };
  }
  if (data.amount <= 0) {
    return { isValid: false, error: "Amount must be positive" };
  }
  return { isValid: true };
}
`
})

// Step 3: Simplify original function
mcp__serena__replace_symbol_body({
  name_path: "processPayment",
  relative_path: "src/services/payment.ts",
  body: `
function processPayment(data: PaymentData): Promise<PaymentResult> {
  const validation = validatePaymentData(data);
  if (!validation.isValid) {
    throw new PaymentError(validation.error);
  }

  const transaction = createTransaction(data);
  return executePayment(transaction);
}
`
})
```

**Scenario 2: Cross-file rename**

```typescript
// Requirement: getUserById → fetchUserById

// ❌ Wrong approach (high risk)
// Grep → Manual filtering → Edit (30% error rate)

// ✅ Correct approach (zero risk)
mcp__serena__rename_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts",
  new_name: "fetchUserById"
})
// Done! 78 references automatically updated, 0 errors
```

#### Project Memory: Record development decisions

```typescript
// After completing feature, record
mcp__serena__write_memory("recent-changes", `
## 2024-11-17

### New Feature: Payment Integration
- Integrated Stripe API
- Support credit card, PayPal
- Implemented refund functionality

### Technical Decisions
- **Chose Stripe over PayPal**
  Reason: Lower fees (2.9% vs 3.4%), better API

- **Used webhooks instead of polling**
  Reason: Better real-time, reduced server load

### Refactoring
- processPayment: 80 lines → 30 lines (extracted validatePaymentData)
- SOLID-S compliant: ✅

### Testing
- Six-dimensional coverage: 100%
- Boundary tests: Amount 0, negative, MAX_SAFE_INTEGER
- Security tests: SQL injection, XSS protection
`)
```

---

### 2.5 /ultra-test - Test Validation

**Scenario: Find untested public methods**

```typescript
// Step 1: List all public methods
mcp__serena__find_symbol({
  name_path: "",
  include_kinds: [6, 12],  // Methods (6) + Functions (12)
  relative_path: "src/services/"
})
// Returns: 45 public methods

// Step 2: Check each method's references
mcp__serena__find_referencing_symbols({
  name_path: "createUser",
  relative_path: "src/services/userService.ts"
})
// Analyze reference sources:
// - src/components/Register.tsx
// - src/api/userController.ts
// ❌ No references from .test.ts → Missing tests

// Step 3: Generate test TODO
// Untested methods (12 total):
// 1. UserService.createUser
// 2. UserService.updateProfile
// 3. PaymentService.refund
// ...

// Suggested test cases:
// - createUser: Normal creation, duplicate email, invalid data
// - updateProfile: Update success, user not found, insufficient permission
// - refund: Full refund, partial refund, expired refund
```

---

### 2.6 /ultra-deliver - Delivery Preparation

**Scenario 1: Auto-generate CHANGELOG**

```typescript
// Step 1: List all change memories
mcp__serena__list_memories()
// Filter: recent-changes-*

// Step 2: Read changes
mcp__serena__read_memory("recent-changes")

// Step 3: Generate CHANGELOG
// CHANGELOG.md:
// ## [v1.2.0] - 2024-11-17
//
// ### Features
// - Payment integration: Stripe + PayPal
// - Refund functionality
//
// ### Improvements
// - processPayment refactored (80 lines → 30 lines)
// - Test coverage: 75% → 92%
//
// ### Bug Fixes
// - Fixed login timeout issue
// - Fixed memory leak
```

**Scenario 2: Generate ADR (Architecture Decision Records)**

```typescript
// Step 1: Read technical decision memory
mcp__serena__read_memory("tech-decision-state-mgmt")

// Step 2: Generate ADR
// ADR-001-keep-redux.md:
//
// # ADR 001: Keep Redux State Management
//
// ## Context
// Project currently uses Redux + Redux-Saga, 120 references, 45 files.
// Team discussed migrating to Zustand.
//
// ## Decision
// Keep Redux, do not migrate.
//
// ## Consequences
// ### Pros
// - Zero migration cost
// - Team familiar, high dev efficiency
// - Mature community, rich resources
//
// ### Cons
// - Heavy boilerplate
// - Steep learning curve (for new team members)
//
// ### Risks
// - Redux ecosystem aging (within 5 years)
```

**Scenario 3: Technical Debt Tracking**

```typescript
// Step 1: Search all TODO/FIXME
mcp__serena__search_for_pattern({
  substring_pattern: "// TODO:|// FIXME:|// HACK:",
  relative_path: "src/"
})

// Step 2: Categorize and prioritize
// P0 (Critical - must fix):
// - UserService.ts:234 - Temporary performance hack, query too slow

// P1 (Important - should fix):
// - payment.ts:123 - Duplicate code, need extraction
// - auth.ts:45 - Missing type definitions

// P2 (Nice to have):
// - utils.ts:12 - Can be implemented more elegantly

// Step 3: Record to memory
mcp__serena__write_memory("technical-debt", `
## Technical Debt Inventory 2024-11-17
