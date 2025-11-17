## Scenario B Project Type Detection

### Detection from Research Report

**Process**:
1. Read latest research report in `.ultra/docs/research/`
2. Look for project type metadata or keywords
3. Map to one of 4 project types

---

### Project Type Keywords

| Project Type | Keywords (English) | Keywords (Chinese) | Indicators |
|--------------|-------------------|-------------------|------------|
| **New Project** | "New Project", "from scratch", "greenfield" | "新项目", "从零开始" | All 4 rounds executed, no existing codebase |
| **Incremental Feature** | "Incremental Feature", "add to existing", "enhancement" | "老项目增量", "现有系统", "功能增强" | Round 2-3 executed, existing codebase mentioned |
| **Tech Decision** | "Tech Decision", "technology choice", "stack selection" | "技术选型", "技术决策", "选择技术栈" | Only Round 3 executed, comparison analysis |
| **Custom Flow** | "Custom", "specific rounds" | "自定义", "自选轮次" | User manually selected rounds |

---

### Detection Code

```typescript
async function detectProjectType(researchFilePath: string): string | null {
  const content = await readFile(researchFilePath);

  // Check for explicit metadata
  const metadataMatch = content.match(/Project Type: (.+)/);
  if (metadataMatch) {
    return metadataMatch[1].trim();
  }

  // Check for keywords
  if (content.match(/New Project|新项目|from scratch|greenfield/i)) {
    return "New Project";
  }

  if (content.match(/Incremental Feature|老项目增量|add to existing/i)) {
    return "Incremental Feature";
  }

  if (content.match(/Tech Decision|技术选型|technology choice/i)) {
    return "Tech Decision";
  }

  if (content.match(/Custom|自定义/i)) {
    return "Custom Flow";
  }

  // Default: assume New Project if all 4 rounds completed
  const roundsCompleted = (content.match(/Round \d:/g) || []).length;
  if (roundsCompleted === 4) {
    return "New Project";
  }

  return null;
}
```

---

### Project Type Routing Table

| Project Type | Detected From | Research Rounds | Next Step After Research | Rationale (Chinese) |
|--------------|---------------|----------------|-------------------------|---------------------|
| **New Project** | "New Project" keywords OR 4 rounds completed | Round 1-4 (All) | `/ultra-plan` after all rounds | 全新项目需要完整的需求和技术调研 |
| **Incremental Feature** | "Incremental Feature" keywords | Round 2-3 (Solution + Tech) | `/ultra-plan` after Round 2-3 | 老项目已有背景，跳过问题发现，聚焦解决方案 |
| **Tech Decision** | "Tech Decision" keywords OR only Round 3 | Round 3 (Tech only) | Validate choice OR `/ultra-plan` | 技术栈已明确，验证选择后可直接规划 |
| **Custom Flow** | "Custom" keywords | User-selected rounds | Based on completed rounds | 用户自定义流程，根据已完成轮次灵活建议 |

---

