---
description: Think-Driven Interactive Discovery - Deep research with 6-dimensional analysis
argument-hint: [topic]
allowed-tools: TodoWrite, Task, Read, Write, WebSearch, WebFetch, Grep, Glob
---

# Ultra Research

Transform vague ideas into complete specifications through progressive interactive discovery.

**Philosophy**: Research is collaborative. Each decision validated with user before proceeding.

**ROI**: 85 min investment → 80-90% accuracy → 10+ hours rework avoided

---

## Pre-Research Check

1. If `specs/product.md` has [NEEDS CLARIFICATION] → Run Mode 1
2. If `specs/` doesn't exist → Suggest /ultra-init first
3. If specs 100% complete → Skip to /ultra-plan

---

## Phase 0: Project Type Detection

Use AskUserQuestion to determine research scope:

| Type | Rounds | Duration |
|------|--------|----------|
| New Project | Round 1-4 | ~80 min |
| Incremental Feature | Round 2-3 | ~30 min |
| Tech Decision | Round 3 only | ~15 min |
| Custom | User selects | Varies |

---

## Mode 1: Progressive Interactive Discovery

**When**: After /ultra-init, specs need clarification

**Structure**: 4 rounds, each following 6-step cycle

### 6-Step Cycle (Every Round)

See @config/research/6-step-template.md for detailed steps:

```
Step 1: Requirement Clarification (AskUserQuestion)
Step 2: Deep Analysis (/max-think with 6D framework)
Step 3: Analysis Validation (show summary, check satisfaction)
Step 4: Iteration Decision (satisfied → continue, else → retry)
Step 5: Generate Spec Content (Write to specs/)
Step 6: Round Satisfaction Rating (1-5 stars)
```

### Round Overview

| Round | Focus | Questions | Output |
|-------|-------|-----------|--------|
| 1: Problem Discovery | Problem space, users | Q1-5 | specs/product.md §1-2 |
| 2: Solution Exploration | MVP features, stories | Q6-8 | specs/product.md §3-5 |
| 3: Technology Selection | Tech stack, architecture | Q9-11 | specs/architecture.md |
| 4: Risk & Constraints | Risks, hard constraints | Q12-13 | Risk sections in both |

**Questions Reference**: @config/research/round-questions.md

---

## Mode 2: Focused Technology Research

**When**: Specific tech decision during development

**Duration**: 10-15 minutes

**Process**: Single-round 6D comparison, auto-update architecture.md

Delegate to ultra-research-agent for deep technical analysis.

---

## Success Criteria

**Research Complete When**:
- ✅ `specs/product.md` has NO [NEEDS CLARIFICATION] markers
- ✅ `specs/architecture.md` has justified tech decisions
- ✅ All selected rounds completed
- ✅ Research reports saved to `.ultra/docs/research/`
- ✅ Overall rating ≥4 stars, no round <3 stars

---

## Output Files

| File | Content |
|------|---------|
| `specs/product.md` | Problem, Users, Stories, Requirements, NFRs |
| `specs/architecture.md` | Tech stack with rationale |
| `.ultra/docs/research/*.md` | Round-specific analysis reports |
| `.ultra/docs/research/metadata.json` | Quality metrics |

---

## Integration

- **Think**: Each round invokes /max-think for 6D analysis
- **MCP**: Round 3 uses Context7 (docs) + Exa (code examples)
- **Next**: guiding-workflow suggests /ultra-plan when complete

---

## References

- @config/research/6-step-template.md - Detailed 6-step cycle
- @config/research/round-questions.md - All core questions
- @config/ultra-mcp-guide.md - MCP tool usage
