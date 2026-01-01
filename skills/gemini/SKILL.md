---
name: gemini
description: Use when the user asks to run Gemini CLI (gemini -p, gemini command) or references Google Gemini for code analysis, refactoring, or AI-assisted development
allowed-tools: Bash, Read, Glob, Grep
---

# Gemini Skill Guide

## Running a Task

### Defaults
- **Model**: `gemini-2.5-flash`
- **Approval mode**: `suggest` (requires confirmation)
- **Output format**: `text`

### Invocation Modes

**Mode 1: Template invocation** (from commands like `/ultra-dev`, `/ultra-test`)
- Use template config directly, NO user interaction
- Templates define model/approval/prompt

**Mode 2: Regular invocation** (user requests gemini directly)
1. Display current defaults
2. Use `AskUserQuestion`:
   - Option A: "使用默认配置" (Recommended) - gemini-2.5-flash, suggest mode
   - Option B: "自定义配置" - then ask model/approval mode separately
3. Execute with chosen config

### Configuration Options

**Models**:
- `gemini-2.5-flash` (default, fast and capable)
- `gemini-2.5-pro` (more powerful, 1M context)
- `gemini-3-flash` (latest, experimental)

**Approval modes**:
- `suggest` (default) - requires user confirmation for actions
- `yolo` (`-y`) - auto-approve all actions (use with caution)

**Context options**:
- `@./path` - inject file content into prompt
- `--include-directories dir1 dir2` - add directories to context
- `-a, --all-files` - include all files in context

### Command template
```bash
gemini \
  -m gemini-2.5-flash \
  -p "prompt here"
```

### With file context
```bash
gemini -p "Review this code @./src/main.ts"
```

### With auto-approve (YOLO mode)
```bash
gemini -y -p "Fix the bug in this file @./buggy.ts"
```

### Execution rules
- Run the command and show complete output to user
- For JSON output: add `--output-format json`
- After completion: inform user they can continue in interactive mode with `gemini`

## Quick Reference

| Use case | Command |
|----------|---------|
| Analysis | `gemini -p "analyze this code @./file.ts"` |
| With edits | `gemini -y -p "fix the bug @./file.ts"` |
| Directory context | `gemini --include-directories src -p "summarize"` |
| JSON output | `gemini -p "query" --output-format json` |
| Interactive | `gemini` (starts REPL) |

## Following Up

- After every `gemini` command, use `AskUserQuestion` to confirm next steps.
- For continued work, user can start interactive mode with `gemini`.

## Error Handling

- If `gemini` exits non-zero, show the error and ask user for direction.
- `-y` (yolo mode) requires explicit confirmation in Mode 2 custom config flow.
- If output shows warnings, summarize and ask how to proceed.

---

## Review Templates

Use these predefined templates when commands reference `gemini skill with template: <name>`.

### research-review

| Config | Value |
|--------|-------|
| Model | gemini-2.5-pro |
| Approval | suggest |
| Context | include research outputs |

**Prompt**:
```
Review this technical research output against these rules:

[Evidence-First]
- Every claim must have verifiable source (official docs, benchmarks)
- Unverified claims must be marked as "Speculation"
- Priority: 1) Official docs 2) Community practices 3) Inference

[Honesty & Challenge]
- Detect risk underestimation or wishful thinking
- Point out logical gaps explicitly
- No overly optimistic assumptions without evidence

[Architecture Decisions]
- Critical state requirements addressed?
- Migration/rollback plan for breaking changes?
- Persistence/recovery/observability considered?

[Completeness]
- Missing risks or edge cases not considered
- Contradictions between sections

Provide specific issues with file:line references.
Label each finding: Fact | Inference | Speculation
If no critical issues found, respond with "PASS: No blocking issues".
```

---

### code-review

| Config | Value |
|--------|-------|
| Model | gemini-2.5-pro |
| Approval | suggest |
| Context | include changed files |

**Prompt**:
```
Review this code diff against these rules:

[Code Quality]
- No TODO/FIXME/placeholder in code
- Modular structure, avoid deep nesting (max 3 levels)
- No hardcoded secrets or credentials

[Security]
- No injection vulnerabilities (SQL, XSS, CSRF, command injection)
- No auth bypass or secrets exposure
- Input validation at system boundaries

[Architecture]
- Critical state (funds/permissions/external API) must be persistable/recoverable
- No in-memory-only storage for critical data
- Breaking API changes require migration plan

[Logic]
- No race conditions or incorrect state handling
- No N+1 queries or memory leaks
- Spec compliance - implementation matches acceptance criteria
- Edge cases handled (boundary values, null, empty, error paths)

[Testing in Code]
- No mocks on core logic (domain/service/state paths must use real deps)
- Test files included should follow Core Logic NO MOCKING rule

Provide specific issues with file:line references and severity (Critical/High/Medium/Low).
If no critical/high issues found, respond with "PASS: No blocking issues".
```

---

### test-review

| Config | Value |
|--------|-------|
| Model | gemini-2.5-flash |
| Approval | suggest |
| Context | include test files |

**Prompt**:
```
Review this test suite against these rules:

[Core Logic Testing - NO MOCKING ALLOWED]
Core Logic = Domain/service/state machine/funds-permission paths
- These paths MUST use real implementations, not mocks
- Repository interfaces: prefer testcontainers with production DB
- Fallback: SQLite/in-memory only when testcontainers unavailable

[External Systems - Test Doubles ALLOWED]
- External APIs, third-party services → testcontainers/sandbox/stub OK
- Must document rationale for each test double

[Coverage]
- Missing edge cases (null, empty, boundary values, error paths)
- Untested critical paths (auth flows, payment, data mutations, deletions)

[Anti-Patterns]
- Flaky tests (time-dependent, order-dependent)
- Tautology assertions (expect(true).toBe(true))
- Empty test bodies
- False confidence - tests that pass but don't verify behavior

[Security Testing]
- Auth/permission tests exist for protected endpoints
- Input validation tests for injection vectors
- Sensitive data handling tests (no plaintext secrets in logs/responses)

Provide specific issues with file:line references.
If no critical issues found, respond with "PASS: No blocking issues".
```
