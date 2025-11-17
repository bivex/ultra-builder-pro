## Integration with ultra-research

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

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
| New Project | Round 1-4 | After all 4 rounds complete | "Research complete (4 rounds), suggest /ultra-plan" |
| Incremental Feature | Round 2-3 | After Round 2-3 complete | "Solution clear, suggest /ultra-plan" |
| Tech Decision | Round 3 | After Round 3 complete | "Tech stack determined, validate then /ultra-plan" |
| Custom Flow | User-selected | After user confirms satisfaction | "Custom workflow complete, suggest /ultra-plan" |

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
📋 Current Project Status

**Phase**: Requirements research complete (New Project workflow)

**Completed**:
✅ 4 complete research rounds (70 minutes)
✅ specs/product.md 100% complete
✅ specs/architecture.md 100% complete

**Suggested next step**: /ultra-plan

**Rationale**: Complete research for new project finished. All requirements and technical decisions clear. Ready to start task breakdown.
```

---

### Example: Tech Decision Integration

**ultra-research output** (saved to `.ultra/docs/research/2025-11-17-state-management-decision.md`):
```markdown
# State Management - Tech Decision

**Project Type**: Tech Decision
**Duration**: 15 minutes
**Rounds Completed**: 1 (Round 3 only)

## Round 3: Technology Selection

### Options Evaluated
1. Redux Toolkit
2. Zustand
3. Jotai

### Decision Matrix (6 dimensions)
- Technical Excellence: Zustand (9/10)
- Team Familiarity: Redux (8/10)
- Ecosystem Maturity: Redux (10/10)
- Learning Curve: Zustand (9/10)
- Bundle Size: Zustand (10/10)
- Strategic Alignment: Zustand (8/10)

### Final Decision
**Selected**: Zustand

**Rationale**:
- Simpler API, easier onboarding
- Smaller bundle size (3kb vs 15kb)
- Sufficient ecosystem for our needs
```

**guiding-workflow detection**:
```typescript
const projectType = "Tech Decision";  // Detected from metadata
const roundsCompleted = 1;  // Only Round 3
const architectureUpdated = true;  // specs/architecture.md updated
```

**guiding-workflow output**:
```
📋 Current Project Status

**Phase**: Technology selection complete (Tech Decision workflow)

**Completed**:
✅ Round 3: Technology Selection (15 minutes)
✅ specs/architecture.md updated with Zustand decision

**Suggested next step (2 options)**:

**Option 1** (recommended): Proceed directly to task planning
/ultra-plan

**Option 2**: Validate technology choice before planning
- Create simple PoC with Zustand (1-2 hours)
- Validate state management patterns
- Run /ultra-plan after confirmation

**Rationale**: Tech stack determined. If team is confident with Zustand, can proceed directly to planning. If first time using Zustand, recommend brief PoC validation.
```

---
