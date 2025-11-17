## Operation Type Routing

### Cross-File Rename

**Trigger Keywords**: "rename across", "rename in multiple files", "change name globally"

**Detection Example**:
```typescript
function detectCrossFileRename(userInput: string): boolean {
  const renameKeywords = ['rename', 'change name', 'refactor name']
  const crossFileKeywords = ['across', 'multiple', 'all files', 'everywhere', 'globally']

  return renameKeywords.some(k => userInput.includes(k)) &&
         crossFileKeywords.some(k => userInput.includes(k))
}
```

**Workflow**:

1. **Detect Intent**: User mentions cross-file rename
2. **Estimate Scope**: `grep -r "symbolName" src/ | wc -l` to count affected files
3. **Route Decision**:
   - If affected files > 5: BLOCK Grep+Edit, ENFORCE Serena
   - If affected files ≤ 5: SUGGEST Serena, allow built-in

**Example Output** (for >5 files, in Chinese):
```
场景：将 getUserById 重命名为 fetchUserById

检测结果：
- 引用次数：78 个
- 涉及文件：23 个
- 风险评估：高（多文件操作）

❌ 内置工具方法（Grep + Edit）：
步骤：
1. Grep("getUserById")  # 返回 300 个匹配
2. 手动过滤（排除注释、字符串）
3. 逐个文件 Edit

问题：
- 误报率：~30%（包括注释、字符串、同名变量）
- 无法区分不同作用域的同名符号
- 需要手动编辑 23 个文件
- 预计错误：6-8 处遗漏或误改
- 耗时：2.5 小时

✅ Serena 语义方法（推荐）：
mcp__serena__rename_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts",
  new_name: "fetchUserById"
})

优势：
- 理解作用域：只改相关符号
- 自动跳过：注释、字符串、文档
- 跨文件更新：自动处理所有 78 个引用
- 错误率：0%（语义理解）
- 耗时：5 分钟

结果：
78 个引用自动更新，23 个文件同步修改，0 错误
预计节省：2.4 小时 + 避免 6-8 个错误

是否使用 Serena rename_symbol？
```

---

### Understand Architecture

**Trigger Keywords**: "understand", "how does", "architecture", "structure", "how it works"

**Suggested Workflow**:
```
1. Start with High-Level Structure
   → mcp__serena__get_symbols_overview()
   → Returns: All classes, functions, exports

2. Dive into Key Components
   → mcp__serena__find_symbol(depth=1)
   → Returns: Method signatures without bodies

3. Read Specific Implementations
   → mcp__serena__find_symbol(include_body=true)
   → Returns: Full method implementation

4. Trace Dependencies
   → mcp__serena__find_referencing_symbols()
   → Returns: Where this symbol is used
```

**Example Output** (in Chinese):
```
检测到架构理解需求：
"理解支付处理流程"

推荐 Serena 渐进式探索：

📋 第一步：获取支付模块结构（5分钟）
mcp__serena__get_symbols_overview({
  relative_path: "src/services/paymentService.ts"
})

预期返回：
- PaymentService 类（主类）
- processPayment 方法（核心流程）
- validateCard 方法（验证逻辑）
- recordTransaction 方法（记录）
- handleError 方法（错误处理）

🔍 第二步：查看核心流程方法签名（5分钟）
mcp__serena__find_symbol({
  name_path: "PaymentService",
  relative_path: "src/services/paymentService.ts",
  depth: 1  // 只看方法列表，不包含实现
})

预期返回：
- processPayment(amount, card): Promise<Receipt>
- validateCard(card): boolean
- recordTransaction(receipt): void
- handleError(error): ErrorResponse

💡 第三步：深入关键方法（10分钟）
mcp__serena__find_symbol({
  name_path: "PaymentService/processPayment",
  relative_path: "src/services/paymentService.ts",
  include_body: true  // 包含完整实现
})

预期返回：
- 完整方法代码
- 调用的其他方法
- 错误处理逻辑

🔗 第四步：追踪调用关系（可选，5分钟）
mcp__serena__find_referencing_symbols({
  name_path: "processPayment",
  relative_path: "src/services/paymentService.ts"
})

预期返回：
- checkout.ts 调用（第 145 行）
- subscription.ts 调用（第 78 行）
- 代码上下文片段

总耗时：20-25 分钟
Token 消耗：~3,000（vs Read 整个文件的 15,000）
提升：5x 效率 + 结构化理解
```

---

### Find All References

**Trigger Keywords**: "find all", "where is used", "references", "usages", "who calls"

**Comparison Output** (in Chinese):
```
场景：查找 processPayment 方法的所有调用

方案对比：

❌ Grep 方法：
Grep("processPayment", { output_mode: "content" })

返回：45 个匹配

问题：
- 包括注释中的提及（15 个误报）
- 包括字符串中的提及（8 个误报）
- 包括文档中的说明（6 个误报）
- 无法区分不同类的同名方法
- 无代码上下文（需要逐个打开文件查看）
- 实际调用：16 个
- 误报率：64%

✅ Serena 方法：
mcp__serena__find_referencing_symbols({
  name_path: "processPayment",
  relative_path: "src/services/paymentService.ts"
})

返回：16 个精确引用

优势：
- 理解作用域：只返回实际代码调用
- 自动排除：注释、字符串、文档
- 提供上下文：每个引用的代码片段
- 跨文件追踪：准确定位所有调用位置
- 误报率：0%

返回示例：
[
  {
    file: "src/pages/checkout.ts",
    line: 145,
    snippet: `
      const receipt = await paymentService.processPayment(
        orderTotal,
        customerCard
      )
    `,
    symbol: "CheckoutPage/handleSubmit"
  },
  {
    file: "src/services/subscription.ts",
    line: 78,
    snippet: `
      await this.paymentService.processPayment(
        subscriptionFee,
        savedCard
      )
    `,
    symbol: "SubscriptionService/renewSubscription"
  },
  ... (14 more)
]

效率对比：
- Grep：45 个匹配 → 人工过滤 → 16 个实际 → 耗时 45 分钟
- Serena：直接 16 个精确 → 耗时 2 分钟
- 提升：22x 时间节省 + 0% 误报
```

---

