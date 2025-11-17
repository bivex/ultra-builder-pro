# Workflow Guide - Complete Reference

Comprehensive guide for intelligent next-step suggestions.

---

## State Detection Logic

### Research Phase Detection

**Filesystem Signals**:
```bash
# Research files exist
ls .ultra/docs/research/*.md

# Tasks file doesn't exist yet
! test -f .ultra/tasks/tasks.json
```

**Suggested Next Step**: `/ultra-plan`

**Rationale**: Research complete, ready to break down into tasks

---

### Planning Phase Detection

**Filesystem Signals**:
```bash
# Tasks file exists
test -f .ultra/tasks/tasks.json

# No code changes yet
git status | grep "nothing to commit"
```

**Suggested Next Step**: `/ultra-dev`

**Rationale**: Task breakdown complete, ready to start development

---

### Development Phase Detection

**Filesystem Signals**:
```bash
# Code changes exist
git status | grep "modified:"

# Tasks in progress
jq '.tasks[] | select(.status == "in_progress")' .ultra/tasks/tasks.json
```

**Suggested Next Steps**:
- More tasks pending: `/ultra-dev [next-task-id]`
- All tasks complete: `/ultra-test`

**Rationale**: Continue development or move to testing

---

### Testing Phase Detection

**Filesystem Signals**:
```bash
# All tasks completed
jq '.tasks[] | select(.status != "completed")' .ultra/tasks/tasks.json | wc -l
# Returns: 0

# Test files exist
ls src/**/*.test.* 2>/dev/null
```

**Suggested Next Step**: `/ultra-deliver`

**Rationale**: Development complete, tests passing, ready for delivery

---

## Next Step Decision Tree

```
Project State?
├─ Research files exist + No tasks.json → /ultra-plan
├─ tasks.json exists + No code changes → /ultra-dev
├─ Code changes + Tasks in progress → /ultra-dev [next-task]
├─ Code changes + All tasks done → /ultra-test
└─ Tests passing + All tasks done → /ultra-deliver
```

---

## Suggestion Templates

### After Research

```markdown
📊 项目状态分析

✅ 已完成:
- 研究报告: .ultra/docs/research/[topic].md
- 技术选型完成

🎯 建议下一步: `/ultra-plan`

**原因**: 研究已完成，需要将需求分解为可执行任务。

**预期输出**: `.ultra/tasks/tasks.json` (任务分解 + 依赖分析)
```

### After Planning

```markdown
📊 项目状态分析

✅ 已完成:
- 任务分解: 12 个任务定义
- 复杂度评估: 简单 4 个，中等 6 个，复杂 2 个

🎯 建议下一步: `/ultra-dev`

**原因**: 任务规划完成，可以开始编码。

**建议**: 从 task-1 (简单任务) 开始，建立信心后处理复杂任务。
```

### During Development

```markdown
📊 项目状态分析

✅ 已完成:
- Task 1: 用户认证 ✓
- Task 2: 用户注册 ✓

🚧 进行中:
- Task 3: 密码重置 (60% complete)

⏳ 待完成: 9 个任务

🎯 建议下一步: `/ultra-dev 3` (完成当前任务)

**或**: `/ultra-dev 4` (如果 task-3 被阻塞)
```

### After Development

```markdown
📊 项目状态分析

✅ 已完成:
- 所有 12 个任务已完成
- 代码变更: 45 files modified

⚠️  检查点:
- 测试覆盖率: 待验证
- 代码质量: 待验证

🎯 建议下一步: `/ultra-test`

**原因**: 所有功能已实现，需要验证质量。

**六维测试**: 功能、边界、异常、性能、安全、兼容性
```

### After Testing

```markdown
📊 项目状态分析

✅ 已完成:
- 开发: 12 个任务 ✓
- 测试: 六维覆盖 ✓
- 覆盖率: 87% (目标 80%) ✓

🎯 建议下一步: `/ultra-deliver`

**原因**: 代码质量合格，准备部署。

**交付内容**:
- 性能优化
- 安全审计
- 文档更新
- 部署准备
```

---

## Edge Cases

### User Skips Phases

**Scenario**: User runs `/ultra-dev` without `/ultra-plan`

**Response**:
```markdown
⚠️  工作流提醒

检测到跳过了 `/ultra-plan` 阶段。

**建议**:
1. 先运行 `/ultra-plan` 创建任务分解
2. 然后运行 `/ultra-dev [task-id]`

**原因**: 任务分解有助于:
- 明确开发范围
- 跟踪进度
- 估算时间

**如果确实要跳过**: 提供简要需求描述，我将直接开始编码。
```

### Multiple Paths Available

**Scenario**: Development complete, but tests haven't been written

**Response**:
```markdown
📊 项目状态分析

✅ 已完成:
- 开发: 12 个任务 ✓

⚠️  发现问题:
- 测试文件数量: 0
- 测试覆盖率: 0%

🎯 建议下一步: `/ultra-test`

**重要**: 虽然可以直接运行 `/ultra-deliver`，但强烈建议先完成测试，确保代码质量。
```

---

## Proactive Suggestions

### Auto-Trigger Conditions

1. **User asks "what's next?"**
   - Analyze project state → Suggest next command

2. **Command just completed**
   - Wait 2 seconds → Provide next step suggestion

3. **User seems uncertain**
   - Detect hesitation (e.g., "hmm", "不确定") → Offer guidance

### Do NOT Trigger On

- User is in middle of conversation
- User explicitly says they want to take a break
- User is just exploring/learning (not executing workflow)

---

## Workflow Shortcuts

### Fast Track (No Research Needed)

```bash
# User knows requirements clearly
/ultra-plan  # Skip /ultra-research
/ultra-dev
/ultra-test
/ultra-deliver
```

### Minimal Viable Workflow

```bash
# For small projects
/ultra-init my-app web react-ts git
/ultra-dev  # Code directly
/ultra-test
/ultra-deliver
```

---

**Complete Workflow Guide**: `~/.claude/workflows/development-workflow.md`
