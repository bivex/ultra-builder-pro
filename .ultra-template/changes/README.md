# Changes Directory

This directory contains **proposed changes** following the OpenSpec pattern.

## Structure

```
changes/
├── README.md           # This file
└── task-{id}/          # Per-task proposal directory
    ├── proposal.md     # Feature overview, rationale, and completion status
    └── tasks.md        # Implementation checklist from tasks.json
```

## Workflow

1. **Create**: `/ultra-dev` creates `changes/task-{id}/` with proposal.md
2. **Develop**: Implementation follows proposal, tasks tracked in tasks.md
3. **Complete**: Add `## Status: Completed` section to proposal.md
4. **Spec Changes**: Update proposal.md to document any specification changes

## Key Principle

**Changes/ is for proposals. Specs/ is for truth.**

- `changes/`: What we plan to do (and completion records)
- `specs/`: What has been done (current system state)

## Completion Marking

When a task completes, add to proposal.md:

```markdown
## Status: Completed

- **Date**: 2025-12-30
- **Commit**: abc123
- **Summary**: Brief description of what was implemented
```
