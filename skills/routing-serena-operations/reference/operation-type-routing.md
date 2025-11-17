## Operation Type Routing

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

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

**Example Output** (for >5 files):
```
Scenario: Rename getUserById to fetchUserById

Detection Results:
- References: 78
- Files affected: 23
- Risk assessment: High (multi-file operation)

❌ Built-in Tools Method (Grep + Edit):

Steps:
1. Grep("getUserById")  # Returns 300 matches
2. Manual filtering (exclude comments, strings)
3. Edit files one by one

Problems:
- False positive rate: ~30% (includes comments, strings, same-name variables)
- Cannot distinguish same-name symbols in different scopes
- Requires manual editing of 23 files
- Expected errors: 6-8 missed or incorrect changes
- Time required: 2.5 hours

✅ Serena Semantic Method (Recommended):

mcp__serena__rename_symbol({
  name_path: "getUserById",
  relative_path: "src/services/userService.ts",
  new_name: "fetchUserById"
})

Advantages:
- Scope understanding: Only changes related symbols
- Auto-skips: Comments, strings, documentation
- Cross-file updates: Automatically handles all 78 references
- Error rate: 0% (semantic understanding)
- Time required: 5 minutes

Result:
78 references automatically updated, 23 files synchronized, 0 errors
Estimated savings: 2.4 hours + avoiding 6-8 errors

Use Serena rename_symbol?
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

**Example Output**:
```
Detected Architecture Understanding Need:
"Understand payment processing flow"

Recommended Serena Incremental Exploration:

📋 Step 1: Get Payment Module Structure (5 minutes)

mcp__serena__get_symbols_overview({
  relative_path: "src/services/paymentService.ts"
})

Expected Return:
- PaymentService class (main class)
- processPayment method (core flow)
- validateCard method (validation logic)
- recordTransaction method (recording)
- handleError method (error handling)

🔍 Step 2: View Core Method Signatures (5 minutes)

mcp__serena__find_symbol({
  name_path: "PaymentService",
  relative_path: "src/services/paymentService.ts",
  depth: 1  // Only method list, no implementation
})

Expected Return:
- processPayment(amount, card): Promise<Receipt>
- validateCard(card): boolean
- recordTransaction(receipt): void
- handleError(error): ErrorResponse

💡 Step 3: Deep Dive into Key Method (10 minutes)

mcp__serena__find_symbol({
  name_path: "PaymentService/processPayment",
  relative_path: "src/services/paymentService.ts",
  include_body: true  // Include full implementation
})

Expected Return:
- Complete method code
- Called methods
- Error handling logic

🔗 Step 4: Trace Call Relationships (Optional, 5 minutes)

mcp__serena__find_referencing_symbols({
  name_path: "processPayment",
  relative_path: "src/services/paymentService.ts"
})

Expected Return:
- checkout.ts calls it (line 145)
- subscription.ts calls it (line 78)
- Code context snippets

Total Time: 20-25 minutes
Token Consumption: ~3,000 (vs 15,000 for reading entire file with Read)
Improvement: 5x efficiency + structured understanding
```

---

### Find All References

**Trigger Keywords**: "find all", "where is used", "references", "usages", "who calls"

**Comparison Output**:
```
Scenario: Find all calls to processPayment method

Method Comparison:

❌ Grep Method:

Grep("processPayment", { output_mode: "content" })

Returns: 45 matches

Problems:
- Includes mentions in comments (15 false positives)
- Includes mentions in strings (8 false positives)
- Includes mentions in documentation (6 false positives)
- Cannot distinguish same-name methods in different classes
- No code context (need to open each file individually)
- Actual calls: 16
- False positive rate: 64%

✅ Serena Method:

mcp__serena__find_referencing_symbols({
  name_path: "processPayment",
  relative_path: "src/services/paymentService.ts"
})

Returns: 16 precise references

Advantages:
- Scope understanding: Only returns actual code calls
- Auto-excludes: Comments, strings, documentation
- Provides context: Code snippet for each reference
- Cross-file tracking: Accurately locates all call sites
- False positive rate: 0%

Example Return:
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

Efficiency Comparison:
- Grep: 45 matches → Manual filtering → 16 actual → 45 minutes
- Serena: Direct 16 precise → 2 minutes
- Improvement: 22x time savings + 0% false positives
```

---
