# Serena MCP Reference Guide

**Ultra Builder Pro 4.1** - Advanced patterns, complete tool list, and troubleshooting

> **Prerequisites**: Complete [Quick Start](quick-start.md) and [Workflows](workflows.md) first.

---


### P0 (Critical - Fix this week)
- [ ] UserService.ts:234 - Optimize query performance
  Reason: Full table scan each query, affects 50+ users
  Solution: Add index or use cache

### P1 (Important - Fix this month)
- [ ] payment.ts:123 - Extract duplicate code
- [ ] auth.ts:45 - Add type definitions

### P2 (Nice to Have)
- [ ] utils.ts:12 - Rewrite formatDate function
`)
```

---

### 2.7 /ultra-refactor - Dedicated Refactoring

**Scenario 1: Extract Interface (SOLID-I)**

```typescript
// Problem: UserService interface bloated (12 methods)
// Solution: Extract minimal interfaces

// Step 1: Analyze UserService methods
mcp__serena__find_symbol({
  name_path: "UserService",
  depth: 1,
  include_body: false
})

// Returns:
// - login, logout (authentication related)
// - getUserById, searchUsers (query related)
// - createUser, updateUser, deleteUser (CRUD related)
// - sendEmail, sendSMS (notification related)

// Step 2: Identify method subsets used by clients
mcp__serena__find_referencing_symbols({
  name_path: "UserService",
  relative_path: "src/services/userService.ts"
})
// Analysis:
// - UserProfile component only uses: getUserById, updateUser
// - UserList component only uses: searchUsers
// - LoginForm component only uses: login, logout

// Step 3: Create minimal interfaces
mcp__serena__insert_before_symbol({
  name_path: "UserService",
  relative_path: "src/services/userService.ts",
  body: `
// Read-only interface (query)
interface UserReader {
  getUserById(id: string): Promise<User>;
  searchUsers(query: string): Promise<User[]>;
}

// Authentication interface
interface UserAuthenticator {
  login(credentials: Credentials): Promise<AuthResult>;
  logout(userId: string): Promise<void>;
}

// Complete service interface
interface UserService extends UserReader, UserAuthenticator {
  createUser(data: UserData): Promise<User>;
  updateUser(id: string, data: Partial<UserData>): Promise<User>;
  deleteUser(id: string): Promise<void>;
}
`
})
```

**Scenario 2: Dependency Injection (SOLID-D)**

```typescript
// Problem: UserService hardcoded dependencies
// class UserService {
//   private emailSender = new EmailSender();  // ← Hardcoded
// }

// Step 1: Auto-detect hardcoded dependencies
mcp__serena__search_for_pattern({
  substring_pattern: "= new [A-Z]\\w+\\(",
  relative_path: "src/services/"
})
// Found: 15 hardcoded dependencies

// Step 2: Refactor to dependency injection
mcp__serena__replace_symbol_body({
  name_path: "UserService",
  relative_path: "src/services/userService.ts",
  body: `
class UserService {
  constructor(
    private emailSender: EmailSender,  // ← Inject dependency
    private database: Database
  ) {}

  async createUser(data: UserData): Promise<User> {
    const user = await this.database.insert(data);
    await this.emailSender.send('Welcome!', user.email);
    return user;
  }
}
`
})
```

---

## Part 3: Advanced Techniques

### 3.1 depth Parameter Mastery

**depth controls how many levels of substructure to return**:

```typescript
// depth = 0 (default): Only return symbol itself
mcp__serena__find_symbol({
  name_path: "UserService",
  depth: 0
})
// Returns: UserService (Class)

// depth = 1: Return symbol + one level of substructure
mcp__serena__find_symbol({
  name_path: "UserService",
  depth: 1
})
// Returns:
// UserService (Class)
//   - constructor (Method)
//   - login (Method)
//   - register (Method)

// depth = 2: Return symbol + two levels of substructure
mcp__serena__find_symbol({
  name_path: "UserService",
  depth: 2
})
// Returns:
// UserService (Class)
//   - login (Method)
//     - validateCredentials (nested function)
//     - createSession (nested function)
```

**Usage recommendations**:
- depth = 0: Only need to know if symbol exists
- depth = 1: Understand class method list
- depth = 2: Understand method internal structure
- depth > 2: Use cautiously (information overload)

---

### 3.2 kind Filtering Advanced Usage

**LSP Symbol Kind List**:
```
1  = File          6  = Method        12 = Function      18 = Array
2  = Module        7  = Property      13 = Variable      19 = Object
3  = Namespace     8  = Field         14 = Constant      22 = EnumMember
4  = Package       9  = Constructor   15 = String        23 = Struct
5  = Class        10  = Enum          16 = Number        24 = Event
              11  = Interface    17 = Boolean       25 = Operator
```

**Practical combinations**:

```typescript
// Only find classes and interfaces
mcp__serena__find_symbol({
  name_path: "",
  include_kinds: [5, 11],  // Class + Interface
  relative_path: "src/types/"
})

// Only find executable code (methods + functions)
mcp__serena__find_symbol({
  name_path: "",
  include_kinds: [6, 12],  // Method + Function
  relative_path: "src/"
})

// Exclude private fields
mcp__serena__find_symbol({
  name_path: "UserService",
  depth: 1,
  exclude_kinds: [7, 8]  // Exclude Property + Field
})
```

---

### 3.3 substring_matching Techniques

**Exact match vs substring match**:

```typescript
// Exact match (default)
mcp__serena__find_symbol({
  name_path: "getUserById",
  substring_matching: false
})
// Only matches: getUserById

// Substring match
mcp__serena__find_symbol({
  name_path: "User",
  substring_matching: true
})
// Matches:
// - User (class name)
// - UserService (class name)
// - getUserById (method name)
// - createUser (method name)
// - userRepository (variable name)
```

**Use cases**:
- Exact match: Rename specific symbol
- Substring match: Exploratory search ("find all User-related code")

---

### 3.4 memory Search Techniques

**Best practices for organizing memory**:

```
Naming conventions:
- tech-decision-{topic}    # Technical decisions
- coding-conventions       # Coding conventions
- recent-changes          # Recent changes
- architecture-insights   # Architecture insights
- technical-debt          # Technical debt
- refactoring-log         # Refactoring log
```

**Query techniques**:

```typescript
// List all memories
mcp__serena__list_memories()

// Filter specific type
// (Manually filter by prefix in returned list)

// Read specific memory
mcp__serena__read_memory("tech-decision-state-mgmt")

// Update memory (append content)
mcp__serena__edit_memory({
  memory_file_name: "recent-changes",
  regex: "(## \\d{4}-\\d{2}-\\d{2})",
  repl: "## 2024-11-18\\n\\n### New Feature\\n- XXX\\n\\n$1"
})
```

---

## Part 4: Case Studies

### Case 1: Taking Over 5000-Line Legacy Code

**Background**:
- File: src/legacy/monolith.ts (5000 lines)
- No docs, no comments
- Task: Understand architecture and refactor

**Steps**:

```typescript
// Step 1: Get structure (~500 tokens)
mcp__serena__get_symbols_overview({
  relative_path: "src/legacy/monolith.ts"
})

// Returns 20 classes, identify core classes:
// - UserManager (500 lines)
// - PaymentProcessor (800 lines)
// - EmailService (300 lines)
// ...

// Step 2: Dive into core class (~2k tokens)
mcp__serena__find_symbol({
  name_path: "UserManager",
  depth: 1  // Only see method list, not implementation
})

// Returns 12 methods, identify responsibilities:
// - Authentication: login, logout, refreshToken
// - CRUD: createUser, updateUser, deleteUser
// - Query: getUserById, searchUsers
// - Notification: sendWelcomeEmail, sendPasswordReset

// Step 3: Identify violations (SOLID-S)
// UserManager has 3 responsibilities:
// 1. Authentication management
// 2. User CRUD
// 3. Email notification ← Shouldn't be here

// Step 4: Create refactoring plan
mcp__serena__write_memory("refactoring-plan-user-manager", `
## UserManager Refactoring Plan

### Problem
- 500 lines of code (violates SOLID-S)
- 3 responsibilities mixed together

### Solution
1. Extract AuthService (login, logout, refreshToken)
2. Extract EmailService (sendWelcomeEmail, sendPasswordReset)
3. UserManager keeps only CRUD

### Steps
1. Create AuthService (20 minutes)
2. Migrate authentication methods (30 minutes)
3. Update all references (Serena rename_symbol, 5 minutes)
4. Run tests (10 minutes)
5. Repeat for EmailService (same)

Total: 2 hours
`)

// Step 5: Execute refactoring (using Serena, zero errors)
// ... see 2.7 /ultra-refactor
```

**Benefits**:
- Understanding time: 3 days → 2 hours (36x improvement)
- Token consumption: 150K (would fail) → 5K (success)
- Refactoring risk: High → Zero (Serena semantic understanding)

---

### Case 2: Rename Across 120 Files

**Background**:
- Task: getUserById → fetchUserById
- References: 78, across 23 files

**Traditional method (Grep + Edit)**:

```typescript
// Step 1: Search
Grep("getUserById")
// Returns: 300 matches

// Step 2: Manual filtering (2 hours)
// Exclude:
// - Comments: "// Call getUserById to fetch user"
// - Strings: "API endpoint: /getUserById"
// - Same-named functions in other modules

// Step 3: Edit one by one (1 hour)
// Replace one by one, easy to miss

// Step 4: Test finds bugs (30 minutes)
// Missed: 10 places
// Wrongly changed: 5 places (changed comments and strings)

// Total: 3.5 hours, 30% error rate
```

**Serena method**:

```typescript
// Step 1: Confirm symbol exists
mcp__serena__find_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts"
})

// Step 2: Preview impact (optional)
mcp__serena__find_referencing_symbols({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts"
})
// Returns: 78 references

// Step 3: Execute rename (5 minutes)
mcp__serena__rename_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts",
  new_name: "fetchUserById"
})

// Step 4: Run tests
// All pass ✅

// Total: 5 minutes, 0% error rate
```

**Comparison**:
- Time: 3.5 hours → 5 minutes (42x improvement)
- Error rate: 30% → 0%
- Stress: High → Low

---

### Case 3: Multi-Project Management (3 Parallel Projects)

**Background**:
- Developer maintains 3 client projects simultaneously
- Each project has different coding standards
- Need to switch context quickly

**Solution**:

```typescript
// Morning 9:00 - Client A project
mcp__serena__activate_project("client-a-crm")
mcp__serena__read_memory("coding-conventions")
// See:
// - ESLint: Airbnb
// - Testing: React Testing Library
// - Naming: camelCase

// Start work...
// Write code following Airbnb rules

// Afternoon 2:00 - Client B project
mcp__serena__activate_project("client-b-dashboard")
mcp__serena__read_memory("coding-conventions")
// See:
// - ESLint: Standard
// - Testing: Vitest
// - Naming: snake_case

// Start work...
// Automatically switch to Standard rules

// Evening 6:00 - Open source project
mcp__serena__activate_project("my-open-source-lib")
mcp__serena__read_memory("coding-conventions")
// See:
// - ESLint: Prettier + Custom
// - Testing: Jest
// - Naming: kebab-case

// Record today's work
mcp__serena__write_memory("work-log-2024-11-17", `
## Today's Work

### Client A
- Completed user authentication module
- Fixed 3 bugs
- Test coverage: 85%

### Client B
- Refactored dashboard component
- Optimized query performance (2s → 0.3s)

### Open Source Project
- Released v2.1.0
- Fixed GitHub Issues #123, #124
`)
```

**Benefits**:
- Context switching time: 10 minutes → 30 seconds (20x improvement)
- Rule compliance rate: 70% (often confused) → 100%
- Knowledge retention: Scattered in notes → Centralized in memory

---

## Part 5: FAQ

### Q1: Serena vs Built-in tools, when to use which?

**Decision tree**:
```
1. Need to understand code structure? → Serena
2. Need cross-file symbol modification? → Serena (only choice)
3. Need project knowledge management? → Serena (only choice)
4. File >5000 lines? → Serena
5. Other cases → Built-in tools
```

**Core principle**:
- Text operations → Built-in tools
- Semantic operations → Serena

---

### Q2: name_path can't find symbol?

**Troubleshooting steps**:

```typescript
// 1. Use substring matching
mcp__serena__find_symbol({
  name_path: "User",
  substring_matching: true
})

// 2. Global search (no name_path)
mcp__serena__find_symbol({
  name_path: "",
  relative_path: "src/"
})

// 3. Use search_for_pattern
mcp__serena__search_for_pattern({
  substring_pattern: "getUserById",
  relative_path: "src/"
})
```

---

### Q3: Serena consuming too many tokens?

**Optimization strategies**:

```typescript
// ❌ Wrong: Read everything at once
mcp__serena__find_symbol({
  name_path: "",
  depth: 3,  // Too deep
  include_body: true  // Include code
})

// ✅ Correct: Incremental acquisition
// Step 1: Only see structure
mcp__serena__get_symbols_overview({ relative_path: "..." })

// Step 2: Only see method list
mcp__serena__find_symbol({
  name_path: "UserService",
  depth: 1,
  include_body: false  // Don't include code
})

// Step 3: Only read needed method
mcp__serena__find_symbol({
  name_path: "UserService/login",
  include_body: true
})
```

---

### Q4: How to promote Serena in team?

**Promotion strategy**:

1. **Show ROI**:
   - Rename case: 3.5 hours → 5 minutes
   - Error rate: 30% → 0%

2. **5-minute training**:
   - get_symbols_overview (understand large files)
   - rename_symbol (safe rename)
   - memory system (knowledge management)

3. **Set team conventions**:
   ```typescript
   // During project initialization
   mcp__serena__write_memory("team-guidelines", `
   ## Serena Usage Conventions

   ### Must use Serena
   - Cross-file rename (>5 files)
   - Understand large files (>1000 lines)
   - Record technical decisions

   ### Optional Serena
   - Small file rename (<5 files)
   - Simple search
   `)
   ```

---

## Summary

**Serena's core value**:
1. **Semantic understanding** → Fills capability gap of built-in tools
2. **Zero-error refactoring** → Prerequisite for TDD REFACTOR step
3. **Knowledge accumulation** → Project wisdom inheritance

**Learning path**:
1. 5 minutes: get_symbols_overview, rename_symbol
2. 10 minutes: Workflow integration (7 phases)
3. 20 minutes: Advanced techniques (depth, kind, memory)
4. 30 minutes: Case studies (legacy code, rename, multi-project)

**Key metrics**:
- Code understanding speed: 30 minutes → 5 minutes (6x)
- Refactoring time: 2.5 hours → 5 minutes (30x)
- Refactoring error rate: 30% → 0%
- System completeness: 60% → 100%

**Remember**: Serena is not "optional optimization", but "required infrastructure".
