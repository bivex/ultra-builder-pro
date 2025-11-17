## Output Examples (Chinese)

### Example 1: After /ultra-init (No Research Yet)

**Project state**:
- `.ultra/` exists
- No `specs/` files
- No research reports

**Output**:
```
📋 当前项目状态

**阶段**：项目已初始化，等待需求研究

**已完成**：
✅ 项目结构初始化（.ultra/ 目录）

**待完成**：
⏳ 需求和技术调研（specs/ 文件缺失）

**建议下一步**：/ultra-research

**原因**：
规范文件（specs/product.md, specs/architecture.md）不存在，需要通过研究流程生成完整规范。

**预计时长**：50-70 分钟（4 轮交互式发现）

**ROI**：70 分钟投资可节省 10+ 小时返工（8.3x 回报）
```

---

### Example 2: After /ultra-research (New Project, 4 Rounds Complete)

**Project state**:
- Research report exists with "New Project" indicator
- `specs/product.md` 100% complete
- `specs/architecture.md` 100% complete
- No `tasks.json`

**Output**:
```
📋 当前项目状态

**阶段**：需求研究完成（New Project 流程）

**已完成**：
✅ 4 轮完整研究（70 分钟）
  - Round 1: 问题发现（20 分钟）
  - Round 2: 解决方案探索（20 分钟）
  - Round 3: 技术选型（15 分钟）
  - Round 4: 风险与约束（15 分钟）
✅ specs/product.md 100% 完成（无 [NEEDS CLARIFICATION] 标记）
✅ specs/architecture.md 100% 完成（技术栈已确定）

**待完成**：
⏳ 任务拆分和依赖分析

**建议下一步**：/ultra-plan

**原因**：
规范已 100% 完成，可以开始将需求拆分为可执行的原子任务。

**预计生成**：
- .ultra/tasks/tasks.json（任务列表 + 依赖关系）
- 任务数量：预计 12-20 个（根据项目规模）
- 预计总时长：预计 40-80 小时开发

**下一阶段准备**：
确保已理解 specs/ 文件内容，/ultra-plan 将基于规范生成详细任务分解。
```

---

### Example 3: After /ultra-research (Tech Decision, Round 3 Only)

**Project state**:
- Research report with "Tech Decision" indicator
- Only Round 3 executed (15 min)
- `specs/architecture.md` updated with tech choice

**Output**:
```
📋 当前项目状态

**阶段**：技术选型完成（Tech Decision 流程）

**已完成**：
✅ Round 3: 技术选型（15 分钟）
  - 6 维度对比矩阵
  - 技术栈确定：Next.js 14 + TypeScript + Tailwind
  - 决策理由记录到 specs/architecture.md
✅ specs/architecture.md 已更新

**待完成**：
⏳ 验证技术选择（可选）
⏳ 任务规划

**建议下一步（2 个选项）**：

**选项 1**（推荐）：直接进入任务规划
```bash
/ultra-plan
```
**适用场景**：技术选型确信无疑，可直接拆分任务

**选项 2**：验证技术选择后再规划
- 创建简单 PoC（Proof of Concept）
- 验证核心技术栈可行性
- 确认后运行 /ultra-plan

**适用场景**：首次使用该技术栈，需要验证

**建议**：
如果是熟悉的技术栈（Next.js + TypeScript），直接选择选项 1。
如果是新技术栈，建议选项 2（1-2 小时 PoC 验证）。
```

---

### Example 4: After /ultra-plan (Tasks Generated)

**Project state**:
- `tasks.json` exists with 12 tasks
- All tasks status: "pending"
- No code changes yet

**Output**:
```
📋 当前项目状态

**阶段**：任务规划完成，准备开发

**已完成**：
✅ 任务拆分完成（12 个原子任务）
✅ 依赖关系分析完成
✅ 复杂度评估完成（3 个 Complex，5 个 Medium，4 个 Simple）
✅ 预计总时长：48 小时

**任务概览**：
- 待开始：12 个（100%）
- 进行中：0 个
- 已完成：0 个

**下一个任务**：
Task #1: 实现用户认证（JWT）
- 复杂度：Medium
- 预计时长：4 小时
- 依赖：无（可立即开始）

**建议下一步**：/ultra-dev

**TDD 流程提示**：
/ultra-dev 将自动执行以下流程：
1. 🔴 RED: 编写失败的测试（6 维度覆盖）
2. 🟢 GREEN: 实现最小代码使测试通过
3. 🔵 REFACTOR: 优化代码质量（SOLID/DRY/KISS/YAGNI）
4. ✅ 质量门检查：测试全部通过 + 代码审查
5. 🔀 合并到 main 并删除分支

**执行命令**：
```bash
/ultra-dev   # 自动选择 Task #1
# 或
/ultra-dev 3  # 指定 Task #3（如果无依赖）
```
```

---

### Example 5: During Development (5/12 Tasks Complete)

**Project state**:
- `tasks.json` shows 5 completed, 1 in-progress, 6 pending
- Git shows modified files

**Output**:
```
📋 当前项目状态

**阶段**：开发进行中

**任务进度**：
- ✅ 已完成：5 个（42%）
- 🚧 进行中：1 个（Task #6: 创建用户 Dashboard）
- ⏳ 待开始：6 个（50%）

**已完成任务回顾**：
1. ✅ Task #1: 用户认证（JWT）- 4h（预计 4h）
2. ✅ Task #2: 用户注册 API - 3h（预计 3h）
3. ✅ Task #3: 密码重置功能 - 2.5h（预计 3h，提前完成）
4. ✅ Task #4: 邮件服务集成 - 4h（预计 4h）
5. ✅ Task #5: 用户资料 CRUD - 3.5h（预计 4h，提前完成）

**当前任务**：
🚧 Task #6: 创建用户 Dashboard
- 复杂度：Medium
- 预计时长：5 小时
- 进度：估计 60% 完成（基于 git diff）

**建议下一步**（2 个选项）：

**选项 1**：继续当前任务
```bash
/ultra-dev 6  # 继续 Task #6
```

**选项 2**：完成当前任务后进入下一个
- 完成 Task #6 的 TDD 流程
- 通过质量门检查
- 自动建议 Task #7

**预计完成时间**：
- 当前任务剩余：~2 小时
- 剩余 6 个任务：~22 小时
- 总剩余时间：~24 小时
- 预计完成日期：2025-11-20（基于每天 8 小时工作）

**质量指标**：
- 测试覆盖率：87%（目标 ≥80%）✅
- 代码质量：A 级（SOLID/DRY 合规）✅
- 提交规范：100% Conventional Commits ✅
```

---

### Example 6: All Tasks Complete, Ready to Test

**Project state**:
- All 12 tasks completed
- Tests exist but may need re-running
- Code committed to main

**Output**:
```
📋 当前项目状态

**阶段**：开发完成，准备测试

**任务完成情况**：
✅ 12/12 任务全部完成（100%）

**实际耗时 vs 预计**：
- 预计总时长：48 小时
- 实际总时长：44 小时
- 效率：109%（提前 4 小时完成）🎉

**代码质量**：
- Commits: 37 个（平均 3 个/任务）
- 分支: 12 个已合并并删除
- 代码行数：+3,200 行（代码），+1,800 行（测试）
- 测试/代码比：56%（健康）

**建议下一步**：/ultra-test

**测试范围**（6 维度）：
1. ✅ Functional: 核心业务逻辑
2. ✅ Boundary: 边界条件（空值、最大值）
3. ✅ Exception: 错误处理（网络失败、超时）
4. ✅ Performance: 性能测试（负载、响应时间）
5. ✅ Security: 安全测试（SQL 注入、XSS）
6. ✅ Compatibility: 兼容性（浏览器、平台）

**前端项目额外检查**：
- Core Web Vitals:
  * LCP < 2.5s（Largest Contentful Paint）
  * INP < 200ms（Interaction to Next Paint）
  * CLS < 0.1（Cumulative Layout Shift）

**执行命令**：
```bash
/ultra-test
```

**预计耗时**：15-30 分钟（包括 Core Web Vitals 测量）
```

---

### Example 7: After Testing, Ready to Deliver

**Project state**:
- All tests passing
- Coverage ≥80%
- Core Web Vitals met

**Output**:
```
📋 当前项目状态

**阶段**：测试完成，准备交付

**测试结果**：
✅ 6 维度测试全部通过
- Functional: 124 tests passed
- Boundary: 45 tests passed
- Exception: 38 tests passed
- Performance: 12 tests passed
- Security: 18 tests passed
- Compatibility: 15 tests passed

**覆盖率**：
- 总体覆盖率：87%（目标 ≥80%）✅
- 关键路径：100%（认证、支付）✅
- 分支覆盖率：82%（目标 ≥75%）✅

**Core Web Vitals**（前端项目）：
- LCP: 2.1s < 2.5s ✅
- INP: 180ms < 200ms ✅
- CLS: 0.08 < 0.1 ✅

**建议下一步**：/ultra-deliver

**交付优化包括**：
1. 🚀 性能优化
   - Bundle 体积分析
   - Code splitting
   - 图片优化

2. 🔒 安全审计
   - 依赖漏洞扫描（npm audit）
   - 代码审查（SQL 注入、XSS）
   - 基础设施检查（HTTPS、CORS、Rate limiting）

3. 📚 文档更新
   - README.md
   - CHANGELOG.md
   - API 文档
   - 架构决策记录（ADRs）

4. 📦 部署准备
   - 环境变量检查清单
   - 数据库迁移准备
   - 回滚计划

**执行命令**：
```bash
/ultra-deliver
```

**预计耗时**：1-2 小时
```

---

