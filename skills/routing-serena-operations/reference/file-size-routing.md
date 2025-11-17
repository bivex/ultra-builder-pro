## File Size Routing

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

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

---

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

**Output**:
```
File Size Detection: src/services/userService.ts has 6,500 lines

⚠️ Large file detected. Serena MCP recommended for better performance (60x efficiency improvement)

Recommended Approaches:

1️⃣ Get File Overview (Recommended)
   mcp__serena__get_symbols_overview({
     relative_path: "src/services/userService.ts"
   })
   Estimated tokens: ~500 (vs 28,000 with Read tool)

2️⃣ Find Specific Symbol
   mcp__serena__find_symbol({
     name_path: "UserService",
     relative_path: "src/services/userService.ts",
     depth: 1
   })
   Estimated tokens: ~1,200 (method list + signatures)

3️⃣ Read Specific Method
   mcp__serena__find_symbol({
     name_path: "UserService/getUserById",
     relative_path: "src/services/userService.ts",
     include_body: true
   })
   Estimated tokens: ~800 (only that method)

Efficiency Comparison:
- Read tool: 28,000 tokens, may fail
- Serena MCP: 500-1,200 tokens, 100% success rate
- Improvement: 23x-56x

Use Serena MCP?
```

---

#### Scenario 3: Large File (> 8000 lines)

**User Request**: "Read src/legacy/monolith.ts"

**File Size**: 12,000 lines

**Routing Decision**: BLOCK Read, ENFORCE Serena

**Output**:
```
⚠️ File Too Large Warning

Detected: src/legacy/monolith.ts has 12,000 lines

❌ Read Tool Blocked

Reasons:
- Token limit: Requires 52,000+ tokens
- Context window consumption: 26% of 200K budget
- Success rate: <40% (frequent timeouts/errors)

✅ Serena MCP Enforced

Reasons:
- Token efficiency: 500-2,000 tokens (only needed parts)
- Success rate: 100%
- Incremental exploration: From overview to details

Required Steps:

1️⃣ Step 1: Get File Structure
   mcp__serena__get_symbols_overview({
     relative_path: "src/legacy/monolith.ts"
   })

   Example Return:
   {
     symbols: [
       { name: "LegacyService", kind: "Class", line: 10 },
       { name: "processData", kind: "Method", line: 450 },
       { name: "validateInput", kind: "Method", line: 1200 },
       ...
     ]
   }

2️⃣ Step 2: Select Key Classes/Functions
   Based on Step 1 output, choose symbols you need to understand

3️⃣ Step 3: Read Specific Implementation
   mcp__serena__find_symbol({
     name_path: "LegacyService/processData",
     relative_path: "src/legacy/monolith.ts",
     include_body: true
   })

Efficiency:
- Read tool: 52,000 tokens → Failure
- Serena 3-step: 500 + 1,200 + 800 = 2,500 tokens → Success
- Improvement: 21x efficiency + error prevention
```

---
