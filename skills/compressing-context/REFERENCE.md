# Context Compressor - Complete Reference

## Overview
The Context Compressor Skill prevents context overflow by proactively compressing accumulated information during long development sessions, enabling 20-30 tasks per session instead of 10-15.

## Problem Statement

### Current Limitation
```python
# Without compression
Session capacity = 200K tokens
Per task consumption = 10-15K tokens (TDD cycle)
Max tasks = 200K / 15K ≈ 13 tasks

# With overflow risk
Task 1-10: 150K tokens (safe)
Task 11-15: 180K tokens (yellow zone)
Task 16+: OVERFLOW (context reset required)
```

### Solution
```python
# With compressing-context
Task 1-5: 75K tokens (no compression)
Compression: 75K → 15K (60K saved)
Task 6-10: 15K + 75K = 90K tokens
Compression: 90K → 18K (72K saved)
Task 11-20: Continue...

Max tasks = 30+ (with 2-3 compressions)
```

## Compression Algorithm

### Phase 1: Identify Candidates

```typescript
interface CompressionCandidate {
  content: string;
  tokens: number;
  compressibility: 'high' | 'medium' | 'low';
  priority: number;
}

function identifyCandidates(context: Context): CompressionCandidate[] {
  const candidates: CompressionCandidate[] = [];

  // High compressibility (90% reduction)
  if (hasCompletedTasks()) {
    candidates.push({
      content: 'Completed task details',
      tokens: estimateTaskTokens(),
      compressibility: 'high',
      priority: 10
    });
  }

  // High compressibility (95% reduction)
  if (hasCommittedCode()) {
    candidates.push({
      content: 'Historical code snippets',
      tokens: estimateCodeTokens(),
      compressibility: 'high',
      priority: 9
    });
  }

  // Medium compressibility (60% reduction)
  if (hasRepeatedSkillsOutput()) {
    candidates.push({
      content: 'Skills quality reports',
      tokens: estimateSkillsTokens(),
      compressibility: 'medium',
      priority: 7
    });
  }

  // Medium compressibility (70% reduction)
  if (hasVerboseToolOutput()) {
    candidates.push({
      content: 'Tool execution logs',
      tokens: estimateToolTokens(),
      compressibility: 'medium',
      priority: 6
    });
  }

  return candidates.sort((a, b) => b.priority - a.priority);
}
```

### Phase 2: Generate Summary

```typescript
interface TaskSummary {
  id: number;
  title: string;
  status: 'completed' | 'in_progress';
  branch: string;
  keyChanges: string[];
  tests: {
    status: 'pass' | 'fail';
    coverage: number;
  };
  commit: string;
  notes?: string;
}

function summarizeTask(task: Task, fullContext: string): TaskSummary {
  // Extract key information only
  return {
    id: task.id,
    title: task.title,
    status: task.status,
    branch: extractBranchName(fullContext),
    keyChanges: extractFileChanges(fullContext),  // Top 3 files only
    tests: {
      status: extractTestStatus(fullContext),
      coverage: extractCoveragePercentage(fullContext)
    },
    commit: extractCommitHash(fullContext),
    notes: extractCriticalDecisions(fullContext)  // Only critical items
  };
}

function compressTaskContext(tasks: Task[]): string {
  const summaries = tasks.map(task => summarizeTask(task, getFullContext()));

  // Format as compact markdown
  return summaries.map(s => `
### Task #${s.id}: ${s.title}
- ✅ ${s.status} | Branch: ${s.branch}
- Files: ${s.keyChanges.join(', ')}
- Tests: ${s.tests.status} (${s.tests.coverage}%)
- Commit: ${s.commit}
${s.notes ? `- Note: ${s.notes}` : ''}
  `.trim()).join('\n\n');
}
```

### Phase 3: Archive and Apply

```typescript
interface CompressionResult {
  originalTokens: number;
  compressedTokens: number;
  compressionRatio: number;
  archivePath: string;
  summary: string;
}

async function applyCompression(): Promise<CompressionResult> {
  const original = estimateCurrentTokens();
  const summary = await generateSessionSummary();

  // Save to archive
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const archivePath = `.ultra/context-archive/session-${timestamp}.md`;
  await Write(archivePath, generateFullArchive());

  // Generate compressed summary
  const compressed = summary.length / 4; // Rough token estimate

  // Apply to conversation (output in Chinese at runtime)
  await updateContext(`
📦 Context Compressed

Original size: ${original.toLocaleString()} tokens
Compressed: ${compressed.toLocaleString()} tokens
Saved: ${(original - compressed).toLocaleString()} tokens (${Math.round((1 - compressed/original) * 100)}%)

Archive location: ${archivePath}

${summary}
  `);

  return {
    originalTokens: original,
    compressedTokens: compressed,
    compressionRatio: compressed / original,
    archivePath,
    summary
  };
}
```

## Compression Techniques Deep Dive

### Technique 1: Delta Encoding
```
Instead of:
"Task #1: Full auth implementation with JWT, refresh tokens,
password hashing with bcrypt, email verification,
rate limiting on login endpoint..."

Use:
"Task #1: Auth (JWT + bcrypt + email verify + rate limit) ✅"

Reduction: 150 tokens → 15 tokens (90%)
```

### Technique 2: Reference Instead of Inline
```
Instead of:
"Here's the complete AuthService.ts:
[500 lines of code]"

Use:
"AuthService.ts → feat/task-1-auth (commit abc123)"

Reduction: 20,000 tokens → 20 tokens (99.9%)
```

### Technique 3: Aggregate Stats
```
Instead of:
"Task #1: code-quality-guardian Grade A (92/100)
 Task #2: code-quality-guardian Grade A (88/100)
 Task #3: code-quality-guardian Grade B+ (85/100)
 [Each with detailed breakdown]"

Use:
"All 5 tasks: code-quality avg Grade A (88%)"

Reduction: 10,000 tokens → 50 tokens (99.5%)
```

### Technique 4: Temporal Grouping
```
Instead of:
Individual summaries for each task

Use:
Sprint summary (Group of 5 tasks)

Reduction: 5 × 500 tokens = 2,500 → 600 tokens (76%)
```

## Integration Patterns

### Pattern 1: Auto-trigger After N Tasks
```typescript
// In ultra-dev command
async function completeTask(taskId: number) {
  // ... complete task logic ...

  const completedCount = getCompletedTaskCount();
  if (completedCount % 5 === 0) {
    // Every 5 tasks, check compression
    await checkCompressionNeeded();
  }
}

async function checkCompressionNeeded() {
  const tokens = estimateCurrentTokens();

  if (tokens > 140000) {
    // Orange zone - enforce
    await enforceCompression();
  } else if (tokens > 120000) {
    // Yellow zone - suggest
    await suggestCompression();
  }
}
```

### Pattern 2: Pre-emptive Check Before Major Operations
```typescript
// Before ultra-test or ultra-deliver
async function beforeMajorOperation(operation: string) {
  const tokens = estimateCurrentTokens();
  const required = estimateOperationTokens(operation);

  if (tokens + required > 170000) {
    // Output in Chinese at runtime per Language Protocol
    console.log(`⚠️ ${operation} requires ${required.toLocaleString()} tokens`);
    console.log(`Currently used ${tokens.toLocaleString()} tokens`);
    console.log(`Recommend compressing context before executing ${operation}`);

    await suggestCompression();
  }
}
```

### Pattern 3: Adaptive Thresholds
```typescript
interface CompressionThresholds {
  green: number;   // No action
  yellow: number;  // Suggest
  orange: number;  // Strongly recommend
  red: number;     // Enforce
}

function getAdaptiveThresholds(projectSize: number): CompressionThresholds {
  if (projectSize > 100) {
    // Large project - compress earlier
    return { green: 100000, yellow: 110000, orange: 130000, red: 150000 };
  } else if (projectSize > 50) {
    // Medium project - standard thresholds
    return { green: 120000, yellow: 130000, orange: 150000, red: 170000 };
  } else {
    // Small project - compress later
    return { green: 140000, yellow: 150000, orange: 170000, red: 180000 };
  }
}
```

## Archive Format

### Archive File Structure
```markdown
# Context Archive - Session 2025-11-14 10:30

## Meta Information
- Session Start: 2025-11-14 09:00:00
- Compression Time: 2025-11-14 10:30:00
- Original Tokens: 145,000
- Compressed Tokens: 62,000
- Compression Ratio: 57%

## Completed Tasks Summary

### Task #1: Implement JWT Authentication
**Status**: ✅ Completed
**Branch**: feat/task-1-auth (merged to main)
**Duration**: 45 minutes
**Complexity**: 6/10

**Key Changes**:
- `src/auth/AuthService.ts` (250 lines)
  - JWT token generation with RS256
  - Refresh token rotation
  - Token blacklist for logout
- `src/auth/middleware.ts` (80 lines)
  - Authentication middleware
  - Role-based authorization
- `tests/auth.test.ts` (180 lines)
  - 6-dimensional test coverage
  - Integration tests with database

**Test Results**:
- ✅ All tests passing
- Coverage: 92% (46/50 functions)
- Performance: Token generation <10ms

**Code Quality**:
- code-quality-guardian: Grade A (92/100)
- No SOLID violations
- DRY compliance: 100%

**Commit**: `abc123def` - "feat: add JWT authentication with refresh tokens"

**Technical Decisions**:
- Chose RS256 over HS256 for public key verification
- Refresh token rotation for security
- 15min access token, 7d refresh token expiry

**Issues Encountered**: None

---

### Task #2: Create User Dashboard
[Similar detailed format]

---

## Technical Decisions Log
1. JWT over sessions - Performance + Stateless
2. Material Design 3 for UI - Modern + Accessible
3. WebSocket for real-time data - Lower latency than polling

## Code Snippets (if critical for future reference)
[Only include absolutely critical snippets]

## Skills Activation Summary
- code-quality-guardian: 5 activations, avg Grade A
- test-strategy-guardian: 5 activations, all 6 dimensions passed
- git-workflow-guardian: 2 warnings (resolved)
- ui-design-guardian: 1 activation (Dashboard task)

## Next Session Context
**Current Task**: None (all tasks completed before compression)
**Pending Tasks**: 12 remaining
**Known Issues**: None
**Recommendations**: Continue with Task #6 (Payment integration)
```

## Recovery Procedures

### Scenario 1: Need to Recall Compressed Information
```bash
# User: "What was the implementation detail for Task #2?"
# Recovery:
Read(".ultra/context-archive/session-2025-11-14-1030.md")
# Find Task #2 section
# Provide detailed answer from archive
```

### Scenario 2: Compression Went Wrong
```bash
# If compression removed something critical:
# 1. Restore from archive
Read(".ultra/context-archive/[latest-session].md")

# 2. Manually extract needed context
# 3. Add back to conversation

# 4. Adjust compression settings
# (Lower aggressiveness, adjust thresholds)
```

### Scenario 3: Lost Context Across Sessions
```bash
# New session, need previous context:
# 1. List all archives
ls -lt .ultra/context-archive/

# 2. Read latest
Read(".ultra/context-archive/[latest].md")

# 3. Generate session continuation summary
"基于上一session归档，以下是项目状态:
[Extract key information from archive]

现在可以继续开发。"
```

## Performance Benchmarks

### Compression Speed
| Tasks Compressed | Archive Size | Processing Time |
|-----------------|--------------|-----------------|
| 5 tasks | 3KB | 2-3 seconds |
| 10 tasks | 6KB | 4-5 seconds |
| 20 tasks | 12KB | 8-10 seconds |
| 30 tasks | 18KB | 12-15 seconds |

### Token Savings
| Project Size | Before Compression | After Compression | Savings |
|--------------|-------------------|-------------------|---------|
| 10 tasks | 150K tokens | 70K tokens | 53% |
| 20 tasks | 280K tokens | 120K tokens | 57% |
| 30 tasks | 420K tokens | 180K tokens | 57% |

### Session Capacity
| Scenario | Without Compression | With Compression | Improvement |
|----------|-------------------|------------------|-------------|
| Simple tasks | 15 tasks | 35 tasks | +133% |
| Medium tasks | 13 tasks | 30 tasks | +130% |
| Complex tasks | 10 tasks | 22 tasks | +120% |

## Best Practices

### DO
✅ Compress every 5-7 tasks (optimal balance)
✅ Keep current task uncompressed (need full context)
✅ Archive to `.ultra/context-archive/` (gitignored, local only)
✅ Include timestamp in archive filenames (easy to find)
✅ Preserve critical technical decisions (even in summary)

### DON'T
❌ Compress too early (<5 tasks) - Insufficient gain
❌ Compress current task - Need full context to continue
❌ Delete archives - May need to reference later
❌ Over-compress - Keep critical context accessible
❌ Compress if plenty of tokens remain (<100K used)

## Future Enhancements

### Version 1.1 (P2 Priority)
- [ ] Selective compression (choose which tasks to compress)
- [ ] Compression preview (show what will be compressed)
- [ ] Undo compression (restore from archive)

### Version 1.2 (P3 Priority)
- [ ] Intelligent threshold adjustment (learn from patterns)
- [ ] Cross-session context loading (automatic continuation)
- [ ] Compression analytics (track savings over time)

### Version 2.0 (Future)
- [ ] ML-based content importance scoring
- [ ] Predictive compression (compress before needed)
- [ ] Semantic deduplication (remove similar content)
