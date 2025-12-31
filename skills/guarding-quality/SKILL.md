---
name: guarding-quality
description: "Validates code quality across SOLID principles, complexity limits, and test coverage. This skill activates when editing any code files, discussing refactoring, quality improvement, or code review."
---

# Code Quality Guardian (Production Absolutism)

> "There is no test code. There is no demo. There is no MVP.
> Every line is production code. Every component is production-grade."

Ensures production-grade code quality through universal principles — no mock, no degradation, no shortcuts.

**Quality Formula**:
```
Code Quality = Real Implementation × Real Dependencies × Real Tests
If ANY component is fake/mocked/simplified → Quality = 0
```

> **Note**: Language/framework-specific patterns are in `frontend` and `backend` skills.
> This skill focuses on **principles** that apply to ALL code.

## Activation Context

This skill activates when:
- Editing any code files (*.ts, *.js, *.py, *.go, *.vue, *.tsx, etc.)
- Discussing quality, refactoring, or code review
- Running /ultra-test or completing tasks
- Reviewing pull requests

## Resources

| Resource | Purpose |
|----------|---------|
| `scripts/quality_analyzer.py` | Analyze code metrics |
| `references/complete-reference.md` | SOLID principles and detailed examples |

## Quality Analysis

Run the analyzer to evaluate code quality:

```bash
python scripts/quality_analyzer.py <file>
python scripts/quality_analyzer.py src/  # All files
python scripts/quality_analyzer.py --summary  # Summary only
```

---

## Core Principles

### SOLID Principles (Mandatory)

| Principle | Rule |
|-----------|------|
| **S**ingle Responsibility | One reason to change per class/function |
| **O**pen-Closed | Extend via abstraction, don't modify stable code |
| **L**iskov Substitution | Subtypes must honor parent contracts |
| **I**nterface Segregation | Small, focused interfaces (≤5 methods) |
| **D**ependency Inversion | Depend on abstractions, inject dependencies |

### Complementary Principles

| Principle | Rule |
|-----------|------|
| **DRY** | No duplicate code >3 lines |
| **KISS** | Complexity ≤10, nesting ≤3 |
| **YAGNI** | Only implement current requirements |

---

## Quality Thresholds

| Metric | Limit | Action |
|--------|-------|--------|
| Function lines | ≤50 | Split into smaller functions |
| Nesting depth | ≤3 | Extract to helper functions |
| Cyclomatic complexity | ≤10 | Simplify logic, use polymorphism |
| Duplicate lines | ≤3 | Extract to shared function |
| Parameter count | ≤5 | Use object parameters |
| Class lines | ≤500 | Split by responsibility |

---

## Code Smells (Fix Immediately)

| Smell | Fix |
|-------|-----|
| Functions >50 lines | Split by responsibility |
| Nesting >3 levels | Early return, extract functions |
| Magic numbers | Named constants |
| Commented-out code | Delete (use git history) |
| God classes >500 lines | Split into focused classes |
| Long parameter lists | Object parameters |
| Cryptic names | Descriptive naming |

---

## Production Absolutism Violations (Immediate Rejection)

| Violation | Description | Consequence |
|-----------|-------------|-------------|
| **Core Logic Mocking** | Mocking domain/service/state machine | Immediate rejection |
| **Degradation** | Fallback logic, simplified implementations | Immediate rejection |
| **Static Data** | Hardcoded fixtures, inline test data | Immediate rejection |
| **Placeholders** | `TODO`, `FIXME`, `// demo` | Immediate rejection |
| **MVP Mindset** | "Good enough", partial implementations | Immediate rejection |

**Allowed Test Doubles** (with rationale):
- External system mocks (APIs, email, payment gateways)
- Repository storage: testcontainers (preferred) or SQLite (fallback)

---

## Test Coverage Standards

| Scope | Target |
|-------|--------|
| Overall | ≥80% |
| Critical paths | 100% |
| Branch coverage | ≥75% |

### Six Testing Dimensions

| Dimension | Focus |
|-----------|-------|
| **Functional** | Core business logic, happy paths |
| **Boundary** | Edge cases, null/empty, limits |
| **Exception** | Error handling, graceful degradation |
| **Performance** | Response time, memory, N+1 queries |
| **Security** | Input validation, auth, injection |
| **Compatibility** | Cross-platform, responsive |

---

## Philosophy Priority

```
Production Absolutism > "Good Enough"
User Value > Technical Showoff
Code Quality > Development Speed
Systems Thinking > Fragmented Execution
Test-First > Ship-Then-Test
Real Implementation > Mock/Simulation
```

---

## Output Format

Provide guidance in Chinese at runtime:

```
代码质量检查
========================

检查结果：
- {具体发现}
- {违反的原则}

改进建议：
- {具体修改方案}

参考：references/complete-reference.md {section}
========================
```

**Tone:** Constructive, specific, actionable
