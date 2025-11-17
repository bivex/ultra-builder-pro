---
description: Think-Driven Interactive Discovery - Deep research with 6-dimensional analysis
allowed-tools: TodoWrite, Task, Read, Write, WebSearch, WebFetch, Grep, Glob
---

# Ultra Research - Think-Driven Discovery Engine

## Overview

Ultra-Research is **the most critical phase** in the development workflow. It transforms vague ideas into complete, well-researched specifications through Think-powered interactive discovery.

**Key Principle**: Research is not optional - it's an investment that prevents 10+ hours of rework.

**ROI**: 70-minute investment saves 10+ hours of rework (8.3x return)

---

## Phase 0: Project Type Detection

**Purpose**: Route to optimal research flow based on project context.

**Implementation**: Interactive project type selection using AskUserQuestion tool.

**Available project types**:
1. **New Project** - Complete 4-round research (70 min)
2. **Incremental Feature** - Solution + Tech only (30 min)
3. **Tech Decision** - Tech evaluation only (15 min)
4. **Custom Flow** - User selects specific rounds

**Detailed routing logic**: See [Project Types Guide](../config/research/project-types.md)

---

## Research Modes

### Mode 1: Think-Driven Interactive Discovery (PRIMARY - Recommended)

**When**: After /ultra-init, when specs/ have [NEEDS CLARIFICATION] markers

**Duration**: 50-70 minutes (best investment you'll make)

**4-Round Process**:
1. **Round 1: Problem Discovery** (20 min) - Auto-invoke ultra-think for 6D problem analysis
2. **Round 2: Solution Exploration** (20 min) - Auto-invoke ultra-think for 6D solution analysis
3. **Round 3: Technology Selection** (15 min) - Auto-invoke ultra-think for 6D tech evaluation
4. **Round 4: Risk & Constraints** (15 min) - Auto-invoke ultra-think for 6D risk assessment

**Output**:
- ✅ `specs/product.md`: 100% complete
- ✅ `specs/architecture.md`: 100% complete
- ✅ Research reports: `.ultra/docs/research/`

**Detailed workflow**: See [Mode 1 Discovery Guide](../config/research/mode-1-discovery.md)

---

### Mode 2: Focused Technology Research (Secondary)

**When**: Specific technology decision during development

**Duration**: 10-15 minutes

**Process**: Single-round 6D comparison, auto-update architecture.md

**Detailed workflow**: See [Mode 2 Focused Guide](../config/research/mode-2-focused.md)

---

## Workflow Execution

### Pre-Research Checks

1. **Check if specs exist**:
   - If `specs/product.md` exists with [NEEDS CLARIFICATION] → Run Mode 1
   - If `specs/` doesn't exist → Suggest /ultra-init first
   - If specs are 100% complete → Skip research, suggest /ultra-plan

2. **Detect project type**: Use Phase 0 to route to optimal flow

3. **Set expectations**: Inform user of estimated duration based on project type

---

### Research Execution Flow

```
Phase 0: Project Type Detection
    ↓
Route to Rounds (based on selection)
    ↓
For each round:
  1. Auto-invoke /ultra-think for 6D analysis
  2. Interactive user questioning
  3. Generate spec content
  4. Save to specs/ and .ultra/docs/research/
    ↓
Validate completeness
    ↓
Output completion report
```

---

### Post-Research Actions

1. **Validate spec completeness**: See [Output Templates](../config/research/output-templates.md)

2. **Save research reports**:
   - Problem analysis → `.ultra/docs/research/problem-analysis-{date}.md`
   - Solution exploration → `.ultra/docs/research/solution-exploration-{date}.md`
   - Tech evaluation → `.ultra/docs/research/tech-evaluation-{date}.md`
   - Risk assessment → `.ultra/docs/research/risk-assessment-{date}.md`

3. **Trigger guiding-workflow**: Suggest next step based on project scenario

---

## Integration with Ultra-Think

**Auto-invocation**: Every research round automatically invokes /ultra-think for deep analysis.

**Think configuration**:
- Problem Discovery: 6D problem analysis (Technical, Business, Team, Ecosystem, Strategic, Meta)
- Solution Exploration: 6D solution analysis with user story generation
- Technology Selection: 6D tech comparison with auto-research (Context7, Exa MCP)
- Risk Assessment: 6D risk identification with mitigation strategies

**Output format**: /ultra-think returns structured analysis in Chinese (user-facing)

**Integration point**: Research command processes think output and generates spec sections

---

## Success Criteria

**Research Complete When**:
- ✅ `specs/product.md` exists with NO [NEEDS CLARIFICATION] markers
- ✅ `specs/architecture.md` exists with justified tech decisions
- ✅ All selected rounds completed (based on project type)
- ✅ Research reports saved to `.ultra/docs/research/`
- ✅ 100% satisfaction rate confirmed (via satisfaction check)

**Quality Gates**:
- Each spec section reviewed by user before proceeding
- Tech decisions justified with 6D comparison matrix
- Risk mitigation strategies documented
- Constraints clearly identified

---

## Output Format

**Console output** (in Chinese):
- Round completion status
- Spec file generation progress
- Research report save confirmation
- Next step suggestion (via guiding-workflow)

**File outputs**:
- `specs/product.md` (Sections 1-5: Problem, Users, Stories, Requirements, NFRs)
- `specs/architecture.md` (Tech Stack with rationale)
- `.ultra/docs/research/*.md` (4 research reports)

**Detailed templates**: See [Output Templates Guide](../config/research/output-templates.md)

---

## Philosophy: Research-First Development

**Why research is mandatory**:

1. **Cost of Rework**: 10+ hours wasted on wrong tech choices or unclear requirements
2. **Team Alignment**: Shared understanding prevents miscommunication
3. **Decision Quality**: 6D analysis ensures comprehensive evaluation
4. **Knowledge Capture**: Research reports serve as onboarding material

**Anti-pattern**: Skip research → Code → Realize wrong direction → Rewrite
**Best practice**: Research 70 min → Code confidently → Ship successfully

**ROI Calculation**:
- Research time: 70 minutes
- Rework avoided: 10+ hours
- Return: 8.3x investment

---

## References

**Official Claude Code best practices**:
- Progressive disclosure (modular research guides)
- Think-driven analysis (leverage extended thinking)
- User validation (interactive questioning throughout)

**Ultra Builder Pro workflows**:
- @workflows/ultra-development-workflow.md - Complete workflow sequence
- @guidelines/ultra-solid-principles.md - Architecture evaluation criteria
- @config/ultra-mcp-guide.md - MCP tool usage (Context7, Exa for research)

---

**Next Step**: After research completes, `guiding-workflow` skill will suggest `/ultra-plan` (if specs are 100% complete).
