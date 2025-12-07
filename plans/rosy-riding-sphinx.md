# Ultra Builder Pro 系统优化计划

> **基于 Anthropic 官方最佳实践的深度对标分析**
>
> 参考文章:
> 1. Effective Harnesses for Long-Running Agents
> 2. Effective Context Engineering for AI Agents
> 3. Claude Think Tool
> 4. Contextual Retrieval

---

## 用户确认决策

| 决策项 | 用户选择 |
|--------|---------|
| **实施范围** | P0 + P1 + P2 (全部三个阶段) |
| **优化策略** | 平衡优化 (节省 Token 同时保持文档清晰度) |
| **兼容性** | 需要向后兼容 (新字段可选，旧项目正常运行) |

---

## 一、差距总结

### 1.1 Long-Running Agents (会话状态管理)

| 最佳实践 | 当前状态 | 差距 |
|---------|---------|------|
| session-index.json 会话索引 | ❌ 缺失 | 无法快速恢复上次会话 |
| feature_list.json 功能验证 | ❌ 缺失 | 无 pass/fail 状态追踪 |
| claude-progress.txt 进度日志 | ⚠️ 仅 tasks.json | 缺少实时进度日志 |
| 自动会话恢复 | ❌ 仅手动 | 启动时不自动加载上下文 |
| 增量 git 提交追踪 | ✅ 已实现 | - |

### 1.2 Context Engineering (上下文工程)

| 最佳实践 | 当前状态 | 差距 |
|---------|---------|------|
| 工具描述 80-150 chars | ⚠️ 平均 258 chars | 超出 50% |
| 渐进式披露 | ✅ 90% 符合 | CLAUDE.md 过密 |
| Token 优化 | ⚠️ 75% 符合 | 可节省 20-25% |
| 规则重复控制 | ⚠️ 30-40% 重复 | skill-rules.json 臃肿 |
| MCP 显式激活 | ✅ 100% 符合 | - |

### 1.3 Think Tool (深度推理)

| 最佳实践 | 当前状态 | 差距 |
|---------|---------|------|
| 思考过程存档 | ❌ 仅最终输出 | 缺少 thinking-sessions/ |
| 决策链路审计 | ❌ 缺失 | 无 decision-audit.json |
| 动态 token 分配 | ❌ 固定 16K | 无复杂度适配 |
| 合规验证流程 | ⚠️ 仅用户确认 | 缺少政策检查清单 |

### 1.4 Contextual Retrieval (上下文检索)

| 最佳实践 | 当前状态 | 评估 |
|---------|---------|------|
| 混合检索策略 | ✅ 95% 符合 | 多层规则匹配 |
| 语义增强 | ⚠️ MCP 可用 | 未深度集成 |
| RAG 集成 | N/A | 当前无需求 |

---

## 二、当前系统评分

| 维度 | 得分 | 评价 |
|------|------|------|
| 上下文压缩 | 95% | 四级阈值管理，97% 压缩率 |
| 会话归档 | 80% | 有存储，缺索引 |
| 任务管理 | 90% | 完整生命周期 |
| 自动恢复 | 30% | 仅手动 |
| Token 优化 | 75% | 可减少 20-25% |
| Think 集成 | 70% | 6D 框架完整，存档不足 |
| **综合** | **73%** | 架构优秀，关键机制缺失 |

---

## 三、优化方案

### Phase 1: 会话状态增强 (P0 - 关键)

#### 1.1 添加 session-index.json

**文件**: `.ultra/context-archive/session-index.json`

```json
{
  "version": "1.0",
  "lastSession": "session-2025-12-07T10-30-00",
  "sessions": [
    {
      "id": "session-2025-12-07T10-30-00",
      "timestamp": "2025-12-07T10:30:00Z",
      "tasksCompleted": [1, 2, 3, 4, 5],
      "tokensCompressed": 75000,
      "keyDecisions": ["JWT", "PostgreSQL"],
      "nextTask": 6,
      "resumeContext": "继续 Task #6: 支付集成"
    }
  ]
}
```

**修改文件**:
- `skills/compressing-context/SKILL.md` - 压缩时更新索引
- `.ultra-template/context-archive/` - 添加模板

#### 1.2 添加 feature-status.json

**文件**: `.ultra/docs/feature-status.json`

```json
{
  "version": "1.0",
  "features": [
    {
      "id": "feat-auth",
      "name": "User Authentication",
      "status": "pass",
      "taskId": 1,
      "testedAt": "2025-12-07T10:30:00Z",
      "commit": "abc123"
    }
  ]
}
```

**修改文件**:
- `commands/ultra-test.md` - 测试后更新状态
- `commands/ultra-dev.md` - 任务完成时记录

#### 1.3 添加自动恢复引导

**修改**: `skills/guiding-workflow/SKILL.md`

新增 Phase 0:
1. 检测 session-index.json
2. 显示上次会话摘要
3. 建议恢复点或新任务

---

### Phase 2: Token 优化 (P1 - 重要)

#### 2.1 精简工具描述

**当前**: 平均 258 chars
**目标**: 120-150 chars

**修改文件**:
- `skills/*/SKILL.md` - 精简 description 字段
- 移除触发规则说明（已在 skill-rules.json）

**示例**:
```yaml
# Before (408 chars)
description: "Automates E2E testing with Playwright CLI (not MCP). TRIGGERS: User mentions 'E2E test', 'browser automation'..."

# After (130 chars)
description: "Generate and run E2E tests with Playwright CLI. Covers Core Web Vitals measurement."
```

**预计节省**: 100-150 tokens

#### 2.2 压缩 CLAUDE.md

**当前**: 384 行
**目标**: 250 行

**策略**:
- 移除详细示例 → 链接到文档
- 精简 MCP 说明 → 仅保留决策树
- 压缩 Skills 列表 → 表格概览

**预计节省**: 150-200 tokens

#### 2.3 优化 skill-rules.json

**当前**: 237 行，30-40% 规则重复
**目标**: 150 行，共享规则定义

**策略**:
```json
{
  "sharedPatterns": {
    "codeFiles": "**/*.{ts,js,tsx,jsx,py}",
    "uiFiles": "**/*.{tsx,jsx,vue,css,scss}"
  },
  "rules": {
    "code-editing": {
      "files": "$codeFiles",
      "skills": ["guarding-quality"]
    }
  }
}
```

**预计节省**: 400-600 tokens

---

### Phase 3: Think Tool 增强 (P2 - 增强)

#### 3.1 思考会话存档

**新增目录**: `.ultra/thinking-sessions/`

```
thinking-sessions/
├─ session-{date}-{round}.md
└─ session-index.json
```

**修改文件**:
- `commands/ultra-research.md` - Step 5 添加存档
- `commands/max-think.md` - 添加可选存档

#### 3.2 决策审计日志

**新增文件**: `.ultra/docs/decision-audit.json`

```json
{
  "decisions": [
    {
      "id": "tech-selection-nextjs",
      "decision": "选择 Next.js",
      "alternatives": ["Remix", "SvelteKit"],
      "reasoning": ["6D score: 8.5/10", "team familiarity"],
      "confidence": 0.95,
      "timestamp": "2025-12-07T10:30:00Z"
    }
  ]
}
```

**修改文件**:
- `commands/ultra-research.md` - Round 3 记录决策

#### 3.3 动态思考 token 分配

**修改**: `commands/max-think.md`

根据复杂度调整:
- 简单问题: 8K tokens
- 中等问题: 16K tokens (默认)
- 复杂问题: 24K tokens

---

## 四、实施优先级

| 阶段 | 内容 | 预计节省 | 工时 |
|------|------|---------|------|
| **P0** | session-index + feature-status + 自动恢复 | 提升恢复效率 80% | 3-4h |
| **P1** | 工具描述 + CLAUDE.md + rules 优化 | 650-950 tokens | 2-3h |
| **P2** | thinking-sessions + decision-audit | 可追溯性 +40% | 2-3h |

**总预计**: 7-10 小时，Token 节省 20-25%

---

## 五、关键文件清单

| 文件 | 修改类型 | 优先级 |
|------|----------|--------|
| `skills/compressing-context/SKILL.md` | 扩展 | P0 |
| `skills/guiding-workflow/SKILL.md` | 扩展 | P0 |
| `.ultra-template/context-archive/` | 新增模板 | P0 |
| `commands/ultra-test.md` | 扩展 | P0 |
| `commands/ultra-dev.md` | 扩展 | P0 |
| `CLAUDE.md` | 压缩 | P1 |
| `skills/skill-rules.json` | 优化 | P1 |
| `skills/*/SKILL.md` (6个) | 精简 | P1 |
| `commands/ultra-research.md` | 扩展 | P2 |
| `commands/max-think.md` | 扩展 | P2 |

---

## 六、风险评估

| 风险 | 缓解措施 |
|------|----------|
| session-index 损坏 | JSON 写入前验证 + 备份 |
| Token 优化过度 | 保留核心信息，仅移除冗余 |
| 向后兼容 | 新字段设为可选，旧项目正常运行 |

---

## 七、成功指标

- [ ] 会话恢复时间 < 30 秒（vs 当前 2-3 分钟手动）
- [ ] 启动 Token 减少 20%（~3-4K tokens）
- [ ] 功能验证状态 100% 可追踪
- [ ] 思考过程 100% 可存档
