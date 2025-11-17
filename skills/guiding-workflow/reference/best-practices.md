## Best Practices

### Practice 1: Always Read Latest Research Report

**Why**: Project type determines next-step rationale

**How**:
```typescript
const researchFiles = await glob(".ultra/docs/research/*.md");
const latestReport = researchFiles[researchFiles.length - 1];
const projectType = await detectProjectType(latestReport);
```

**Benefit**: Tailored suggestions (avoid suggesting skipped rounds)

---

### Practice 2: Provide Context-Aware Rationale

**Bad** ❌:
```
建议下一步：/ultra-plan
```

**Good** ✅:
```
建议下一步：/ultra-plan

**原因**：
规范已 100% 完成（specs/product.md 无 [NEEDS CLARIFICATION] 标记），可以开始将需求拆分为可执行的原子任务。

**预计生成**：
- .ultra/tasks/tasks.json（12-20 个任务）
- 预计总时长：40-80 小时
```

**Why**: User understands **why** this is the next step

---

### Practice 3: Respect User's Scenario B Choices

**Scenario**: User chose "Incremental Feature" → Only Round 2-3 executed

**Wrong behavior** ❌:
```
建议下一步：完成 Round 1 和 Round 4
```

**Correct behavior** ✅:
```
建议下一步：/ultra-plan

**原因**：
老项目增量开发（Incremental Feature）已完成核心轮次（Round 2-3），解决方案和技术栈已明确，可直接规划任务。

**跳过轮次**：
- Round 1（问题发现）：老项目已有背景，无需重复
- Round 4（风险映射）：增量开发风险可控
```

**Why**: Don't force workflow, respect user's Scenario B selection

---

### Practice 4: Provide Alternative Paths When Appropriate

**Scenario**: After Tech Decision research

**Output**:
```
**建议下一步（2 个选项）**：

**选项 1**（推荐）：直接进入任务规划
/ultra-plan

**选项 2**：验证技术选择后再规划
- 创建简单 PoC（1-2 小时）
- 验证核心技术栈
- 确认后运行 /ultra-plan
```

**Why**: User has choice based on confidence level

---

### Practice 5: Show Progress Metrics

**During development**:
```
**任务进度**：
- ✅ 已完成：5 个（42%）
- 🚧 进行中：1 个
- ⏳ 待开始：6 个（50%）

**实际 vs 预计**：
- 已完成 5 个任务：17h（预计 18h，提前 1h）
- 剩余 7 个任务：预计 26h
- 预计总完成日期：2025-11-20
```

**Why**: User can track progress and adjust timeline

---

