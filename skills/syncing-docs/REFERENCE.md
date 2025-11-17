# Documentation Guardian - Complete Reference

Comprehensive guide for documentation synchronization and knowledge management.

---

## Documentation Types

### 1. Product Requirements (PRD.md)

**Location**: `.ultra/docs/prd.md`

**When to Update**:
- After research reveals new requirements
- User provides new feature requests
- Scope changes during development

**Template**:
```markdown
# Product Requirements Document

## Overview
[Product vision and goals]

## Features
### Feature 1: [Name]
- **Priority**: P0/P1/P2
- **User Story**: As a [role], I want [goal] so that [benefit]
- **Acceptance Criteria**:
  - [ ] Criterion 1
  - [ ] Criterion 2

## Non-Functional Requirements
- Performance: [Response time, throughput]
- Security: [Authentication, authorization, encryption]
- Scalability: [User capacity, data volume]
```

---

### 2. Technical Design (tech.md)

**Location**: `.ultra/docs/tech.md`

**When to Update**:
- After research affects technology choices
- Architecture changes
- New dependencies added

**Template**:
```markdown
# Technical Design Document

## Architecture
[System architecture diagram and description]

## Technology Stack
- **Frontend**: React + TypeScript + Vite
- **Backend**: Node.js + Express + PostgreSQL
- **Infrastructure**: AWS + Docker + GitHub Actions

## Data Models
[Database schema, entity relationships]

## API Design
[Endpoint specifications, request/response formats]

## Security Considerations
[Authentication, authorization, data protection]
```

---

### 3. Architecture Decision Records (ADR)

**Location**: `.ultra/docs/decisions/`

**When to Create**:
- Major technology choices (database, framework)
- Significant architecture changes
- Trade-off decisions with long-term impact

**Template** (`.ultra/docs/decisions/001-use-postgresql.md`):
```markdown
# ADR 001: Use PostgreSQL as Primary Database

## Status
Accepted

## Context
Need to choose a database for user data and transactions.
Requirements: ACID compliance, complex queries, scalability.

## Decision
Use PostgreSQL instead of MongoDB or MySQL.

## Consequences

### Positive
- ACID compliance ensures data integrity
- Rich SQL query capabilities
- Strong community and ecosystem
- Excellent performance for complex joins

### Negative
- Requires schema migrations
- More complex setup than NoSQL
- Vertical scaling limitations (can be mitigated with replication)

## Alternatives Considered
- MongoDB: Flexible schema, but weak consistency guarantees
- MySQL: Simpler, but less feature-rich than PostgreSQL
```

---

### 4. README.md

**When to Update**:
- After feature completion
- Installation/setup changes
- New dependencies or configuration

**Sections to Maintain**:
```markdown
# Project Name

## Installation
[Setup instructions]

## Usage
[Basic usage examples]

## API Reference
[Link to detailed API docs]

## Development
[How to run tests, build, deploy]

## Contributing
[Guidelines for contributors]
```

---

## Post-Research Workflow

### After /ultra-research Completion

**Checklist**:
1. **Research introduced new requirements?**
   - ✅ Update `.ultra/docs/prd.md`
   - Add features to requirements list
   - Update acceptance criteria

2. **Research affected technology choices?**
   - ✅ Update `.ultra/docs/tech.md`
   - Document chosen technologies
   - Explain rationale

3. **Major technical decision made?**
   - ✅ Create ADR in `.ultra/docs/decisions/`
   - Format: `NNN-decision-title.md`
   - Include context, decision, consequences

4. **Existing documentation outdated?**
   - ✅ Update README.md if installation changed
   - ✅ Update API documentation if endpoints changed

---

## Auto-Detection Signals

### Outdated Documentation Indicators

**README.md**:
```bash
# Check if dependencies changed
git diff package.json
git diff requirements.txt

# If yes → Update README.md installation section
```

**API Documentation**:
```bash
# Check if API endpoints changed
git diff src/routes/*.ts
git diff src/api/*.py

# If yes → Update API documentation
```

**Architecture**:
```bash
# Check if major files added/removed
git diff --name-status | grep -E "^(A|D)" | grep -v test

# If significant → Update ARCHITECTURE.md or create ADR
```

---

## Tech Debt Tracking

**Location**: `.ultra/docs/tech-debt.md`

**Template**:
```markdown
# Technical Debt

## High Priority
1. **Database query optimization** (Est: 2 days)
   - Impact: Performance degradation at scale
   - Current: N+1 query problem in user endpoint
   - Solution: Add eager loading

## Medium Priority
2. **Extract validation logic** (Est: 1 day)
   - Impact: Code maintainability
   - Current: Validation scattered across controllers
   - Solution: Centralized validator service

## Low Priority
3. **Upgrade React to v19** (Est: 0.5 days)
   - Impact: Security + performance
   - Current: React v18
   - Solution: Follow migration guide
```

---

## Lessons Learned

**Location**: `.ultra/docs/lessons-learned.md`

**Template**:
```markdown
# Lessons Learned

## Feature: User Authentication (2025-01)

### What Went Well
- JWT implementation was straightforward
- Refresh token rotation prevented security issues
- Tests caught edge cases early

### What Could Be Improved
- Should have designed password reset flow upfront
- Email verification dependency caused delays
- Better error messages needed for failed logins

### Key Takeaways
- Design complete authentication flow before coding
- Plan third-party integrations early
- Invest in clear error messages from the start
```

---

## Documentation Maintenance Schedule

### After Each Phase

| Phase | Documentation Updates |
|-------|---------------------|
| **/ultra-research** | PRD.md, tech.md, ADRs |
| **/ultra-plan** | tasks.json comments |
| **/ultra-dev** | Code comments, inline docs |
| **/ultra-test** | Test documentation |
| **/ultra-deliver** | README.md, CHANGELOG.md, API docs |

---

## Tools and Automation

### Generate API Documentation

**TypeScript**:
```bash
# Using TypeDoc
npx typedoc src/index.ts --out docs/api
```

**Python**:
```bash
# Using Sphinx
sphinx-apidoc -o docs/ src/
sphinx-build -b html docs/ docs/_build
```

### Generate CHANGELOG

```bash
# Using conventional-changelog
npx conventional-changelog -p angular -i CHANGELOG.md -s
```

---

**Complete Documentation Standards**: `~/.claude/guidelines/quality-standards.md`


---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
