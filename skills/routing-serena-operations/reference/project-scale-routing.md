## Project Scale Routing

### Large Project Detection

**Threshold**: > 100 code files

**Detection**:
```bash
find src/ -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | wc -l
```

**Suggested Workflow** (in Chinese):
```
检测到大型项目（150+ 文件）

推荐使用 Serena 项目管理功能：

🎯 1. 激活项目上下文
mcp__serena__activate_project("ecommerce-platform")

好处：
- 多项目开发：快速切换上下文
- 隔离配置：每个项目独立设置
- 知识积累：记录项目特定信息

📝 2. 记录项目知识
mcp__serena__write_memory("coding-conventions", `
# 编码规范

## 代码风格
- ESLint: Airbnb config
- Prettier: 2 spaces, single quotes
- TypeScript: strict mode

## 测试
- 框架: Vitest
- 覆盖率: ≥80%
- 命名: *.test.ts

## 架构
- 状态管理: Zustand
- API 客户端: Axios + React Query
- 路由: React Router v6

## 重要决策
- 使用 server components（2024-03-15）
- 弃用 Redux，改用 Zustand（2024-02-20）
`)

📖 3. 查询项目知识
# 新人入职或上下文切换时
mcp__serena__read_memory("coding-conventions")

# 查看所有记录
mcp__serena__list_memories()

🔄 4. 多项目工作流
# 切换到另一个项目
mcp__serena__activate_project("admin-dashboard")

# 该项目的记忆立即可用
mcp__serena__read_memory("api-endpoints")

收益：
- 上下文切换：从 10 分钟 → 30 秒
- 知识传承：技术决策、约定、陷阱都有记录
- 新人友好：instant onboarding knowledge base
```

---

