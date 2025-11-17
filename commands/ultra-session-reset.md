---
description: Manually trigger session archive and memory reset
allowed-tools: TodoWrite, Read, Write, Bash
---

# /session-reset

## Purpose

Immediately archives current session and clears L4 Session Memory to start fresh.

## Usage

```bash
/session-reset [--keep-context]
```

**Options**:
- `--keep-context`: Archive but keep L4 temporary context (useful for brief interruptions)

## Execution Workflow

### 1. Collect Session Metadata

Gather current session information:
- Start/end timestamps and duration
- Total messages exchanged
- Completed tasks
- Peak token usage
- Key decisions from L4 memory
- Active risks from L4 memory

### 2. Generate Archive Summary

Create comprehensive archive with:
- **Session Statistics**: Duration, messages, peak token usage
- **Completed Tasks**: All achievements with details
- **Key Decisions**: Rationale, impact, dates (from L4 Memory)
- **Active Risks**: Severity, mitigation plans (from L4 Memory)
- **Next Session Prompt**: Critical information for resuming work
- **Archive Metadata**: Reason and timestamp

### 3. Save Archive File

Save to: `.ultra/docs/sessions/archive-<timestamp>.md`

### 4. Clear L4 Session Memory

Clear or preserve L4 Session Memory based on `--keep-context` flag:
- `recent_decisions`: []
- `active_risks`: []
- `temporary_context`: Preserved if flag set, otherwise cleared

**Note**: L4 Memory auto-clears at start of next conversation

### 5. Notify User

Display completion message in Chinese with:
- Session duration and message count
- Completed tasks count
- Peak token usage
- Archive file path
- Context preservation status

## Auto-Trigger Conditions

This command is **automatically executed** when:
1. ⏰ **3 hours idle** detected (no tool calls)
2. ✅ **Major task completed** (/ultra-deliver finished)
3. 👤 **User explicitly requests** (/session-reset)

## Use Cases

**Natural Break Point**: Completed major milestone, ready to start new work
```bash
/session-reset
```

**Context Pollution**: Context feels cluttered, want to clean up and restart
```bash
/session-reset
```

**Brief Interruption**: Need to pause briefly but preserve current work context
```bash
/session-reset --keep-context
```

## Expected Benefits

- **+20% Long Session Stability**: Prevent context pollution
- **-5000 Tokens per Session**: Clear stale context regularly
- **+15% Decision Clarity**: Fresh start for new tasks
- **+30% L4 Memory Hit Rate**: Stays focused on current work

## Integration

- **Input**: Current session context + L4 Memory
- **Output**: Archive file in `.ultra/docs/sessions/`
- **Timing**: Auto-triggered or manual invocation
- **Next**: Start fresh session with clean context

## Output Format

**Standard output structure**: See `@config/ultra-command-output-template.md` for the complete 6-section format.

**Command icon**: 🔄

**Note**: This command archives the session and provides a fresh start for new work.
