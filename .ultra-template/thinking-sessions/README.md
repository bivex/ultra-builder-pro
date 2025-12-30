# Thinking Sessions Archive

This directory stores archived thinking sessions from /ultra-think.

## Purpose

- Archive deep thinking processes for future reference
- Enable decision audit and reasoning review
- Preserve analytical context for complex decisions

## File Structure

```
thinking-sessions/
├── README.md
├── session-index.json          # Index of all sessions
└── session-{date}-{topic}.md   # Individual session files
```

## Session File Format

```markdown
# Thinking Session: {topic}

**Date**: {ISO8601 timestamp}
**Duration**: {minutes}
**Complexity**: simple | medium | complex
**Tokens Used**: {count}

## Context
{Original problem or question}

## Analysis
{6-dimensional analysis output}

## Key Insights
- {insight 1}
- {insight 2}

## Decision
{Final recommendation}

## Confidence
{0.0 - 1.0}
```

## Usage

### Auto-Archive (via /ultra-think)
High-confidence decisions (≥0.9) or critical-impact decisions are automatically archived.

### Retrieval
```typescript
// Find all sessions about a topic
Grep("topic-keyword", { path: ".ultra/thinking-sessions/" })

// Load specific session
Read(".ultra/thinking-sessions/session-2025-12-07-database-selection.md")
```

## Integration

- **syncing-docs**: Links sessions to ADRs in docs/decisions/
- **guiding-workflow**: Suggests reviewing past decisions
