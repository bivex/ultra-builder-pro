## Integration with Git Commands

### Integration Point 1: Before git checkout -b

**Guardian check**: Is user about to create a branch for multiple tasks?

**Detection**:
```bash
# User command (detected):
git checkout -b feat/user-system  # ← Generic name, might contain multiple tasks
```

**Guardian intervention**:
```
⚠️ 分支命名检测

**检测到的分支名**：`feat/user-system`

**问题**：分支名过于宽泛，可能用于多个任务

**建议**：使用任务特定的分支名

**正确命名格式**：
- `feat/task-1-user-model`（明确任务 ID）
- `feat/task-2-user-crud`
- `feat/task-3-auth-jwt`

**原因**：
- 任务特定分支名 → 明确范围
- 避免"顺便加个功能"（scope creep）
- Code Review 更聚焦

**建议命令**：
git checkout -b feat/task-1-user-model
```

---

### Integration Point 2: Before PR Creation

**Guardian check**: Does PR contain multiple tasks?

**Detection** (via git diff analysis):
```bash
# Analyze commit history
git log origin/main..HEAD

# If commits include multiple task IDs or varied topics:
# → Warn about multi-task PR
```

**Guardian intervention**:
```
⚠️ PR 范围检测

**检测到的 commits**：
- feat: add User model (Task #1)
- feat: implement User CRUD (Task #2)
- feat: add JWT auth (Task #3)

**问题**：PR 包含 3 个任务

**风险**：
- Code Review 质量低（300+ 行难以审查）
- 回滚困难（需回滚 3 个任务）
- 测试困难（3 个功能混在一起）

**建议**：拆分为 3 个独立 PR

**正确做法**：
1. 回滚到 main
2. 创建 feat/task-1-user-model → PR #1
3. 创建 feat/task-2-user-crud → PR #2
4. 创建 feat/task-3-auth-jwt → PR #3

**或者**（如果 commits 已存在）：
使用 interactive rebase 拆分分支
```

---

