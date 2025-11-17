---
name: ultra-serena-advisor
description: "Intelligent Serena MCP advisor. TRIGGERS: When discussing code understanding, cross-file refactoring, or symbol-level operations. ACTIONS: Analyze task type, suggest optimal Serena commands with explicit examples. BLOCKS: Text-based operations when semantic operations are safer. OUTPUT: User messages in Chinese at runtime; keep this file English-only."
allowed-tools: Bash, Grep, Read
---

# Ultra Serena Advisor

## Purpose

Intelligently recommend Serena MCP usage based on task analysis, preventing unsafe text-based operations when semantic operations are required.

## When

**Auto-trigger before**:
- Cross-file refactoring discussions (rename, extract, move)
- Large codebase exploration (>100 files or >1000 lines/file)
- Symbol-level operations (find all references, dependency analysis)
- Project knowledge management discussions
- Multi-project context switching

**Keyword detection**:
- "rename across", "refactor", "find all usages", "understand codebase"
- "large file", "legacy code", "architecture analysis"
- "record decision", "project memory", "switch project"

## Do

### 1. Analyze Task Type

**Task classification**:
```
Code Understanding → get_symbols_overview + find_symbol
Cross-file Refactoring → rename_symbol + editing tools
Impact Analysis → find_referencing_symbols
Knowledge Management → memory system
Multi-project → activate_project
```

### 2. Suggest Serena When

**Mandatory Serena scenarios** (BLOCK text-based alternatives):
- Cross-file symbol rename (>5 files)
- Symbol-level operations (need scope understanding)
- Project knowledge tracking

**Recommended Serena scenarios**:
- Large file understanding (>1000 lines)
- Cross-file operations (>10 files)
- Complex refactoring (SOLID violations)

**Optional Serena scenarios**:
- File exploration (can use built-in, but Serena more efficient)

### 3. Provide Explicit Commands

**Template structure** (output in Chinese at runtime):
```
场景：{task description}

❌ 内置工具方法：
{built-in tool approach}
问题：{risks and limitations}

✅ Serena 方法：
{complete mcp__serena__* call with all parameters}
优势：{benefits}

结果：{expected outcome with metrics}
```

**Example output** (for cross-file rename):
```
场景：将 getUserById 重命名为 fetchUserById（78 个引用，23 个文件）

❌ 内置工具（Grep + Edit）：
Grep("getUserById")  # 返回 300 个匹配
问题：
- 包括注释、字符串（30% 误报率）
- 无法区分不同模块的同名函数
- 需要手动逐个 Edit
- 错误率：30%，耗时：2.5 小时

✅ Serena 语义理解：
mcp__serena__rename_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts",
  new_name: "fetchUserById"
})

优势：
- 理解作用域，只改相关符号
- 自动跳过注释和字符串
- 自动跨文件更新所有引用
- 错误率：0%，耗时：5 分钟

结果：78 个引用自动更新，0 错误，30x 时间节省
```

### 4. Safety Checks and Blocks

**BLOCK these operations** (when Serena is the only safe choice):

```
IF task.type == "cross-file rename" AND files > 5:
  BLOCK Grep + Edit approach
  ENFORCE Serena rename_symbol
  SHOW safety comparison (30% error rate vs 0%)

IF task.type == "symbol-level operation":
  BLOCK text-based search
  ENFORCE Serena find_symbol or find_referencing_symbols
  EXPLAIN scope understanding requirement

IF task.type == "project knowledge":
  ENFORCE Serena memory system
  EXPLAIN no alternative exists
```

**Example blocking message** (output in Chinese):
```
⚠️ 安全警告

检测到跨文件重命名操作（23 个文件）

❌ 已阻止 Grep + Edit 方法
原因：错误率 30%，高风险

✅ 强制使用 Serena rename_symbol
原因：语义理解，0% 错误率

建议命令：
mcp__serena__rename_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts",
  new_name: "fetchUserById"
})
```

### 5. Compare with Built-in Tools

**Decision matrix** (reference for recommendations):

| Scenario | Built-in Tools | Serena MCP | Recommendation |
|----------|---------------|------------|----------------|
| Cross-file rename (>5 files) | ❌ 30% error rate | ✅ 0% error rate | **Serena only** |
| Symbol-level operations | ❌ Cannot understand scope | ✅ Semantic understanding | **Serena only** |
| Project knowledge | ❌ No solution | ✅ memory system | **Serena only** |
| Large file (>5000 lines) | ⚠️ May fail | ✅ 60x efficiency | **Serena recommended** |
| Small file rename (<5 files) | ✅ Fast and simple | ⚠️ Overkill | **Built-in OK** |
| Simple text search | ✅ Grep efficient | ⚠️ Unnecessary | **Built-in OK** |

## Don't

- **Don't suggest Serena** for simple tasks where built-in tools are sufficient:
  * Small file operations (<1000 lines)
  * Single-file edits
  * Simple text search without scope requirements
  * Non-code files (.txt, .md, .json)

- **Don't block** built-in tools when they are safe and efficient:
  * Reading small files
  * Simple Grep searches
  * Single-file Edit operations

- **Don't provide vague suggestions**:
  * ❌ Bad: "Maybe try Serena"
  * ✅ Good: Complete command with all parameters explained

## Outputs

**Standard output format** (in Chinese at runtime):

```
## Serena 使用建议

**任务类型**：{classification}

**推荐工具**：{Serena or Built-in}

**原因**：
- {reason 1}
- {reason 2}

**完整命令**：
```typescript
{complete mcp__serena__* call}
```

**参数说明**：
- `name_path`: {explanation}
- `relative_path`: {explanation}
- `{other params}`: {explanation}

**预期结果**：{outcome with metrics}

**对比**：
- 内置工具：{time/error rate}
- Serena MCP：{time/error rate}
- 提升：{improvement}
```

**For blocking scenarios** (add warning section):
```
⚠️ **安全警告**

已阻止不安全操作：{operation}

原因：{risk explanation}

强制使用 Serena 原因：{safety benefits}
```

## Integration Points

**Works with**:
- **ultra-file-router**: File-size-based routing (one entry point to Serena)
- **guarding-code-quality**: Detects refactoring needs, advisor suggests Serena
- **ultra-refactor command**: Automatically invokes advisor before refactoring

**Provides to**:
- Users: Clear guidance on when/how to use Serena
- System: Safety enforcement for critical operations
- Documentation: Practical usage examples

## Performance Metrics

**Target metrics**:
- Serena adoption rate: 20% → 80% (in applicable scenarios)
- Cross-file refactoring error rate: 30% → <5%
- User query "how to use Serena": Reduced by 70%

## Example Triggers

### Trigger 1: Cross-file Rename
**User**: "Rename getUserById to fetchUserById across the project"

**Advisor Action**:
1. Detect: Cross-file operation
2. Check: File count (use Grep to estimate)
3. IF >5 files → BLOCK Grep+Edit, SUGGEST Serena
4. Provide complete rename_symbol command
5. Show safety comparison

### Trigger 2: Understand Large Codebase
**User**: "Understand how payment processing works"

**Advisor Action**:
1. Detect: Code understanding task
2. Check: File size (estimate from directory structure)
3. SUGGEST: get_symbols_overview for structure exploration
4. SUGGEST: find_symbol with depth for incremental understanding
5. Provide exploration workflow

### Trigger 3: Legacy Code Analysis
**User**: "I need to understand this 5000-line legacy file"

**Advisor Action**:
1. Detect: Large file + understanding need
2. RECOMMEND: Serena (60x efficiency)
3. Provide three-step workflow:
   - get_symbols_overview (structure)
   - find_symbol depth=1 (method list)
   - find_symbol include_body=true (specific methods)
4. Show token comparison (35K → 2K)

### Trigger 4: Project Knowledge
**User**: "How do I record the technical decision we just made?"

**Advisor Action**:
1. Detect: Knowledge management need
2. ENFORCE: Serena memory system (only choice)
3. Provide write_memory example
4. Suggest naming convention (tech-decision-{topic})
5. Show retrieval workflow (read_memory, list_memories)

## Notes

- This skill provides **guidance**, not execution
- User must explicitly invoke Serena commands
- Skill enforces safety by blocking unsafe alternatives
- All user-facing messages should be in Chinese at runtime
- Keep this file in English for consistency
