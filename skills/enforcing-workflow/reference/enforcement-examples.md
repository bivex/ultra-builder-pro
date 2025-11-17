## Enforcement Examples (Chinese)

### Example 1: Simple Enforcement

**Trigger**: Keywords "Option 1" detected

**Output** (concise):
```
⚠️ 工作流不可协商提醒

检测到即将建议替代工作流。

**Ultra Builder Pro 使用唯一强制工作流**：
- 每个任务 = 独立分支
- 完成即合并到 main
- 无替代方案，无工作流选项

**参考**：@guidelines/ultra-git-workflow.md
```

---

### Example 2: Detailed Enforcement (Production Scenario)

**Trigger**: Unified branch suggestion

**Output** (detailed with real-world scenario):

```
🚫 工作流违规警告

**真实案例：为什么统一分支在生产环境不可行**

**场景**：某公司采用统一分支工作流

**时间线**：
- Day 1: 创建 `feat/user-system`（31 个任务）
- Day 30: 完成 15/31 任务（50%）
- Day 30 晚 10pm: 💥 生产环境严重 bug（支付失败）

**问题**：
- 需要紧急修复支付 bug
- 但 main 分支过时（30 天前的代码）
- `feat/user-system` 尚未完成（还需 30 天）

**选项分析**：
1. ❌ 基于 main 修复 → 30 天落后，无法验证是否兼容 feat/user-system
2. ❌ 基于 feat/user-system 修复 → 包含未完成的 16 个任务，无法部署
3. ❌ Cherry-pick 15 个任务到 main → 3-5 天工作量，冲突解决复杂

**结果**：支付 bug 修复延迟 3-5 天，业务损失 $500K-$1M

---

✅ **如果使用独立分支工作流**：

**时间线**：
- Day 1-30: 15 个任务逐个完成并合并到 main
- Day 30 晚 10pm: 💥 生产环境严重 bug

**修复流程**：
1. 创建 `hotfix/payment-bug` 基于 main（包含最新的 15 个任务）
2. 修复 bug（30 分钟）
3. 测试（15 分钟）
4. 合并到 main 并部署（15 分钟）

**总耗时**：1 小时
**业务损失**：$50K（vs $500K-$1M）

**结论**：独立分支工作流在生产环境是唯一安全选择

**参考**：生产环境 Git 策略白皮书
```

---

### Example 3: Educational Enforcement

**Trigger**: User asks "Why can't I have workflow options?"

**Output** (educational tone):

```
📚 工作流强制的原因

**问题**："为什么不能提供工作流选项让我选择？"

**回答**：

**原因 #1：生产环境的非协商需求**

软件开发不是孤立的个人项目，而是面向生产环境的团队协作。

**生产环境的铁律**：
1. main 分支必须随时可部署（用于紧急修复）
2. 功能必须增量集成（避免集成地狱）
3. 问题必须可独立回滚（降低风险）

**这些不是"偏好"，而是经过数十年验证的工程实践。**

---

**原因 #2：避免决策疲劳和认知负担**

如果提供"工作流选项"：
- 每个任务都需要决策："用统一分支还是独立分支？"
- 团队成员选择不同 → 工作流混乱
- 新人加入 → 需要学习"哪种情况用哪种工作流"

**认知成本**：每次决策 5-10 分钟 × 31 个任务 = 2.5-5 小时浪费

**独立分支工作流（唯一选择）**：
- 零决策成本（每个任务都一样）
- 团队一致性（所有人用同一工作流）
- 新人上手快（只学一种模式）

**效率提升**：2.5-5 小时节省，专注于实际开发

---

**原因 #3：AI 建议的质量保证**

如果允许 AI 建议"多种工作流"：
- AI 可能建议不安全的工作流（如统一分支）
- 用户可能选择错误的选项（缺乏经验）
- 导致生产环境问题（如上述支付 bug 案例）

**强制工作流的好处**：
- AI 只建议安全的工作流
- 用户不会犯错（无选择 = 无错误）
- 生产环境安全有保障

---

**类比**：

**航空安全检查清单**：
- 飞行员不能"选择"是否检查起飞清单
- 清单是强制执行的（非协商）
- 原因：乘客生命安全不容妥协

**Git 工作流**：
- 开发者不能"选择"工作流
- 独立分支是强制执行的（非协商）
- 原因：生产环境稳定性不容妥协

---

**结论**：

工作流强制不是限制你的自由，而是保护你和团队免受生产环境风险。

**参考**：
- Google SRE Book - Branch Management
- Accelerate (DevOps Research) - Trunk-Based Development
- @guidelines/ultra-git-workflow.md
```

---

