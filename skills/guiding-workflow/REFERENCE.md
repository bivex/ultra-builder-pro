# Workflow Guide - Complete Reference

**Ultra Builder Pro 4.1** - Intelligent next-step suggestions based on project state.

---

## Overview

This skill analyzes filesystem signals and project scenario to suggest the next logical command in the development workflow.

**Core mission**: Proactive workflow guidance without user asking "what's next?".

---

## Quick Reference

### Filesystem Signals
- `.ultra/tasks/tasks.json` exists → Check task status
- `specs/product.md` exists but incomplete → Suggest `/ultra-research`
- `specs/` complete + no tasks.json → Suggest `/ultra-plan`
- Tasks pending + tests passing → Suggest `/ultra-dev`
- All tasks complete → Suggest `/ultra-deliver`

### Project Scenarios
- **Scenario A**: New Project (from scratch) → Full 4-round research
- **Scenario B**: Incremental Feature (existing) → Focused research (Round 2-3)
- **Scenario C**: Tech Decision → Single-round research (Round 3)

---

## Detailed Documentation

**Progressive disclosure**: Select topic for detailed reference.

### 1. Filesystem Detection Signals
**How the skill detects project state**

[View Details](./reference/filesystem-signals.md)

Topics: File existence checks, content analysis, git status signals, test file detection

---

### 2. Scenario Detection
**Project type classification and routing**

[View Details](./reference/scenario-detection.md)

Topics: Scenario A/B/C detection, routing logic, research phase selection

---

### 3. Output Examples
**Real suggestion examples in Chinese**

[View Details](./reference/output-examples.md)

Topics: Post-init suggestions, post-research suggestions, post-plan suggestions, post-dev suggestions, post-test suggestions

---

### 4. Ultra-Research Integration
**Deep integration with research workflow**

[View Details](./reference/ultra-research-integration.md)

Topics: Phase 0 coordination, round completion detection, scenario-aware routing

---

### 5. Best Practices
**Effective workflow guidance patterns**

[View Details](./reference/best-practices.md)

Topics: Timing guidance, user confirmation, avoiding over-suggestion, context preservation

---

### 6. FAQ
**Frequently asked questions**

[View Details](./reference/faq.md)

Topics: Customization, scenario override, suggestion suppression, multi-project handling

---

### 7. Related Tools
**Integration with other skills and commands**

[View Details](./reference/related-tools.md)

Topics: ultra-research, ultra-plan, ultra-dev, ultra-test, ultra-deliver, compressing-context

---

## Decision Logic

```
IF .ultra/ not exists:
  SUGGEST /ultra-init

ELIF specs/ has [NEEDS CLARIFICATION]:
  SUGGEST /ultra-research (detect scenario type)

ELIF specs/ complete AND tasks.json missing:
  SUGGEST /ultra-plan

ELIF tasks.json exists AND pending tasks:
  SUGGEST /ultra-dev [next-task-id]

ELIF all tasks complete AND tests passing:
  SUGGEST /ultra-test

ELIF tests passing AND ready to deploy:
  SUGGEST /ultra-deliver
```

---

## Token Efficiency

**Before modularization**: 1,075 lines in single REFERENCE.md
**After modularization**: ~150 lines main + 7 focused modules (~100-200 lines each)

**Benefit**: Load only needed sections, progressive disclosure optimizes context usage.

---

**For skill implementation details**, see `SKILL.md` (main skill file).


---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
