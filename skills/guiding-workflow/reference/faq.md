## FAQ

### Q1: What if research report doesn't have project type metadata?

**A**: guiding-workflow will **infer** from keywords or rounds completed:

**Inference logic**:
1. Check for keywords ("New Project", "Tech Decision", etc.)
2. If no keywords, check rounds completed:
   - 4 rounds → Assume "New Project"
   - 1 round (Round 3) → Assume "Tech Decision"
   - 2-3 rounds → Assume "Incremental Feature"
3. If still unclear, default to generic suggestion (no Scenario B context)

---

### Q2: What if specs are incomplete but user wants to plan?

**A**: guiding-workflow will **block** and suggest research:

**Output**:
```
⚠️ 规范未完成

**检测到 [NEEDS CLARIFICATION] 标记**：
- specs/product.md: 3 处
- specs/architecture.md: 1 处

**问题**：
/ultra-plan 需要 100% 完整的规范才能生成准确的任务拆分。

**建议**：先完成研究

**执行命令**：
/ultra-research

**预计耗时**：20-30 分钟（填补空缺部分）
```

**Why**: Prevent garbage-in-garbage-out (incomplete specs → bad tasks)

---

### Q3: Can guiding-workflow suggest /ultra-dev for a specific task?

**A**: YES, if task has no dependencies:

**Output**:
```
**下一个任务**：
Task #1: 实现用户认证（JWT）
- 复杂度：Medium
- 预计时长：4 小时
- 依赖：无（可立即开始）

**建议下一步**：
/ultra-dev   # 自动选择 Task #1

**或指定任务**：
/ultra-dev 3  # 如果 Task #3 无依赖，可并行开发
```

**Why**: Flexibility for parallel development (if no dependencies)

---

### Q4: What if user skips guiding-workflow suggestion?

**A**: guiding-workflow does NOT force workflow, it **suggests**:

**User freedom**:
- User can run any command at any time
- guiding-workflow only suggests optimal next step
- User can ignore and choose their own path

**Example**:
- guiding-workflow suggests: `/ultra-plan`
- User runs: `/ultra-dev` (skipping planning)
- Result: /ultra-dev will fail (no tasks.json), suggest /ultra-plan

**Philosophy**: Guide, don't control

---

### Q5: How does guiding-workflow handle multi-phase projects?

**A**: guiding-workflow tracks **current phase**, not entire project:

**Example**:
- Phase 1: MVP (12 tasks) → Complete → Delivered
- Phase 2: Beta features (8 tasks) → Current phase
- Phase 3: Scale (15 tasks) → Not started

**guiding-workflow focus**: Phase 2 (current)

**Output**:
```
**当前阶段**：Phase 2 - Beta Features

**Phase 2 进度**：
- ✅ 已完成：3/8 任务（38%）
- 🚧 进行中：Task #4
- ⏳ 待开始：4 任务

**建议下一步**：/ultra-dev 4
```

**Why**: Focus on current work, not future phases

---

### Q6: What if project uses old format (.ultra/docs/prd.md)?

**A**: guiding-workflow supports **both** formats:

**Detection order**:
1. Check for `specs/product.md` (new format)
2. If not found, check for `.ultra/docs/prd.md` (old format)
3. Use whichever exists

**Output** (old format):
```
**已完成**：
✅ .ultra/docs/prd.md 100% 完成
✅ .ultra/docs/tech.md 100% 完成

**建议**：考虑迁移到新格式（specs/）
- specs/product.md (instead of prd.md)
- specs/architecture.md (instead of tech.md)

**迁移命令**：
mv .ultra/docs/prd.md specs/product.md
mv .ultra/docs/tech.md specs/architecture.md
```

**Why**: Backward compatibility with Ultra Builder Pro 4.0 projects

---

### Q7: Can guiding-workflow suggest /ultra-status?

**A**: YES, guiding-workflow can suggest /ultra-status for progress check:

**Trigger**: User asks "What's the status?" or "How far along are we?"

**Output**:
```
**查看详细进度**：/ultra-status

/ultra-status 提供：
- 任务完成百分比
- 当前阶段分析
- 风险预警
- 下一步建议

**快速概览**（当前）：
- 5/12 任务完成（42%）
- 预计剩余时间：24 小时
```

**Why**: Complement guiding-workflow with detailed status

---

