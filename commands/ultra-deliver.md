---
description: Delivery optimization (performance + security + documentation)
allowed-tools: TodoWrite, Task, Read, Write, Edit, Bash, Grep, Glob
---

# /ultra-deliver

Prepare for delivery with performance optimization, security audit, and documentation updates.

## Pre-Execution Checks

Before starting delivery preparation, verify:
- Check task completion in `.ultra/tasks/tasks.json`
  - If incomplete tasks: Ask whether to continue delivery prep
- Verify code quality: Run `git status` for uncommitted changes
- Check test suite status: Did all tests pass in last run?
- **Check pending changes**: Scan `.ultra/changes/` for unmerged proposals
- Assess documentation state: Is README.md, CHANGELOG.md up to date?
- Determine release type: Patch, minor, or major?

## HARD BLOCKS

**These checks are MANDATORY. Delivery BLOCKED until resolved.**

### BLOCK 1: Tests Not Passing

**Check**: Run full test suite
```bash
npm test
```

**Block if**: Any test fails or coverage <80%

**Block Message (Chinese)**:
```
❌ 交付被阻断：测试未通过

测试结果：{pass_count}/{total_count} 通过
覆盖率：{coverage}% (要求：≥80%)

失败的测试：
{failed_test_list}

修复方案：
1. 运行 /ultra-test 查看详细报告
2. 修复失败的测试用例
3. 确保覆盖率达到 80%

阻断原因：未通过测试的代码不能交付。
```

### BLOCK 2: Unmerged Spec Changes

**Check**: Pending proposals in `.ultra/changes/`
```bash
ls -d .ultra/changes/feat-* 2>/dev/null | head -5
```

**Block if**: Non-empty changes/ directories with completed tasks exist but specs not updated

**Block Message (Chinese)**:
```
❌ 交付被阻断：规范变更未合并

检测到未合并的变更提案：
{changes_list}

这些变更的规范增量未合并到主规范：
- specs/product.md
- specs/architecture.md

修复方案：
1. 审核每个变更目录的 specs/ 子目录
2. 合并增量到主规范（下方自动执行）
3. 归档完成的变更

阻断原因：规范必须反映当前系统真实状态。
```

## Workflow

### 0. OpenSpec Merge (MANDATORY FIRST STEP)

**Purpose**: Merge all completed feature proposals to main specs before delivery.

**Process**:

```bash
# 1. List all pending changes
for dir in .ultra/changes/feat-*; do
  if [ -d "$dir" ]; then
    echo "Processing: $dir"

    # 2. Check if task is completed
    TASK_ID=$(basename "$dir" | sed 's/feat-//')
    TASK_STATUS=$(cat .ultra/tasks/tasks.json | jq -r ".tasks[] | select(.id==\"$TASK_ID\") | .status")

    if [ "$TASK_STATUS" = "completed" ]; then
      # 3. Check for spec deltas
      if [ -d "$dir/specs" ]; then
        echo "Merging spec deltas from $dir/specs/"

        # 4. Merge product.md delta
        if [ -f "$dir/specs/product.md" ]; then
          # Read delta, append ADDED sections, update MODIFIED sections
          # AI analyzes and applies changes
        fi

        # 5. Merge architecture.md delta
        if [ -f "$dir/specs/architecture.md" ]; then
          # Read delta, apply architecture changes
          # AI analyzes and applies changes
        fi
      fi

      # 6. Archive the completed change
      ARCHIVE_NAME="feat-${TASK_ID}-$(date +%Y-%m-%d)"
      mkdir -p .ultra/changes/archive
      mv "$dir" ".ultra/changes/archive/$ARCHIVE_NAME"
      echo "Archived: $ARCHIVE_NAME"
    fi
  fi
done
```

**Output** (Chinese at runtime):
```
📋 OpenSpec 合并报告
====================

已处理变更提案：{count} 个

合并的规范增量：
✅ feat-{id}: 合并到 specs/product.md (新增 {n} 个用户故事)
✅ feat-{id}: 合并到 specs/architecture.md (更新技术决策)

已归档：
- .ultra/changes/archive/feat-{id}-{date}

规范一致性：✅ 已验证
```

### 1. Performance Optimization
Delegate to performance agent:
```
Task(subagent_type="ultra-performance-agent",
     prompt="Analyze and optimize: [app/feature]. Focus on Core Web Vitals (LCP/INP/CLS) and bottlenecks.")
```

**Core Web Vitals Measurement**:
- Measured via Lighthouse CLI (industry standard, Google official)
- Authoritative scores for LCP, INP (via TBT), CLS
- No browser automation needed - direct measurement

### 2. Security Audit
```bash
npm audit
# Review results, apply fixes for high/critical issues
```

### 3. Documentation Update (AI Automated)

**All documentation tasks are automated by Claude Code AI using built-in tools.**

#### 3.1 CHANGELOG Auto-Generation

**AI Workflow** (executes automatically):

```typescript
// Step 1: Get commits since last release
const commits = Bash("git log v1.0.0..HEAD --format='%s'");

// Step 2: Auto-categorize by Conventional Commits
const categorized = {
  Added: [],      // feat: commits
  Fixed: [],      // fix: commits
  Changed: [],    // refactor: commits
  Docs: [],       // docs: commits
  Security: []    // security: commits
};

commits.split('\n').forEach(commit => {
  if (commit.startsWith('feat:')) categorized.Added.push(commit.slice(6));
  else if (commit.startsWith('fix:')) categorized.Fixed.push(commit.slice(5));
  else if (commit.startsWith('refactor:')) categorized.Changed.push(commit.slice(10));
  else if (commit.startsWith('docs:')) categorized.Docs.push(commit.slice(6));
  // ... etc
});

// Step 3: Generate CHANGELOG.md
const changelogContent = `
# Changelog

## [1.1.0] - ${new Date().toISOString().split('T')[0]}

### Added
${categorized.Added.map(c => `- ${c}`).join('\n')}

### Fixed
${categorized.Fixed.map(c => `- ${c}`).join('\n')}

### Changed
${categorized.Changed.map(c => `- ${c}`).join('\n')}
`;

Write("CHANGELOG.md", changelogContent);
```

**Token cost**: ~2000 tokens
**Accuracy**: 95% (based on Conventional Commits compliance)

---

#### 3.2 ADR Auto-Creation

**AI Workflow** (triggered during /ultra-research or major decisions):

```typescript
// Auto-generate ADR number
const existingADRs = Bash("ls .ultra/docs/decisions 2>/dev/null | wc -l").trim();
const nextNumber = String(parseInt(existingADRs) + 1).padStart(4, '0');

// Generate ADR content
const adrContent = `# ${nextNumber}. [Decision Title]

Date: ${new Date().toISOString().split('T')[0]}
Status: Accepted

## Context
[Problem description - captured during /ultra-research]

## Decision
[Chosen solution - captured during /ultra-research]

## Consequences
[Trade-offs and impacts - analyzed during /ultra-research]
`;

// Write ADR file
Write(`.ultra/docs/decisions/${nextNumber}-decision-title.md`, adrContent);
```

**Token cost**: ~1000 tokens
**Trigger**: Automatically during /ultra-research Round 3 (Technology Selection)

---

#### 3.3 Technical Debt Auto-Tracking

**AI Workflow** (executes automatically):

```typescript
// Step 1: Find all TODO/FIXME/HACK markers
const debtMarkers = Grep({
  pattern: "(TODO|FIXME|HACK):",
  path: "src/",
  output_mode: "content",
  "-n": true  // Show line numbers
});

// Step 2: Auto-categorize by keyword
const categorized = {
  P0: [],  // FIXME: → Critical
  P1: [],  // TODO: → High
  P2: []   // HACK: → Medium
};

debtMarkers.split('\n').forEach(line => {
  if (line.includes('FIXME:')) categorized.P0.push(line);
  else if (line.includes('TODO:')) categorized.P1.push(line);
  else if (line.includes('HACK:')) categorized.P2.push(line);
});

// Step 3: Generate technical-debt.md
const debtReport = `
# Technical Debt

## Critical (P0 - Fix Before Release)
${categorized.P0.map(item => {
  const [file, line, ...rest] = item.split(':');
  return `- ${rest.join(':').trim()} (\`${file}:${line}\`)`;
}).join('\n')}

## High (P1 - Next Sprint)
${categorized.P1.map(item => {
  const [file, line, ...rest] = item.split(':');
  return `- ${rest.join(':').trim()} (\`${file}:${line}\`)`;
}).join('\n')}

## Medium (P2 - Backlog)
${categorized.P2.map(item => {
  const [file, line, ...rest] = item.split(':');
  return `- ${rest.join(':').trim()} (\`${file}:${line}\`)`;
}).join('\n')}
`;

Write(".ultra/docs/technical-debt.md", debtReport);
```

**Token cost**: ~3000 tokens
**Accuracy**: 100% (exact pattern matching)

---

### 4. Documentation Review

**AI validates** (no manual work required):
- ✅ CHANGELOG completeness (compare commits vs CHANGELOG entries)
- ✅ ADR consistency (verify all /ultra-research decisions documented)
- ✅ README.md updates (suggest changes based on new features)
- ✅ API documentation (detect new public exports, suggest additions)

### 5. Final Quality Check
```bash
# Run full test suite
npm test

# Build production
npm run build

# Verify build output
```

### 6. Prepare Release
```bash
# Update version
npm version [patch|minor|major]

# Generate release notes
# Tag and commit
```

## Deliverables

- ✅ Performance optimized (Core Web Vitals pass)
- ✅ No security vulnerabilities
- ✅ Documentation up-to-date
- ✅ All tests pass
- ✅ Production build successful

## Integration

- **Skills**: Documentation Guardian (auto-activates)
- **Agents**: ultra-performance-agent for optimization
- **Next**: Deploy to production or create release PR

---

## Post-Execution Logging (Observability)

After this command completes, write a JSON log entry to `.ultra/logs/session-<timestamp>.json` containing:
- `command`: "ultra-deliver"
- `estimatedTokens`: approximate tokens consumed (context + tools)
- `filesReadTopN`: list of files read (top N by size)
- `triggeredSkills`: array of skills triggered during execution
- `notes`: performance/security/doc updates performed

User-facing summaries should be presented in Chinese at runtime; keep file formats English-only.

Example:
```bash
COMMAND="ultra-deliver" \
ESTIMATED_TOKENS=3800 \
FILES_READ_TOPN='["README.md","CHANGELOG.md"]' \
TRIGGERED_SKILLS='["syncing-docs","automating-e2e-tests"]' \
NOTES='{"perf": "optimized images and code splitting", "docs": "updated README"}' \
bash .claude/scripts/log-observer.sh
```

Config overrides (if needed):
```bash
node .claude/scripts/read-config.js vitals.targets
```

## Output Format

**Standard output structure**: See `@config/ultra-command-output-template.md` for the complete 6-section format.

**Command icon**: 🚀

**Example output**: See template Section 7.6 for ultra-deliver specific example.
