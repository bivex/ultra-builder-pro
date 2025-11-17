## Integration with ultra-research

### How guiding-workflow Uses Research Output

**Step 1**: After `/ultra-research` completes, it saves report to `.ultra/docs/research/`

**Step 2**: guiding-workflow detects research completion:
```typescript
const researchFiles = await glob(".ultra/docs/research/*.md");
if (researchFiles.length > 0) {
  const latestReport = researchFiles[researchFiles.length - 1];
  // ...
}
```

**Step 3**: guiding-workflow reads latest report and extracts project type:
```typescript
const reportContent = await read(latestReport);
const projectType = detectProjectType(reportContent);
```

**Step 4**: guiding-workflow adapts next-step suggestion based on project type:

| Project Type | Detected Rounds | Next Step Timing | Suggestion |
|--------------|----------------|------------------|------------|
| New Project | Round 1-4 | After all 4 rounds complete | "研究完成（4 轮），建议 /ultra-plan" |
| Incremental Feature | Round 2-3 | After Round 2-3 complete | "解决方案明确，建议 /ultra-plan" |
| Tech Decision | Round 3 | After Round 3 complete | "技术栈确定，验证后可 /ultra-plan" |
| Custom Flow | User-selected | After user confirms satisfaction | "自定义流程完成，建议 /ultra-plan" |

---

### Example: New Project Integration

**ultra-research output** (saved to `.ultra/docs/research/2025-11-17-e-commerce-research.md`):
```markdown
# E-commerce Platform - Research Report

**Project Type**: New Project
**Duration**: 70 minutes
**Rounds Completed**: 4

## Round 1: Problem Discovery
- Target users: Small business owners
- Pain point: High platform fees (15-20%)
...

## Round 2: Solution Exploration
- User stories: 15 core stories
...

## Round 3: Technology Selection
- Stack: Next.js 14, TypeScript, PostgreSQL, Stripe
...

## Round 4: Risk & Constraint Mapping
- Risks: PCI compliance, scalability
...
```

**guiding-workflow detection**:
```typescript
const projectType = "New Project";  // Detected from metadata
const roundsCompleted = 4;
const specsComplete = true;  // specs/ files complete
```

**guiding-workflow output**:
```
📋 当前项目状态

**阶段**：需求研究完成（New Project 流程）

**已完成**：
✅ 4 轮完整研究（70 分钟）
✅ specs/product.md 100% 完成
✅ specs/architecture.md 100% 完成

**建议下一步**：/ultra-plan

**原因**：新项目的完整研究已完成，所有需求和技术决策已明确，可以开始任务拆分。
```

---

### Example: Tech Decision Integration

**ultra-research output** (saved to `.ultra/docs/research/2025-11-17-state-management-decision.md`):
```markdown
# State Management - Tech Decision

**Project Type**: Tech Decision
**Duration**: 15 minutes
**Rounds Completed**: 1 (Round 3 only)

