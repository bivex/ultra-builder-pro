---
name: codex-reviewer
description: "Provides independent code review after Claude Code implementations. This skill acts as a second pair of eyes with 100-point scoring across correctness, security, performance, and maintainability dimensions."
---

<CRITICAL_REQUIREMENT>
## ⚠️ MANDATORY: Execute Codex CLI

You MUST execute `codex exec` command to perform the code review. This skill is NOT complete without actual Codex CLI execution.

```bash
# Required execution (JSONL event stream):
codex exec --json "Review {file_path} for bugs, security, performance. Output JSON: {score, issues, verdict}" | jq

# Or without jq parsing:
codex exec "Review {file_path} for correctness, security, performance, maintainability. Score 0-100."

# Or use the script:
~/.claude/skills/codex-reviewer/scripts/review.sh {file_path}
```

**DO NOT** just read this skill and provide manual review. **YOU MUST** run Codex CLI.
</CRITICAL_REQUIREMENT>

# Codex Code Reviewer (Production Absolutism)

> "There is no test code. There is no demo. There is no MVP.
> Every line is production code. Every review enforces production standards."

## Purpose

Provide **independent, critical code review** after Claude Code implementations. Act as a second pair of eyes that catches what the primary developer missed.

**Core Principle**: Be a demanding reviewer, not a rubber stamp. Find real issues. Enforce Production Absolutism.

**Quality Formula**:
```
Code Quality = Real Implementation × Real Dependencies × Real Tests
If ANY component is fake/mocked/simulated → Quality = 0 → BLOCK
```

---

## Resources

| Resource | Purpose |
|----------|---------|
| `scripts/review.sh` | Execute codex review via CLI |

### Quick Start

```bash
# Review a single file
./scripts/review.sh path/to/file.ts

# Enable auto-review (runs after every Edit/Write)
export CODEX_AUTO_REVIEW=true
```

---

## Trigger Conditions

1. **Command binding**: Auto-triggers with `/ultra-dev`
2. **Tool trigger**: After `Edit` or `Write` on code files
3. **Manual**: User explicitly requests Codex review

---

## Review Dimensions (100-Point Scale)

### 1. Correctness (40%)

| Check | Description |
|-------|-------------|
| Logic errors | Conditions, loops, state transitions |
| Boundary conditions | null/undefined, empty arrays, edge values |
| Type safety | Type assertions, any abuse, narrowing |
| Error handling | try-catch completeness, error propagation |

### 2. Security (30%)

| Check | Description |
|-------|-------------|
| Input validation | User input, API parameter validation |
| Injection risks | SQL/XSS/command injection |
| Sensitive data | Key exposure, log leakage |
| Auth/authz | Permission checks, session management |

### 3. Performance (20%)

| Check | Description |
|-------|-------------|
| Time complexity | O(n²) warnings, recursion depth |
| Memory usage | Large object copies, memory leaks |
| Redundant computation | Duplicate traversals, unnecessary transforms |
| Async efficiency | Promise.all optimization, serial to parallel |

### 4. Maintainability (10%)

| Check | Description |
|-------|-------------|
| Code clarity | Function length, nesting depth |
| Naming conventions | Meaningful names, consistency |
| Modularity | Single responsibility, dependency direction |

---

## Execution Flow

```
Step 1: Get list of changed files
        ↓
Step 2: Call Codex CLI for review
        ↓
Step 3: Parse review results
        ↓
Step 4: Generate structured report
        ↓
Step 5: Return feedback to Claude Code
```

---

## Codex Call Template

```bash
codex -q --json <<EOF
You are a strict code reviewer. Review these code changes:

File: {file_path}
Changes:
\`\`\`
{diff_content}
\`\`\`

Review across these dimensions:

**CRITICAL (Immediate BLOCK if violated)**:
- Production Absolutism: NO mock/simulation/degradation/placeholder/TODO
- If ANY mock detected → Score = 0 → BLOCK

1. **Correctness** (40 points)
   - Logic errors
   - Boundary conditions
   - Error handling

2. **Security** (30 points)
   - Input validation
   - Injection risks
   - Sensitive data exposure

3. **Performance** (20 points)
   - Time/space complexity
   - Redundant computation

4. **Maintainability** (10 points)
   - Code clarity
   - Naming conventions

Output format:
{
  "score": {
    "correctness": X,
    "security": X,
    "performance": X,
    "maintainability": X,
    "total": X
  },
  "critical_issues": [
    {"file": "path", "line": N, "issue": "description", "fix": "suggestion"}
  ],
  "suggestions": [
    {"file": "path", "line": N, "issue": "description", "fix": "suggestion"}
  ],
  "verdict": "PASS|NEEDS_FIX|BLOCK"
}
EOF
```

---

## Output Format (Runtime: Chinese)

```markdown
## Codex Code Review Report

**Review Time**: {timestamp}
**Files Reviewed**: {file_list}

### Scores

| Dimension | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Correctness | X/100 | 40% | X |
| Security | X/100 | 30% | X |
| Performance | X/100 | 20% | X |
| Maintainability | X/100 | 10% | X |
| **Total** | - | - | **X/100** |

### Critical Issues (Must Fix)

- [ ] `{file}:{line}` - {issue description}
  - **Reason**: {why it's a problem}
  - **Fix**: {specific fix code}

### Suggestions

- [ ] `{file}:{line}` - {suggestion description}
  - **Improvement**: {improvement approach}

### Verdict

**{PASS | NEEDS_FIX | BLOCK}**

- PASS: Total >= 80, no critical issues
- NEEDS_FIX: Total 60-79, or 1-2 critical issues
- BLOCK: Total < 60, or 3+ critical issues
```

---

## Collaboration with Claude Code

### Normal Flow

```
Claude Code develops → Codex reviews → Claude Code fixes → commit
```

### Stuck Detection

When Claude Code fails to fix the same issue 3 consecutive times:

```
Claude Code develops → Codex reviews → Claude Code fails fix (x3)
                                              ↓
                                        Role Swap
                                              ↓
                          Codex fixes → Claude Code reviews → commit
```

---

## Configuration

```json
{
  "codex-reviewer": {
    "minScoreToPass": 80,
    "blockOnCriticalCount": 3,
    "maxRetries": 3,
    "roleSwapEnabled": true,
    "reviewFileTypes": [".ts", ".tsx", ".js", ".jsx", ".py", ".go", ".rs"]
  }
}
```

---

## Quality Standards (Production Absolutism)

The reviewer enforces these production-grade requirements — violations result in immediate BLOCK:

### Absolute Prohibitions (Immediate BLOCK)

| Violation | Detection | Verdict |
|-----------|-----------|---------|
| **Mock/Simulation** | `jest.mock()`, `vi.mock()`, `jest.fn()` | BLOCK |
| **Degradation** | Fallback logic, simplified implementations | BLOCK |
| **Static Data** | Hardcoded fixtures, inline test data | BLOCK |
| **Placeholders** | `TODO`, `FIXME`, `// demo`, `// placeholder` | BLOCK |
| **MVP Mindset** | "Good enough", partial implementations | BLOCK |

### Required Standards

1. **Real Implementation**: Code handles actual business scenarios with real dependencies
2. **No Mocking**: All tests use real in-memory implementations (SQLite, testcontainers)
3. **Complete Error Handling**: All failure paths handled with recovery
4. **Security by Default**: Input validation, output encoding, secure defaults
5. **Observable**: Structured logging, metrics exposure
6. **Production-Ready**: Code deployable unchanged to production
