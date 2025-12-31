# Changes Directory

This directory contains **task-level change history** for audit and traceability.

## Structure

```
changes/
├── README.md           # This file
└── task-{id}/          # Per-task change directory
    └── proposal.md     # Change history + completion status
```

## Dual-Write Mode

When requirements change during development:

1. **Update specs/ immediately** - Keep specifications current
2. **Record in proposal.md** - Maintain change history

This ensures:
- Parallel tasks always read consistent specifications
- Task-level changes remain traceable for audit
- No document drift between development and delivery

## Change Record Format

```markdown
## Change History

### {date}: {change title}
- **Original**: {original approach}
- **Changed to**: {new approach}
- **Reason**: {why the change}
- **Updated**: specs/{file} §{section}
```

## Completion Marking

When a task completes, add to proposal.md:

```markdown
## Status: Completed

- **Date**: 2025-12-30
- **Commit**: abc123
- **Summary**: Brief description of what was implemented
```

## Key Principle

**Specs/ is always current. Changes/ is the audit trail.**

- `specs/`: Current system state (source of truth)
- `changes/`: What changed, why, and when (history)
