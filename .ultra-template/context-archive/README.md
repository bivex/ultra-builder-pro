# Context Archive Directory

This directory stores compressed context summaries for long development sessions.

## Purpose

- Archive completed task details to free up conversation context
- Enable extended sessions with many tasks
- Provide historical reference for project decisions

## File Naming Convention

```
session-{timestamp}.md
```

Example:
```
session-2025-11-14T10-30-00.md
session-2025-11-14T15-45-30.md
```

## File Format

Each archive contains:
- Meta information (timestamps, token stats)
- Completed tasks summary (compact format)
- Technical decisions log
- Code snippets (if critical)
- Next session context

## Usage

### For Future Reference

To recall archived information:
```typescript
// Read the archive
Read(".ultra/context-archive/session-2025-11-14T10-30-00.md")

// Search for specific task
Grep("Task #5", { path: ".ultra/context-archive/" })
```

## Maintenance

### Auto-cleanup (Optional)

Archives older than 30 days can be deleted:
```bash
find .ultra/context-archive -type f -mtime +30 -delete
```

### Size Management

Typical archive sizes:
- 5 tasks: ~3KB
- 10 tasks: ~6KB
- 20 tasks: ~12KB

Expected total: <50KB per project

## Integration

### With git

- **Gitignored** by default (local context only)
- **Not synced** across team members
- **Each developer** has own archives

### With guiding-workflow

When session-index.json exists, guiding-workflow can suggest resuming previous context.

## Example Archive Preview

```markdown
# Context Archive - Session 2025-11-14 10:30

## Meta Information
- Original Tokens: 145,000
- Compressed Tokens: 62,000
- Compression Ratio: 57%

## Completed Tasks (5)
### Task #1: Implement JWT Authentication
- Completed | Branch: feat/task-1-auth
- Files: AuthService.ts, middleware.ts, auth.test.ts
- Tests: Pass (92% coverage)
- Commit: abc123 "feat: add JWT auth"

[... Tasks #2-5 ...]

## Technical Decisions
- Chose JWT over sessions (performance)
- RS256 for public key verification

## Next Session Context
- Continue with Task #6: Payment integration
- Remaining: 15 tasks
```
