# Changes Directory

This directory contains **proposed changes** following the OpenSpec pattern.

## Structure

```
changes/
├── README.md           # This file
├── feat-{task-id}/     # Per-feature proposal directory
│   ├── proposal.md     # Feature overview and rationale
│   ├── tasks.md        # Implementation checklist
│   └── specs/          # Spec deltas (optional)
│       ├── product.md  # New/modified user stories
│       └── architecture.md  # Architecture changes
└── archive/            # Completed changes (moved after merge)
```

## Workflow

1. **Create**: `/ultra-dev` creates `changes/feat-{task-id}/` with proposal.md
2. **Develop**: Implementation follows proposal, tasks tracked in tasks.md
3. **Complete**: After task completion, deltas merged to main `specs/`
4. **Archive**: Directory moved to `changes/archive/feat-{task-id}-{date}`

## Key Principle

**Changes/ is for proposals. Specs/ is for truth.**

- `changes/`: What we plan to do
- `specs/`: What has been done (current system state)

## Template Usage

Copy `_template/` when creating a new feature proposal:
```bash
cp -r .ultra/changes/_template .ultra/changes/feat-{task-id}
```
