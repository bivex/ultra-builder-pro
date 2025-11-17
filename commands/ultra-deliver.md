---
description: Delivery optimization (performance + security + documentation)
allowed-tools: TodoWrite, Task, Read, Write, Edit, Bash, Grep, Glob
---

# /ultra-deliver

Prepare for delivery with performance optimization, security audit, and documentation updates.

## Pre-Execution Checks

Before starting delivery preparation, verify:
- Check task completion in `.ultra/tasks/tasks.json`
  - If incomplete tasks: Ask whether to continue delivery prep
- Verify code quality: Run `git status` for uncommitted changes
- Check test suite status: Did all tests pass in last run?
- Assess documentation state: Is README.md, CHANGELOG.md up to date?
- Determine release type: Patch, minor, or major?

## Workflow

### 1. Performance Optimization
Delegate to performance agent:
```
Task(subagent_type="ultra-performance-agent",
     prompt="Analyze and optimize: [app/feature]. Focus on Core Web Vitals (LCP/INP/CLS) and bottlenecks.")
```

**Core Web Vitals Measurement**:
- Measured via Lighthouse CLI (industry standard, Google official)
- Authoritative scores for LCP, INP (via TBT), CLS
- No browser automation needed - direct measurement

### 2. Security Audit
```bash
npm audit
# Review results, apply fixes for high/critical issues
```

### 3. Documentation Auto-Generation (Serena MCP)

**Purpose**: Automatically generate documentation from project knowledge and code structure.

#### 3.1 Auto-Generate CHANGELOG from Memory System

**Traditional approach**:
- Manually review git commits
- Manually categorize changes (features, fixes, breaking changes)
- Manually write release notes
- Time: 30-60 minutes
- Risk: Missing important changes, inconsistent format

**Serena Solution**:
```typescript
// Step 1: Read all memories from recent-changes
mcp__serena__read_memory("recent-changes")
// Returns: Structured log of all development changes

// Step 2: Parse and categorize automatically
// Memory format (from /ultra-dev workflow):
/*
## 2024-11-17
### New Features
- JWT authentication with RS256 (Task #5)
- Payment integration: Stripe + PayPal (Task #8)

### Bug Fixes
- Fixed memory leak in data processing (Task #12)
- Resolved race condition in auth (Task #15)

### Technical Decisions
- **Chose Stripe over PayPal**: Lower fees (2.9% vs 3.4%)
- **Chose JWT over sessions**: Stateless, better for scaling
*/

// Step 3: Auto-generate CHANGELOG.md
const changelog = generateChangelog({
  version: "1.2.0",
  date: "2024-11-17",
  memory: recentChanges,
  format: "keep-a-changelog" // Standard format
})

// Output to CHANGELOG.md
```

**Generated CHANGELOG.md Example**:
```markdown
# Changelog

## [1.2.0] - 2024-11-17

### Added
- JWT authentication with RS256 algorithm (#5)
- Payment integration supporting Stripe and PayPal (#8)
- User profile management (#10)

### Fixed
- Memory leak in data processing pipeline (#12)
- Race condition in authentication flow (#15)
- Null pointer exception in email service (#18)

### Changed
- Migrated from sessions to JWT for better scalability
- Switched payment provider from PayPal to Stripe (cost optimization)

### Technical Details
- **Authentication**: JWT RS256, 7-day expiry, refresh tokens
- **Payment**: Stripe API v2023-10-16, webhook validation
- **Performance**: 35% reduction in memory usage after leak fix
```

---

#### 3.2 Generate ADRs (Architecture Decision Records)

**Purpose**: Document technical decisions for future reference.

**Serena Solution**:
```typescript
// Step 1: Read decision logs from memory
mcp__serena__read_memory("tech-decisions")
// or
mcp__serena__read_memory("architecture-decisions")

// Step 2: For each decision, generate ADR
const adr = generateADR({
  number: 5,
  title: "Use JWT instead of sessions for authentication",
  context: "Building stateless API for microservices architecture",
  decision: "Implement JWT with RS256 algorithm",
  rationale: [
    "Stateless: No server-side session storage needed",
    "Scalable: Works across multiple servers without session affinity",
    "Standard: Well-supported by libraries and tools"
  ],
  consequences: {
    positive: [
      "Easy horizontal scaling",
      "No session store dependency (Redis, etc.)",
      "Better for microservices"
    ],
    negative: [
      "Can't revoke tokens before expiry (need short expiry + refresh)",
      "Slightly larger payload in each request"
    ]
  },
  alternatives: [
    {
      option: "Session-based auth",
      rejected: "Requires session store, harder to scale"
    },
    {
      option: "OAuth 2.0",
      rejected: "Overkill for internal API, adds complexity"
    }
  ]
})

// Output to .ultra/docs/decisions/0005-use-jwt-for-auth.md
```

**Generated ADR Example**:
```markdown
# 5. Use JWT instead of sessions for authentication

Date: 2024-11-17
Status: Accepted

## Context
Building stateless REST API for microservices architecture. Need authentication that works across multiple servers without shared session state.

## Decision
Implement JWT (JSON Web Tokens) with RS256 algorithm for authentication.

## Rationale
- **Stateless**: No server-side session storage needed
- **Scalable**: Works across multiple servers without session affinity
- **Standard**: Well-supported by libraries (jsonwebtoken, passport-jwt)

## Consequences

### Positive
- Easy horizontal scaling (no session store bottleneck)
- No dependency on Redis or other session stores
- Better for microservices (each service can validate independently)

### Negative
- Can't revoke tokens before expiry (mitigation: short expiry + refresh tokens)
- Slightly larger payload in each request (~200 bytes)

## Alternatives Considered

### Option 1: Session-based authentication
- **Rejected**: Requires session store (Redis), harder to scale horizontally

### Option 2: OAuth 2.0
- **Rejected**: Overkill for internal API, adds unnecessary complexity

## References
- Implementation: `src/auth/jwt.service.ts`
- Tests: `src/auth/__tests__/jwt.service.test.ts`
```

---

#### 3.3 Technical Debt Tracking

**Purpose**: Auto-generate technical debt report from code analysis.

**Serena Solution**:
```typescript
// Step 1: Search for TODO/FIXME comments
mcp__serena__search_for_pattern({
  substring_pattern: "// TODO:|// FIXME:|// HACK:",
  relative_path: "src/"
})
// Returns: All technical debt markers with file:line

// Step 2: Read tech-debt memory
mcp__serena__read_memory("tech-debt")
// Returns: Manually logged technical debt items

// Step 3: Analyze SOLID violations (from guarding-code-quality)
mcp__serena__search_for_pattern({
  substring_pattern: "class.*{[\\s\\S]{2000,}}", // Large classes (>2000 chars)
  relative_path: "src/"
})

// Step 4: Generate consolidated report
const techDebtReport = {
  critical: [
    { file: "src/auth/jwt.ts:45", issue: "FIXME: Token refresh race condition" },
    { file: "src/payment/stripe.ts:120", issue: "TODO: Add retry logic for failed payments" }
  ],
  moderate: [
    { file: "src/services/UserService.ts", issue: "Class >500 lines, violates SRP" }
  ],
  low: [
    { file: "src/utils/format.ts:30", issue: "TODO: Add input validation" }
  ]
}

// Output to .ultra/docs/technical-debt.md
```

**Generated Technical Debt Report**:
```markdown
# Technical Debt Report

Generated: 2024-11-17

## 🔴 Critical (Must Fix Before Release)
1. **Token refresh race condition** (`src/auth/jwt.ts:45`)
   - Risk: Users may get logged out unexpectedly
   - Priority: P0
   - Estimate: 2 hours

2. **No retry logic for failed payments** (`src/payment/stripe.ts:120`)
   - Risk: Lost revenue from transient failures
   - Priority: P0
   - Estimate: 3 hours

## 🟡 Moderate (Fix in Next Sprint)
3. **UserService violates SRP** (`src/services/UserService.ts`)
   - Issue: 580 lines, handles auth + email + reporting
   - Refactoring: Extract EmailService, ReportService
   - Priority: P1
   - Estimate: 4 hours

## 🟢 Low (Backlog)
4. **Missing input validation** (`src/utils/format.ts:30`)
   - Risk: Potential XSS if user input not sanitized
   - Priority: P2
   - Estimate: 1 hour

## Summary
- Total items: 4
- Critical: 2 (5 hours estimated)
- Moderate: 1 (4 hours estimated)
- Low: 1 (1 hour estimated)
```

---

#### 3.4 Auto-Update API Documentation

**Purpose**: Generate API docs from code structure.

**Serena Solution**:
```typescript
// Step 1: Find all controller/route files
mcp__serena__search_for_pattern({
  substring_pattern: "@Controller|@Route|app\\.get\\(|app\\.post\\(",
  relative_path: "src/"
})

// Step 2: For each endpoint, extract details
mcp__serena__find_symbol({
  name_path: "UserController",
  depth: 2, // Get all methods and their parameters
  include_body: true
})

// Step 3: Parse JSDoc comments for descriptions
// Step 4: Generate OpenAPI/Swagger spec or Markdown docs
const apiDoc = generateAPIDocs({
  controllers: [...],
  format: "openapi-3.0" // or "markdown"
})

// Output to .ultra/docs/api-reference.md
```

**Generated API Documentation Example**:
```markdown
# API Reference

## Authentication

### POST /auth/login
Login with email and password.

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response** (200 OK):
```json
{
  "token": "eyJhbGciOiJSUzI1NiIs...",
  "expiresIn": 604800,
  "user": {
    "id": "123",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

**Errors**:
- `401 Unauthorized`: Invalid credentials
- `400 Bad Request`: Missing required fields

**Implementation**: `src/auth/auth.controller.ts:45`
```

---

#### 3.5 Workflow Integration

**Automated flow in /ultra-deliver**:
1. **CHANGELOG**:
   - `read_memory("recent-changes")`
   - Parse and categorize (Added/Fixed/Changed)
   - Generate CHANGELOG.md entry

2. **ADRs**:
   - `read_memory("tech-decisions")`
   - For each decision → Generate ADR file
   - Save to `.ultra/docs/decisions/NNNN-title.md`

3. **Technical Debt**:
   - `search_for_pattern("TODO:|FIXME:|HACK:")`
   - `read_memory("tech-debt")`
   - Generate consolidated report
   - Save to `.ultra/docs/technical-debt.md`

4. **API Docs**:
   - `search_for_pattern` for controllers/routes
   - `find_symbol` for method signatures
   - Generate OpenAPI spec or Markdown
   - Save to `.ultra/docs/api-reference.md`

**Time Savings**:
- Manual documentation: 1-2 hours
- Serena auto-generation: 5-10 minutes
- **Result: 10x faster**

---

### 4. Manual Documentation Review

After auto-generation, review and adjust:
- Verify CHANGELOG accuracy (auto-generated from memory)
- Ensure ADRs capture all important decisions
- Validate API docs match current implementation
- Update README.md with high-level changes

### 5. Final Quality Check
```bash
# Run full test suite
npm test

# Build production
npm run build

# Verify build output
```

### 6. Prepare Release
```bash
# Update version
npm version [patch|minor|major]

# Generate release notes
# Tag and commit
```

## Deliverables

- ✅ Performance optimized (Core Web Vitals pass)
- ✅ No security vulnerabilities
- ✅ Documentation up-to-date
- ✅ All tests pass
- ✅ Production build successful

## Integration

- **Skills**: Documentation Guardian (auto-activates)
- **Agents**: ultra-performance-agent for optimization
- **Next**: Deploy to production or create release PR

---

## Post-Execution Logging (Observability)

After this command completes, write a JSON log entry to `.ultra/logs/session-<timestamp>.json` containing:
- `command`: "ultra-deliver"
- `estimatedTokens`: approximate tokens consumed (context + tools)
- `filesReadTopN`: list of files read (top N by size)
- `triggeredSkills`: array of skills triggered during execution
- `notes`: performance/security/doc updates performed

User-facing summaries should be presented in Chinese at runtime; keep file formats English-only.

Example:
```bash
COMMAND="ultra-deliver" \
ESTIMATED_TOKENS=3800 \
FILES_READ_TOPN='["README.md","CHANGELOG.md"]' \
TRIGGERED_SKILLS='["documentation-guardian","playwright-automation"]' \
NOTES='{"perf": "optimized images and code splitting", "docs": "updated README"}' \
bash .claude/scripts/log-observer.sh
```

Config overrides (if needed):
```bash
node .claude/scripts/read-config.js vitals.targets
```

## Output Format

**Standard output structure**: See `@config/ultra-command-output-template.md` for the complete 6-section format.

**Command icon**: 🚀

**Example output**: See template Section 7.6 for ultra-deliver specific example.
