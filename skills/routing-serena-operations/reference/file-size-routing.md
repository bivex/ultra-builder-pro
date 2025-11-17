## File Size Routing

### Detection Logic

```typescript
function routeByFileSize(filePath: string): RoutingDecision {
  const lineCount = execSync(`wc -l ${filePath}`).toString().split(' ')[0]

  if (lineCount < 5000) {
    return {
      tool: 'Read',
      reason: 'Small file, Read tool is fast and sufficient',
      action: 'ALLOW'
    }
  } else if (lineCount >= 5000 && lineCount < 8000) {
    return {
      tool: 'Serena (suggested)',
      reason: '60x token efficiency, recommend but not enforce',
      action: 'SUGGEST',
      commands: [
        'get_symbols_overview',
        'find_symbol with depth',
        'find_symbol with include_body'
      ]
    }
  } else {
    return {
      tool: 'Serena (enforced)',
      reason: 'Token overflow risk, must use Serena',
      action: 'BLOCK_READ',
      commands: ['get_symbols_overview', 'find_symbol']
    }
  }
}
```

### Output Examples

#### Scenario 1: Small File (< 5000 lines)

**User Request**: "Read src/utils/helpers.ts"

**File Size**: 450 lines

**Routing Decision**: Use Read tool

**Output**: (Silent - no intervention needed)

---

#### Scenario 2: Medium File (5000-8000 lines)

**User Request**: "Read src/services/userService.ts"

**File Size**: 6,500 lines

**Routing Decision**: Suggest Serena MCP

**Output** (in Chinese at runtime):
```
文件大小检测：src/services/userService.ts 有 6,500 行

⚠️ 文件较大，建议使用 Serena MCP 以获得更好的性能（60x 效率提升）

推荐方案：

1️⃣ 获取文件概览（推荐）
   mcp__serena__get_symbols_overview({
     relative_path: "src/services/userService.ts"
   })
   预计 token：~500（vs Read 工具的 28,000）

2️⃣ 查找特定符号
   mcp__serena__find_symbol({
     name_path: "UserService",
     relative_path: "src/services/userService.ts",
     depth: 1
   })
   预计 token：~1,200（方法列表 + 签名）

3️⃣ 读取特定方法
   mcp__serena__find_symbol({
     name_path: "UserService/getUserById",
     relative_path: "src/services/userService.ts",
     include_body: true
   })
   预计 token：~800（只包含该方法）

效率对比：
- Read 工具：28,000 tokens，可能失败
- Serena MCP：500-1,200 tokens，100% 成功率
- 提升：23x-56x

是否使用 Serena MCP？
```

---

#### Scenario 3: Large File (> 8000 lines)

**User Request**: "Read src/legacy/monolith.ts"

**File Size**: 12,000 lines

**Routing Decision**: BLOCK Read, ENFORCE Serena

**Output** (in Chinese at runtime):
```
⚠️ 文件过大警告

检测到：src/legacy/monolith.ts 有 12,000 行

❌ 已阻止 Read 工具
原因：
- Token 限制：需要 52,000+ tokens
- 超出上下文窗口（200K 的 26%）
- 成功率：<40%（频繁超时/错误）

✅ 强制使用 Serena MCP
原因：
- Token 效率：500-2,000 tokens（仅需要的部分）
- 成功率：100%
- 渐进式探索：从概览到细节

必需步骤：

1️⃣ 第一步：获取文件结构
   mcp__serena__get_symbols_overview({
     relative_path: "src/legacy/monolith.ts"
   })

   返回示例：
   {
     symbols: [
       { name: "LegacyService", kind: "Class", line: 10 },
       { name: "processData", kind: "Method", line: 450 },
       { name: "validateInput", kind: "Method", line: 1200 },
       ...
     ]
   }

2️⃣ 第二步：选择关键类/函数
   基于第一步的输出，选择需要深入了解的符号

3️⃣ 第三步：读取具体实现
   mcp__serena__find_symbol({
     name_path: "LegacyService/processData",
     relative_path: "src/legacy/monolith.ts",
     include_body: true
   })

效率：
- Read 工具：52,000 tokens → 失败
- Serena 3步法：500 + 1,200 + 800 = 2,500 tokens → 成功
- 提升：21x 效率 + 避免错误
```

---

