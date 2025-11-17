---
name: syncing-docs
description: "Syncs documentation and manages knowledge. TRIGGERS: After research, feature completion, or architecture changes. ACTIONS: Suggest spec updates, propose ADRs, detect spec-code drift."
allowed-tools: Read, Write, Glob, Grep
---

# Documentation Guardian

## Purpose
Ensure documentation stays synchronized with code and decisions.

## When
- After /ultra-research completion (CRITICAL - check specs/)
- Feature completion (check spec-code consistency)
- Architecture changes (check specs/architecture.md)
- /ultra-deliver execution (final sync check)

## Do

### File Detection (Backward Compatible)
- Check if specs/product.md exists → Use specs/ (new projects)
- Fallback to docs/prd.md if specs/ doesn't exist (old projects)
- Check if specs/architecture.md exists → Use specs/ (new projects)
- Fallback to docs/tech.md if specs/ doesn't exist (old projects)

### Post-Research Checks
1. Does research introduce new requirements?
   - New projects: Suggest update to specs/product.md
   - Old projects: Suggest update to docs/prd.md
2. Does research affect technology choices?
   - New projects: Suggest update to specs/architecture.md
   - Old projects: Suggest update to docs/tech.md
3. Is this a major decision? Suggest ADR creation in docs/decisions/

### Spec-Code Drift Detection
- Compare specs/product.md user stories with implemented features
- Check if architecture.md matches actual code structure
- Flag [NEEDS CLARIFICATION] markers that remain unfilled

### General Documentation
- Detect outdated docs (README/API docs)
- Recommend tech-debt entries when shortcuts taken
- Suggest lessons-learned after major features

## Don't
- Do not auto-create files without user confirmation
- Do not trigger on minor code changes
- Do not force old projects to migrate to specs/ (suggest only)

## Outputs

**Format** (Chinese at runtime):
- File path with clear indication (specs/ or docs/)
- Reason for update (what changed)
- Specific sections to update
- ADR template if needed

**Content to convey**:
- Technology selection changed → Suggest update specs/architecture.md Technology Stack section
- Research found new requirements → Suggest add user stories to specs/product.md
- Major architecture decision → Suggest create ADR in docs/decisions/
- Detected old project structure → Suggest update docs/prd.md or consider migrating to specs/

## Migration Suggestion (Optional)

When detecting old projects without specs/:
- Suggest (don't force) migration to spec-driven structure
- Convey: Old doc structure detected, consider migrating to new specs/ system
- Only suggest once per session
