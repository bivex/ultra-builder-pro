# Workflow Enforcement - Complete Reference

**Ultra Builder Pro 4.1** - Enforces independent-branch workflow, blocks anti-patterns.

---

## Overview

This skill enforces the mandatory independent-branch workflow: one task = one branch → complete → merge → delete.

**Core mission**: Prevent AI from suggesting alternative workflows that violate the constitutional workflow.

---

## Quick Reference

### The ONE True Workflow (Non-Negotiable)
```
main (always active, never frozen)
 ├── feat/task-1-xxx (create → complete → merge → delete)
 ├── feat/task-2-yyy (create → complete → merge → delete)
 └── feat/task-3-zzz (create → complete → merge → delete)
```

### What Gets BLOCKED
- ❌ Unified/long-lived feature branches
- ❌ Freezing main branch for batch deployment
- ❌ Delaying merges until "all tasks complete"
- ❌ Presenting workflow "options" to user
- ❌ Suggesting "batching" for efficiency

### Why It Matters
- Production projects need deployable main branch
- Hotfixes cannot wait for 31 tasks to complete
- Each task is independently reversible

---

## Detailed Documentation

**Progressive disclosure**: Select topic for detailed reference.

### 1. Trigger Detection Patterns
**Keywords that activate blocking**

[View Details](./reference/trigger-patterns.md)

Topics: "unified branch", "batch deployment", "workflow options", "freeze main", discussion triggers

---

### 2. Blocking Scenarios
**Specific cases where skill intervenes**

[View Details](./reference/blocking-scenarios.md)

Topics: Unified branch suggestion, batch merge suggestion, workflow "choices", freezing main

---

### 3. Enforcement Examples
**Real blocking messages in Chinese**

[View Details](./reference/enforcement-examples.md)

Topics: Blocking unified branch, blocking batch deployment, blocking workflow options

---

### 4. Correct Workflow Patterns
**What should happen instead**

[View Details](./reference/correct-patterns.md)

Topics: Independent branch per task, immediate merge after completion, continuous main deployment

---

### 5. Git Integration
**How enforcement works with git commands**

[View Details](./reference/git-integration.md)

Topics: Branch creation monitoring, merge timing checks, main branch protection

---

### 6. FAQ
**Frequently asked questions**

[View Details](./reference/faq.md)

Topics: Why so strict?, exceptions allowed?, performance impact?, customization?

---

### 7. Related Tools
**Integration with other skills and documentation**

[View Details](./reference/related-tools.md)

Topics: guarding-git-safety, ultra-dev command, ultra-git-workflow.md

---

## Enforcement Algorithm

```
IF discussion contains ["unified", "batch", "option", "choice", "workflow"]:
  ANALYZE intent

  IF intent == suggest_alternative_workflow:
    BLOCK immediately
    EXPLAIN constitutional workflow
    SHOW correct pattern
    REQUIRE user confirmation

  ELIF intent == clarify_workflow:
    ALLOW (educational discussion)
    REINFORCE correct pattern
```

---

## Integration with ultra-dev

**ultra-dev command** executes the workflow:
1. Create branch: `feat/task-{id}-{slug}`
2. Implement with TDD
3. Merge to main after quality gates pass
4. Delete branch

**enforcing-workflow skill** monitors discussions to prevent AI from suggesting deviations.

**Clear separation**: Command executes, skill monitors.

---

## Token Efficiency

**Before modularization**: 925 lines in single REFERENCE.md
**After modularization**: ~130 lines main + 7 focused modules (~50-150 lines each)

**Benefit**: Load only needed sections, progressive disclosure optimizes context usage.

---

**For skill implementation details**, see `SKILL.md` (main skill file).


---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
