# Architecture Spec Delta

**Feature**: [Task Title]
**Task ID**: {id}
**Target**: specs/architecture.md

---

## Changes Summary

| Type | Count | Description |
|------|-------|-------------|
| ADDED | 0 | New components/decisions |
| MODIFIED | 0 | Updated architecture |
| REMOVED | 0 | Deprecated components |

---

## ADDED

### New Component: {ComponentName}

**Purpose**: [What this component does]

**Location**: `src/{path}/`

**Dependencies**:
- {dependency 1}
- {dependency 2}

**Interfaces**:
```typescript
interface {ComponentName} {
  // Interface definition
}
```

**Rationale**: [Why this component was added - ADR reference if applicable]

---

## MODIFIED

### Component: {ExistingComponentName}

**Previous Architecture**:
> [Describe previous state]

**Updated Architecture**:
> [Describe new state]

**Changes**:
- [ ] {specific change 1}
- [ ] {specific change 2}

**Reason**: [Why this change was needed]

**Migration**: [Any migration steps required]

---

## REMOVED

### Component: {DeprecatedComponentName}

**Reason**: [Why this was removed]
**Replaced by**: {NewComponentName} or "N/A"
**Migration**: [Steps for consumers of this component]

---

## Technology Decisions

### ADR-{number}: {Decision Title}

**Status**: Proposed | Accepted | Deprecated
**Context**: [Why this decision is needed]
**Decision**: [What was decided]
**Consequences**: [Impact of this decision]

---

## Merge Instructions

After task completion, merge this delta to `specs/architecture.md`:

1. Add new components to appropriate section
2. Update existing component documentation
3. Remove or mark deprecated components
4. Add ADR to `docs/decisions/` if applicable
