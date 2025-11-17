---
name: workflow-guide
description: "Guides next steps based on project state. TRIGGERS: After phase completion or user asks 'what's next'. ACTIONS: Detect research/plan/dev/test status via filesystem and suggest the next /ultra-* command."
allowed-tools: Read, Glob
---

# Workflow Guide

## Purpose
Suggest the next logical command using filesystem signals.

## When
- After a phase completes (research/plan/dev/test/deliver)
- User asks for guidance or next steps
- User seems uncertain after command completion

## Do
- Detect project state via filesystem
  - Specification files (new): .ultra/specs/product.md, .ultra/specs/architecture.md
  - Specification files (old): .ultra/docs/prd.md, .ultra/docs/tech.md
  - Research files: .ultra/docs/research/*.md
  - Task plan: .ultra/tasks/tasks.json
  - Code changes: git status
  - Test files: *.test.*, *.spec.*
  - Active changes: .ultra/changes/task-*/

- Check specification completeness
  - If specs/product.md or docs/prd.md has [NEEDS CLARIFICATION] markers → Suggest /ultra-plan
  - If specs/architecture.md or docs/tech.md has [NEEDS CLARIFICATION] markers → Suggest /ultra-plan
  - If specifications complete but no tasks.json → Suggest /ultra-plan

- Suggest appropriate next command based on state
  - No specs exist: Suggest /ultra-init (if .ultra/ missing) or /ultra-plan
  - Specs incomplete ([NEEDS CLARIFICATION] markers): Suggest /ultra-plan
  - Research exists but no specs: Suggest /ultra-plan
  - After research: /ultra-plan
  - After planning (tasks.json created): /ultra-dev
  - After dev (code committed): /ultra-test or next /ultra-dev
  - After testing (all tests pass): /ultra-deliver
  - Active changes/ folders exist: Remind to complete tasks or merge spec deltas

## Don't
- Do not force workflow, respect user decisions
- Do not suggest skipping phases

## Outputs
- Next step recommendation with rationale
- Current project state summary
- Language: Chinese (simplified) at runtime
