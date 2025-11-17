## Trigger Detection Patterns

### Pattern Recognition

The guardian scans for keywords and phrases that indicate AI is about to suggest workflow alternatives:

```typescript
interface TriggerPatterns {
  workflowOptions: RegExp[];     // "Option 1", "Workflow A", "You can choose"
  unifiedBranch: RegExp[];       // "unified branch", "feature branch for multiple tasks"
  delayedMerge: RegExp[];        // "merge when all done", "batch merge"
  mainFreeze: RegExp[];          // "freeze main", "wait for deployment"
  alternatives: RegExp[];        // "alternative", "another approach"
}
```

---

### Trigger Pattern 1: Workflow Options

**Keyword patterns**:
```typescript
const optionPatterns = [
  /option\s+\d+/i,                    // "Option 1", "Option 2"
  /workflow\s+[A-Z]/i,                // "Workflow A", "Workflow B"
  /approach\s+\d+/i,                  // "Approach 1", "Approach 2"
  /you\s+can\s+choose/i,              // "You can choose"
  /two\s+ways/i,                      // "There are two ways"
  /multiple\s+strategies/i,           // "Multiple strategies"
];
```

**Example triggers**:
- "There are two workflow options..."
- "You can choose between Option 1 and Option 2..."
- "Workflow A: Unified branch, Workflow B: Independent branches"

---

### Trigger Pattern 2: Unified Branch Suggestions

**Keyword patterns**:
```typescript
const unifiedPatterns = [
  /unified\s+branch/i,
  /single\s+feature\s+branch/i,
  /one\s+branch\s+for\s+(all|multiple)/i,
  /feature\s+branch\s+containing\s+multiple/i,
  /long-lived\s+branch/i,
];
```

**Example triggers**:
- "Create a unified feature branch for all 31 tasks..."
- "Use a single feature branch containing multiple tasks..."
- "Create a long-lived branch for the entire feature set..."

---

### Trigger Pattern 3: Delayed Merge Suggestions

**Keyword patterns**:
```typescript
const delayedMergePatterns = [
  /merge\s+when\s+(all|everything|tasks)\s+(complete|done|finished)/i,
  /batch\s+merge/i,
  /merge\s+all\s+at\s+once/i,
  /wait\s+(for|until).*merge/i,
  /merge\s+after\s+all\s+\d+\s+tasks/i,
];
```

**Example triggers**:
- "Merge to main when all 31 tasks are complete..."
- "Use batch merge after all tasks done..."
- "Wait for all tasks to finish before merging..."

---

### Trigger Pattern 4: Main Branch Freeze Suggestions

**Keyword patterns**:
```typescript
const freezePatterns = [
  /freeze\s+main/i,
  /lock\s+main\s+branch/i,
  /main\s+branch.*deployment/i,
  /wait\s+for\s+deployment/i,
  /deploy\s+all\s+together/i,
];
```

**Example triggers**:
- "Freeze main branch until deployment..."
- "Wait for deployment window to merge all changes..."
- "Deploy all 31 tasks together..."

---

### Detection Logic

```typescript
function shouldBlockWorkflowSuggestion(text: string): boolean {
  // 1. Check for workflow options
  for (const pattern of optionPatterns) {
    if (pattern.test(text)) {
      return true;  // BLOCK: Suggesting alternatives
    }
  }

  // 2. Check for unified branch
  for (const pattern of unifiedPatterns) {
    if (pattern.test(text)) {
      return true;  // BLOCK: Unified branch violates workflow
    }
  }

  // 3. Check for delayed merge
  for (const pattern of delayedMergePatterns) {
    if (pattern.test(text)) {
      return true;  // BLOCK: Delayed merge violates workflow
    }
  }

  // 4. Check for main freeze
  for (const pattern of freezePatterns) {
    if (pattern.test(text)) {
      return true;  // BLOCK: Main freeze violates workflow
    }
  }

  return false;  // Safe to proceed
}
```

---

