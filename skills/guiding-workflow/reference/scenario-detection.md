## Scenario B Project Type Detection

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Detection from Research Report

**Process**:
1. Read latest research report in `.ultra/docs/research/`
2. Look for project type metadata or keywords
3. Map to one of 4 project types

---

### Project Type Keywords

| Project Type | Keywords (English) | Indicators |
|--------------|-------------------|------------|
| **New Project** | "New Project", "from scratch", "greenfield" | All 4 rounds executed, no existing codebase |
| **Incremental Feature** | "Incremental Feature", "add to existing", "enhancement" | Round 2-3 executed, existing codebase mentioned |
| **Tech Decision** | "Tech Decision", "technology choice", "stack selection" | Only Round 3 executed, comparison analysis |
| **Custom Flow** | "Custom", "specific rounds" | User manually selected rounds |

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
  if (content.match(/New Project|from scratch|greenfield/i)) {
    return "New Project";
  }

  if (content.match(/Incremental Feature|add to existing/i)) {
    return "Incremental Feature";
  }

  if (content.match(/Tech Decision|technology choice/i)) {
    return "Tech Decision";
  }

  if (content.match(/Custom/i)) {
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

| Project Type | Detected From | Research Rounds | Next Step After Research | Rationale |
|--------------|---------------|----------------|-------------------------|-----------|
| **New Project** | "New Project" keywords OR 4 rounds completed | Round 1-4 (All) | `/ultra-plan` after all rounds | New project requires complete requirements and technical research |
| **Incremental Feature** | "Incremental Feature" keywords | Round 2-3 (Solution + Tech) | `/ultra-plan` after Round 2-3 | Existing project already has context, skip problem discovery, focus on solution |
| **Tech Decision** | "Tech Decision" keywords OR only Round 3 | Round 3 (Tech only) | Validate choice OR `/ultra-plan` | Tech stack determined, validate choice then can proceed directly to planning |
| **Custom Flow** | "Custom" keywords | User-selected rounds | Based on completed rounds | User-defined workflow, flexible suggestions based on completed rounds |

---
