# Ultra Builder Pro 优化计划 - 基于 Anthropic 官方最佳实践

> **文档类型**: 设计文档 (Design Document)
> **状态**: 待实施
> **决策**: Phase 1 + Phase 2 并行实施，包含 MCP 自动建议
> **日期**: 2025-12-02

---

## 背景分析

### 文章 1: Effective Harnesses for Long-Running Agents
关键模式:
1. **Two-Part Solution**: Initializer Agent + Coding Agent
2. **Feature List**: JSON 格式，含 passes/fails 状态
3. **State Handoff**: 通过 progress 文件 + git commits
4. **E2E Verification**: 任务完成前强制验证
5. **init.sh**: 环境自动化设置

### 文章 2: Advanced Tool Use
关键模式:
1. **Tool Search Tool**: 动态发现 (85% token 节省)
2. **Programmatic Tool Calling**: Python 编排 (37% token 节省)
3. **Tool Use Examples**: 具体模式 (准确率 72% → 90%)
4. **defer_loading: true**: 按需加载

---

## 当前系统差距分析

### 会话状态管理 (Long-Running Pattern)
| 组件 | 状态 | 位置 |
|------|------|------|
| 会话索引/清单 | ❌ 缺失 | - |
| 跨会话进度聚合 | ❌ 缺失 | - |
| 自动上下文恢复 | ❌ 缺失 | - |
| Feature 通过/失败状态 | ❌ 缺失 | - |
| 显式检查点 | ❌ 缺失 | - |
| 手动恢复 | ⚠️ 需要 | .ultra/context-archive/ |

### 工具使用 (Advanced Tool Use)
| 组件 | 状态 | 位置 |
|------|------|------|
| 动态工具搜索 | ❌ 缺失 | - |
| 程序化工具调用 | ❌ 缺失 | - |
| MCP 自动激活 | ❌ 显式调用 | - |
| 工具示例 | ✅ 优秀 | skills/**/SKILL.md |

---

---

## 综合优化方案

基于两篇 Anthropic 文章和多视角分析，以下是推荐的优化方案：

### 方案概览

| 优先级 | 优化项 | 来源文章 | Token 影响 | 复杂度 |
|--------|--------|----------|-----------|--------|
| P0 | 会话索引清单 | Long-Running Agents | +50 tokens | 低 |
| P0 | Feature 通过/失败状态 | Long-Running Agents | +100 tokens | 低 |
| P1 | 会话恢复引导 | Long-Running Agents | +80 tokens | 低 |
| P1 | 延迟 Skill 加载 | Advanced Tool Use | -600 tokens | 中 |
| P2 | Hook 系统缓存 | Advanced Tool Use | -200 tokens | 中 |
| P2 | MCP 自动建议 | Advanced Tool Use | -150 tokens | 中 |

**净 Token 影响**: -720 tokens/会话 (约 15% 优化)

---

## 推荐实现方案

### Phase 1: 会话状态管理 (Long-Running Agent Patterns)

#### 1.1 添加会话索引清单

**文件**: `.ultra/context-archive/session-index.json`

```json
{
  "version": "1.0",
  "lastSession": "session-2025-12-02T10-30-00",
  "sessions": [
    {
      "id": "session-2025-12-02T10-30-00",
      "timestamp": "2025-12-02T10:30:00Z",
      "tasksCompleted": [1, 2, 3, 4, 5],
      "tokensCompressed": 75000,
      "keyDecisions": ["JWT over sessions", "Material Design 3"],
      "nextTask": 6,
      "resumeContext": "Continue with Task #6: Payment integration"
    }
  ]
}
```

**修改文件**:
- `skills/compressing-context/SKILL.md` - 添加索引更新逻辑
- `.ultra-template/context-archive/` - 添加模板

#### 1.2 扩展 tasks.json 支持测试状态

**扩展字段**:
```json
{
  "id": 1,
  "title": "Implement user authentication",
  "status": "completed",
  "testStatus": {
    "functional": true,
    "boundary": true,
    "exception": true,
    "performance": false,
    "security": true,
    "compatibility": null
  },
  "lastTestRun": "2025-12-02T10:30:00Z"
}
```

**修改文件**:
- `.ultra-template/tasks/tasks.json` - 扩展 schema
- `commands/ultra-dev.md` - TDD 后更新 testStatus
- `commands/ultra-test.md` - 读取/更新 testStatus
- `commands/ultra-status.md` - 显示 6D 测试状态

#### 1.3 添加会话恢复引导

**扩展**: `skills/guiding-workflow/SKILL.md`

新增 Phase 0 检查:
1. 检测 session-index.json 是否存在
2. 显示上次会话摘要
3. 建议恢复上下文或开始新任务

---

### Phase 2: Token 优化 (Advanced Tool Use Patterns)

#### 2.1 延迟 Skill 加载

**策略**: 低频 Skill 添加 `defer_loading: true`

| Skill | 触发率 | 策略 |
|-------|--------|------|
| guarding-quality | 90% | 保持加载 |
| guarding-git-workflow | 70% | 保持加载 |
| guiding-workflow | 60% | 保持加载 |
| compressing-context | 30% | **延迟加载** |
| syncing-docs | 20% | **延迟加载** |
| automating-e2e-tests | 10% | **延迟加载** |

**修改文件**:
- `skills/skill-rules.json` - 添加 defer_loading 字段
- `hooks/skill-activation-prompt.ts` - 处理延迟加载逻辑

**Token 节省**: ~600 tokens/会话

#### 2.2 Hook 系统缓存

**优化点**:
1. 缓存 skill-rules.json 解析结果
2. 简单提示快速短路 (如问候语)
3. 批量日志写入

**修改文件**:
- `hooks/skill-activation-prompt.ts`

**Token 节省**: ~200 tokens/会话

#### 2.3 MCP 自动建议 (已确认实施)

**新建文件**: `config/mcp-rules.json`

```json
{
  "version": "1.0",
  "description": "MCP tool auto-suggestion rules",
  "servers": {
    "context7": {
      "auto_suggest": true,
      "enforcement": "suggest",
      "description": "Official library documentation",
      "triggers": {
        "keywords": [
          "React hooks", "Next.js", "Vue", "official docs",
          "API reference", "library documentation", "TypeScript types"
        ],
        "intentPatterns": [
          "how to use .* in .*",
          "what is the .* API",
          ".*official.*documentation.*",
          ".*library.*docs.*"
        ]
      },
      "suggestion_template": "Consider using Context7 for official {library} documentation"
    },
    "exa": {
      "auto_suggest": true,
      "enforcement": "suggest",
      "description": "AI semantic code search",
      "triggers": {
        "keywords": [
          "code examples", "implementation pattern", "GitHub",
          "best practices", "real-world examples", "production code"
        ],
        "intentPatterns": [
          "find .* examples",
          "search .* implementations",
          "how do others implement .*",
          ".*production.*example.*"
        ]
      },
      "suggestion_template": "Consider using Exa to search for {topic} examples"
    }
  }
}
```

**Hook 集成方案**:

修改 `hooks/skill-activation-prompt.ts` 添加 MCP 检测:

```typescript
// 新增接口
interface McpRule {
  auto_suggest: boolean;
  enforcement: string;
  description: string;
  triggers: {
    keywords: string[];
    intentPatterns: string[];
  };
  suggestion_template: string;
}

// 新增函数
function loadMcpRules(): Record<string, McpRule> {
  const rulesPath = path.join(claudeDir, 'config/mcp-rules.json');
  if (!fs.existsSync(rulesPath)) return {};
  return JSON.parse(fs.readFileSync(rulesPath, 'utf-8')).servers;
}

function suggestMcpTools(prompt: string): string[] {
  const rules = loadMcpRules();
  const suggestions: string[] = [];

  for (const [server, rule] of Object.entries(rules)) {
    if (!rule.auto_suggest) continue;

    // Check keywords
    if (matchKeywords(prompt, rule.triggers.keywords)) {
      suggestions.push(`💡 ${rule.suggestion_template.replace('{topic}', 'relevant')}`);
    }

    // Check intent patterns
    if (matchIntentPatterns(prompt, rule.triggers.intentPatterns)) {
      suggestions.push(`💡 ${rule.suggestion_template}`);
    }
  }

  return [...new Set(suggestions)]; // Deduplicate
}

// 在 main() 中添加
const mcpSuggestions = suggestMcpTools(userPrompt);
if (mcpSuggestions.length > 0) {
  console.log('\n🔧 MCP TOOL SUGGESTIONS\n');
  mcpSuggestions.forEach(s => console.log(`  ${s}`));
}
```

**Token 节省**: ~150 tokens/会话 (减少用户手动指定 MCP 的指令)

---

## 关键文件清单

| 文件 | 修改类型 | 优先级 |
|------|----------|--------|
| `skills/compressing-context/SKILL.md` | 扩展 | P0 |
| `.ultra-template/tasks/tasks.json` | 扩展 schema | P0 |
| `skills/guiding-workflow/SKILL.md` | 添加 Phase 0 | P1 |
| `skills/skill-rules.json` | 添加 defer_loading | P1 |
| `hooks/skill-activation-prompt.ts` | 优化 + 延迟加载 | P1 |
| `commands/ultra-dev.md` | 更新 testStatus | P0 |
| `commands/ultra-test.md` | 读取 testStatus | P0 |
| `commands/ultra-status.md` | 显示测试状态 | P0 |
| `config/mcp-rules.json` | 新建 | P2 |

---

## 不推荐实现 (当前规模)

| 优化 | 原因 |
|------|------|
| Tool Search Pattern | 仅 6 个 Skill + 2 个 MCP，规模不足 |
| Programmatic Tool Calling | 需要 Claude API beta 功能 |
| Two-Part Agent (Initializer + Coding) | 当前架构已有 /ultra-init 覆盖 |

---

## 风险评估

| 风险 | 缓解措施 |
|------|----------|
| 会话索引损坏 | JSON 写入前验证，读取时备份 |
| testStatus 向后兼容 | null = 未测试，保持兼容 |
| 延迟加载遗漏 | 保留高频 Skill 常驻加载 |
| MCP 误触发 | 仅 suggest，不自动执行 |

---

## 实施时间线

- **Week 1**: Phase 1 (会话状态管理) - 3-4 小时
- **Week 2**: Phase 2.1-2.2 (延迟加载 + Hook 优化) - 2-3 小时
- **Week 3**: Phase 2.3 (MCP 自动建议) + 数据分析 - 2 小时

**总估时**: 7-9 小时
