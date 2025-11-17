# Serena MCP Integration Complete Guide

**Ultra Builder Pro 4.1** - From beginner to expert with Serena semantic layer infrastructure

---

## Overview

**What is Serena**: Ultra Builder Pro 4.1's semantic understanding layer, providing symbol-level code operations that built-in tools cannot achieve.

**Why needed**:
- System completeness: Without Serena = 60%, With Serena = 100%
- TDD complete cycle: REFACTOR step depends on Serena
- SOLID principles: Safe refactoring is prerequisite

**Core capability**:
```
Built-in tools = Text layer (string matching)
Serena         = Semantic layer (symbol understanding) ← Dimensional leap
```

---

## Part 1: Quick Start (5 minutes)

### 1.1 Installation

```bash
# Install Serena MCP
uvx --from git+https://github.com/oraios/serena serena start-mcp-server \
  --context ide-assistant --enable-web-dashboard false

# Verify installation
claude mcp list
# Should see: serena - ✓ Connected
```

### 1.2 First Serena Command

**Scenario: Understand a 1000-line file**

```typescript
// ❌ Traditional approach
Read("src/services/userService.ts")
// Problem: 1000 lines of code, information overload

// ✅ Serena approach
mcp__serena__get_symbols_overview({
  relative_path: "src/services/userService.ts"
})

// Returns (simplified structure):
// UserService (Class, line 10)
//   - constructor (Method, line 15)
//   - login (Method, line 45)
//   - register (Method, line 120)
//   - updateProfile (Method, line 250)
//   - deleteAccount (Method, line 400)
```

**Benefits**:
- Token consumption: 4K tokens → ~500 tokens (8x efficiency)
- Cognitive load: 1000 lines of code → 5 method names
- Understanding time: 10 minutes → 1 minute

### 1.3 Understanding name_path Concept

**name_path is Serena's core**: Path for precisely locating symbols.

**Format**:
```
"/TopLevel/Nested/Symbol"      # Absolute path (from file top)
"TopLevel/Nested/Symbol"       # Relative path (match any level)
"Symbol"                       # Symbol name (global search)
```

**Examples**:
```typescript
// File structure:
// class UserService {
//   class Validator {  // nested class
//     validate() { ... }
//   }
//   login() { ... }
// }

// Method 1: Absolute path
mcp__serena__find_symbol({
  name_path: "/UserService/Validator/validate",
  relative_path: "src/services/userService.ts"
})
// Only matches: UserService → Validator → validate

// Method 2: Relative path
mcp__serena__find_symbol({
  name_path: "Validator/validate",
  relative_path: "src/services/userService.ts"
})
// Matches: Validator → validate at any location

// Method 3: Global search
mcp__serena__find_symbol({
  name_path: "validate",
  substring_matching: true,
  relative_path: "src/"
})
// Matches: All symbols containing "validate"
```

---

