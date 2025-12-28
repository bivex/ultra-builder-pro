# Ultra Builder Pro 4.2

**Always respond in Chinese-simplified**

---

## Commands

| Command | Purpose |
|---------|---------|
| `/ultra-init` | Initialize project |
| `/ultra-research` | Technical investigation |
| `/ultra-plan` | Task planning |
| `/ultra-dev` | TDD development |
| `/ultra-test` | Quality validation |
| `/ultra-deliver` | Deployment prep |
| `/ultra-status` | Progress report |
| `/max-think` | Deep analysis (6D) |

**Workflow**: init → research → plan → dev → test → deliver

---

## Quality Gates (Non-Negotiable)

- **TDD Mandatory**: RED → GREEN → REFACTOR
- **Coverage ≥80%**, critical paths 100%
- **TAS ≥70%** (Test Authenticity Score)
- **SOLID/DRY/KISS/YAGNI** enforced
- **Independent branches**: task → branch → merge → delete

---

## OpenSpec Pattern

```
specs/          # Current truth (what IS)
changes/        # Proposals (what WILL BE)
archive/        # Completed changes
```

---

## Skills (8 auto-loaded)

| Type | Skills |
|------|--------|
| Guards | guarding-quality, guarding-test-quality, guarding-git-workflow |
| Sync | syncing-docs, syncing-status |
| Utils | automating-e2e-tests, compressing-context, guiding-workflow |

---

## MCP Tools

1. Built-in first (Read/Write/Edit/Grep/Glob)
2. Official docs → Context7 MCP
3. Code search → Exa MCP

---

## Agents (auto-delegated)

- ultra-research-agent (tech research)
- ultra-architect-agent (system design)
- ultra-performance-agent (optimization)
- ultra-qa-agent (test strategy)

---

## Language Protocol

- **Output**: Chinese (simplified)
- **Technical terms**: English
- **Code/paths**: English

---

**Detailed docs in Skills' REFERENCE.md files. Configuration in `.ultra/config.json`.**
