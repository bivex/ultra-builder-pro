## Mode 1: Think-Driven Interactive Discovery (Detailed)

### Round Decoupling Architecture (NEW - Scenario B Foundation)

**Architectural Principle**: Each research round is an independent, reusable function that can be executed in isolation or as part of a sequence.

**Why Decouple?**
- **Flexibility**: Old projects don't need all 4 rounds
- **Efficiency**: Tech decisions only need Round 3 (15 min vs 70 min)
- **Quality Control**: Users can repeat unsatisfactory rounds
- **Composability**: Custom research flows by mixing rounds

**Round Function Structure**:

Each round follows this pattern:

```typescript
function round_N_name(context?: RoundContext): RoundOutput {
  /**
   * @param context - Optional context from previous rounds
   * @returns Structured output for specs/product.md or specs/architecture.md
   */

  // Step 1: Auto-invoke /max-think for 6D analysis
  // Step 2: Interactive questioning with AskUserQuestion
  // Step 3: Generate structured output
  // Step 4: Save to specs/ files
  // Step 5: Satisfaction check (repeat if user unsatisfied)
  // Step 6: Return output for next round (if needed)
}
```

**Round Independence Rules**:

1. **Self-Contained**: Each round can run without previous rounds
   - Round 1: No dependencies (starts from user's vague idea)
   - Round 2: Can run standalone OR accept Round 1 context
   - Round 3: Can run standalone OR accept Round 1-2 context
   - Round 4: Can run standalone OR accept Round 1-3 context

2. **Context Passing**: Optional parameter enables chaining
   ```typescript
   // Standalone execution
   round_3_tech_selection()  // Tech decision during development

   // Chained execution
   const r1 = round_1_problem_discovery()
   const r2 = round_2_solution_exploration(r1)
   const r3 = round_3_tech_selection(r2)
   const r4 = round_4_risk_constraints(r3)
   ```

3. **Satisfaction Loop**: Each round includes retry mechanism
   ```typescript
   let satisfied = false
   while (!satisfied) {
     const output = generate_round_output()
     satisfied = ask_user_satisfaction()  // AskUserQuestion
     if (!satisfied) regenerate()
   }
   ```

**Dynamic Routing Implementation**:

Based on project type selection (Phase 0), execute only required rounds:

| Project Type | Execution Flow |
|--------------|----------------|
| **New Project** | `round_1() → round_2() → round_3() → round_4()` |
| **Incremental Feature** | `round_2() → round_3()` |
| **Tech Decision** | `round_3()` |
| **Custom Flow** | Execute user-selected rounds in order |

**Benefits**:
- **70% Time Savings** for old projects (30 min vs 70 min)
- **80% Satisfaction Rate** with retry mechanism
- **100% Flexibility** for custom research flows

---

### Phase 0: Pre-Discovery Analysis

**Automatic context detection**:
1. Check project type (from ultra-init): web/api/mobile/desktop/library
2. Check tech stack hint (from ultra-init): react-ts/vue-ts/python-fastapi/go
3. Analyze current document state:
   ```
   specs/product.md: empty | partial | complete
   specs/architecture.md: empty | partial | complete
   ```
4. Determine starting round (if partially complete, resume from incomplete section)

**Decision**:
- If specs 100% complete → Suggest `/ultra-plan`
- If specs partially complete → Resume from incomplete round
- If specs empty → Start Round 1

---

### Round 1: Problem Discovery (20 min)

**Objective**: Understand "WHY" and "WHAT" through 6-dimensional analysis

**Step 1: Auto-invoke max-think for initial analysis**

```typescript
// Internal execution (automatic)
const initialAnalysis = await Task({
  subagent_type: "max-think",
  prompt: `Analyze project from 6 dimensions:

  Project: ${projectName}
  Type: ${projectType}
  Stack: ${techStack}

  Perform preliminary analysis focusing on:
  1. Technical: What technical problem domain?
  2. Business: What business value/model?
  3. Team: What team constraints?
  4. Ecosystem: What existing solutions?
  5. Strategic: What long-term vision?
  6. Meta-level: Are we solving the right problem?

  Identify knowledge gaps for targeted questioning.`
});
```

**Step 2: Generate targeted questions based on analysis gaps**

Questions organized by 6 dimensions:

**📐 Technical Dimension**:
- What technical problem are you solving?
- What are the core technical requirements?
- What performance/scale requirements exist?

**📊 Business Dimension**:
- Who is your target customer? (B2C/SMB/Mid-market/Enterprise)
- What specific pain point do they have?
- What's the business model? (How does money flow?)
- What's the market size and competitive landscape?

**👥 Team Dimension**:
- What's your team size and expertise?
- What's the project timeline?
- What skills are available vs needed?

**🌍 Ecosystem Dimension**:
- What existing solutions are out there?
- What are users currently using?
- Why build vs buy vs integrate?

**🎯 Strategic Dimension**:
- What's your 3-year vision?
- How does this fit into broader goals?
- What's the competitive moat/differentiation?

**🔍 Meta-Level**:
- What assumptions are we making?
- Are we solving the right problem?
- What could we be missing?

**Step 3: Interactive questioning**

Ask questions one dimension at a time, collect answers, build understanding.

**Step 4: Generate specs/product.md Sections 1-2**

```markdown
## 1. Problem Statement

[Generated from Business + Technical + Meta-level dimensions]

## 2. Target Users

[Generated from Business dimension]
- Primary user persona
- Pain points
- Current alternatives
- Why existing solutions fail
```

**Step 5: Satisfaction Check (NEW - Quality Control)**

Use AskUserQuestion for standardized satisfaction check:

```typescript
// Note: At runtime, Claude will translate these to Chinese for user output
AskUserQuestion({
  questions: [{
    question: "Are you satisfied with Round 1 (Problem Discovery) output?",
    header: "Satisfaction Check",
    multiSelect: false,
    options: [
      {
        label: "Satisfied, proceed to next round",
        description: "Problem statement clear, target users identified, ready to continue"
      },
      {
        label: "Not satisfied, regenerate",
        description: "Quality insufficient, needs re-analysis and regeneration"
      },
      {
        label: "End research",
        description: "Obtained sufficient information, no need for subsequent rounds"
      }
    ]
  }]
})
```

**Action based on user choice**:
- **Satisfied** → Proceed to Round 2
- **Not satisfied** → Re-execute Round 1 with refined prompts
- **End research** → Generate partial specs and exit

**Retry mechanism**: If user chooses "Not satisfied, regenerate":
1. Ask what specifically needs improvement
2. Re-invoke max-think with refined focus
3. Regenerate specs sections
4. Check satisfaction again (loop until satisfied or user exits)

---

### Round 2: Solution Space Exploration (20 min)

**Objective**: Define "WHAT to build" with 6-dimensional constraints

**Step 1: Solution analysis based on Round 1**

```typescript
const solutionAnalysis = await Task({
  subagent_type: "max-think",
  prompt: `Based on problem analysis:
  ${round1Results}

  Generate solution exploration focusing on:
  1. Technical: What features needed?
  2. Business: What creates value?
  3. Team: What's achievable with constraints?
  4. Ecosystem: What can we integrate vs build?
  5. Strategic: What differentiates us?
  6. Meta-level: What should we NOT build?

  Generate initial user stories draft.`
});
```

**Step 2: Present auto-generated user stories**

Based on 6-dimensional analysis:
- **Technical needs** → Feature stories
- **Business value** → Value delivery stories
- **Team constraints** → Scope/phasing decisions
- **Ecosystem opportunities** → Integration stories
- **Strategic goals** → Differentiation features
- **Meta-level insights** → What NOT to build (scope control)

**Step 3: Interactive refinement**

User can:
- Approve generated stories
- Refine/modify stories
- Add missing stories
- Prioritize (P0/P1/P2/P3)

**Step 4: Define functional & non-functional requirements**

**Functional Requirements**:
- Core features (from user stories)
- Edge cases
- Business rules

**Non-Functional Requirements**:
- Performance: Response time targets
- Security: Authentication, compliance
- Scalability: Expected growth
- Reliability: Uptime targets

**Step 5: Generate specs/product.md Sections 3-5**

```markdown
## 3. User Stories

[Generated and refined from 6-dimensional analysis]

## 4. Functional Requirements

[Extracted from user stories]

## 5. Non-Functional Requirements

[Performance, Security, Scalability, Reliability]
```

**Output**: `specs/product.md` now ~80% complete

**Step 6: Satisfaction Check (NEW - Quality Control)**

```typescript
// Note: At runtime, Claude will translate these to Chinese for user output
// This follows Language Protocol: English instructions, Chinese output
AskUserQuestion({
  questions: [{
    question: "Are you satisfied with Round 2 (Solution Exploration) output?",
    header: "Satisfaction Check",
    multiSelect: false,
    options: [
      {
        label: "Satisfied, proceed to next round",
        description: "User stories complete, requirements clear, ready to continue"
      },
      {
        label: "Not satisfied, regenerate",
        description: "User stories unclear, needs re-analysis"
      },
      {
        label: "End research",
        description: "Obtained sufficient information, no need for tech selection"
      }
    ]
  }]
})
```

**Action based on user choice**:
- **Satisfied** → Proceed to Round 3
- **Not satisfied** → Re-execute Round 2 (regenerate user stories)
- **End research** → Generate partial specs and exit

---

### Round 3: Technology Selection (15 min)

**Objective**: Decide "HOW to build" with 6-dimensional evaluation

**Step 1: Technology analysis**

```typescript
const techAnalysis = await Task({
  subagent_type: "max-think",
  prompt: `Technology selection for:
  ${projectSummary}

  Requirements:
  ${extractedNFRs}

  Team constraints:
  ${teamInfo}

  Evaluate from 6 dimensions:
  1. Technical: Performance, scalability, maintainability
  2. Business: Cost (license + hosting + dev time)
  3. Team: Learning curve vs existing expertise
  4. Ecosystem: Library support, community size
  5. Strategic: Future-proofing, vendor lock-in risk
  6. Meta-level: Are we over-engineering?

  Recommend stack with justification.`
});
```

**Step 2: Auto-research with MCP tools**

For each technology layer (frontend, backend, database, infrastructure):
1. Fetch official documentation (Context7)
2. Collect community insights (Exa)
3. Get real-world examples (WebSearch)

**Step 3: Generate 6-dimensional comparison matrix**

Example output structure:
```
Frontend Framework Comparison
━━━━━━━━━━━━━━━━━━━━━━━━━━━

                    React       Vue         Svelte
Technical           9/10        8/10        7/10
Business            8/10        7/10        6/10
Team                9/10 ✅     6/10        5/10
Ecosystem           10/10       7/10        5/10
Strategic           9/10        7/10        6/10
Meta-level          8/10        8/10        9/10
━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall: React (8.8/10)

Recommendation: React with TypeScript
Rationale: Team expertise (9/10), Best ecosystem (10/10), Strong hiring pool
```

**Step 4: User confirms or requests alternatives**

Present recommendation with full 6-dimensional justification.
User can accept, request deeper analysis, or ask for alternatives.

**Step 5: Generate specs/architecture.md**

```markdown
## Technology Stack

### Frontend
**Decision**: React with TypeScript
**Rationale**: [6-dimensional justification]
**Alternatives Considered**: Vue, Svelte, Angular
**Trade-offs**: [What we gain vs what we sacrifice]

### Backend
**Decision**: Node.js with Express
**Rationale**: [6-dimensional justification]
...

### Database
**Decision**: PostgreSQL
**Rationale**: [6-dimensional justification]
...
```

**Step 6: Save research reports**

Save detailed comparison reports to `.ultra/docs/research/`:
- `YYYY-MM-DD-frontend-selection.md`
- `YYYY-MM-DD-backend-selection.md`
- `YYYY-MM-DD-database-selection.md`

**Step 7: Satisfaction Check (NEW - Quality Control)**

```typescript
// Note: At runtime, Claude will translate these to Chinese for user output
// This follows Language Protocol: English instructions, Chinese output
AskUserQuestion({
  questions: [{
    question: "Are you satisfied with Round 3 (Technology Selection) output?",
    header: "Satisfaction Check",
    multiSelect: false,
    options: [
      {
        label: "Satisfied, proceed to next round",
        description: "Tech stack decisions reasonable, architecture clear, ready to continue"
      },
      {
        label: "Not satisfied, regenerate",
        description: "Tech selection not suitable, needs re-evaluation"
      },
      {
        label: "End research",
        description: "Tech stack determined, no need for risk analysis"
      }
    ]
  }]
})
```

**Action based on user choice**:
- **Satisfied** → Proceed to Round 4
- **Not satisfied** → Re-execute Round 3 (re-evaluate tech stack)
- **End research** → Generate final specs and exit

---

### Round 4: Risk & Constraint Mapping (15 min)

**Objective**: Identify risks and constraints from 6 dimensions

**Step 1: Risk analysis**

```typescript
const riskAnalysis = await Task({
  subagent_type: "max-think",
  prompt: `Risk assessment for:
  ${projectSummary}

  Technology decisions:
  ${architectureDecisions}

  Identify risks from 6 dimensions:
  1. Technical: Complexity, performance bottlenecks
  2. Business: Budget overruns, market timing
  3. Team: Skill gaps, attrition
  4. Ecosystem: Dependency risks, vendor lock-in
  5. Strategic: Competitive threats, tech obsolescence
  6. Meta-level: Wrong problem, invalid assumptions

  For each risk: Likelihood, Impact, Mitigation strategy`
});
```

**Step 2: Interactive risk review**

Present identified risks, ask user to:
- Validate risks (are these real concerns?)
- Add missing risks
- Prioritize by likelihood × impact
- Approve mitigation strategies

**Step 3: Constraint documentation**

Collect and document:
- **Technical constraints**: Must use X, cannot use Y
- **Business constraints**: Budget, timeline, compliance
- **Resource constraints**: Team size, expertise gaps
- **External constraints**: Third-party dependencies, regulations

**Step 4: Complete both specification files**

Update `specs/product.md`:
```markdown
## 6. Constraints

- Technical: ...
- Business: ...
- Resource: ...
```

Update `specs/architecture.md`:
```markdown
## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| ... | ... | ... | ... |

## Architecture Decision Records (ADRs)

Created for major decisions:
- ADR-001: Frontend Framework Selection
- ADR-002: Database Choice
...
```

**Step 5: Final completeness validation**

Run document completeness analysis:
```typescript
const completeness = analyzeCompleteness({
  productMd: specs/product.md,
  architectureMd: specs/architecture.md
});

if (completeness.score < 100%) {
  // Identify gaps, ask follow-up questions
} else {
  // Mark research as complete
}
```

**Step 6: Satisfaction Check (NEW - Quality Control)**

```typescript
// Note: At runtime, Claude will translate these to Chinese for user output
// This follows Language Protocol: English instructions, Chinese output
AskUserQuestion({
  questions: [{
    question: "Are you satisfied with Round 4 (Risk & Constraints) output?",
    header: "Satisfaction Check",
    multiSelect: false,
    options: [
      {
        label: "Satisfied, complete research",
        description: "Risk identification complete, constraints clear, research finished"
      },
      {
        label: "Not satisfied, regenerate",
        description: "Risk analysis insufficient, needs re-evaluation"
      }
    ]
  }]
})
```

**Action based on user choice**:
- **Satisfied** → Complete research and generate final report
- **Not satisfied** → Re-execute Round 4 (re-analyze risks)

---

## Dynamic Routing Logic (NEW - Scenario B Implementation)

**Purpose**: Execute only the necessary rounds based on project type selection from Phase 0

**Implementation Pattern**:

```typescript
// Phase 0: Get project type from user
const projectType = await AskUserQuestion({ /* Project type selection */ })

// Phase 4: Route to appropriate research flow
// Note: These match the English labels from Phase 0 AskUserQuestion
switch (projectType) {
  case "New Project (from scratch)":
    executeFullResearch()  // Round 1 → 2 → 3 → 4
    break

  case "Incremental Feature (existing project)":
    executeIncrementalResearch()  // Round 2 → 3
    break

  case "Tech Decision":
    executeTechResearch()  // Round 3 only
    break

  case "Custom Flow":
    executeCustomResearch(userSelectedRounds)
    break
}
```

### Routing Functions

**1. Full Research (New Project)** - 70 minutes

```typescript
async function executeFullResearch() {
  let round1Context = null
  let round2Context = null
  let round3Context = null

  // Round 1: Problem Discovery
  do {
    round1Context = await round_1_problem_discovery()
    const satisfied = await askSatisfaction("Round 1")
    if (satisfied === "Satisfied, proceed to next round") break
    if (satisfied === "End research") return round1Context
  } while (true)

  // Round 2: Solution Exploration
  do {
    round2Context = await round_2_solution_exploration(round1Context)
    const satisfied = await askSatisfaction("Round 2")
    if (satisfied === "Satisfied, proceed to next round") break
    if (satisfied === "End research") return round2Context
  } while (true)

  // Round 3: Technology Selection
  do {
    round3Context = await round_3_tech_selection(round2Context)
    const satisfied = await askSatisfaction("Round 3")
    if (satisfied === "Satisfied, proceed to next round") break
    if (satisfied === "End research") return round3Context
  } while (true)

  // Round 4: Risk & Constraints
  do {
    const round4Context = await round_4_risk_constraints(round3Context)
    const satisfied = await askSatisfaction("Round 4")
    if (satisfied === "Satisfied, complete research") return round4Context
    // No "End research" option in Round 4
  } while (true)
}
```

**2. Incremental Research (Incremental Feature)** - 30 minutes

```typescript
async function executeIncrementalResearch() {
  let round2Context = null

  // Skip Round 1: Assume problem already understood
  // Start with Round 2: Solution Exploration
  do {
    round2Context = await round_2_solution_exploration()  // No context needed
    const satisfied = await askSatisfaction("Round 2")
    if (satisfied === "Satisfied, proceed to next round") break
    if (satisfied === "End research") return round2Context
  } while (true)

  // Round 3: Technology Selection
  do {
    const round3Context = await round_3_tech_selection(round2Context)
    const satisfied = await askSatisfaction("Round 3")
    if (satisfied === "Satisfied, proceed to next round") return round3Context
    if (satisfied === "End research") return round3Context
  } while (true)
}
```

**3. Tech Research (Tech Decision)** - 15 minutes

```typescript
async function executeTechResearch() {
  // Only Round 3: Technology Selection
  do {
    const round3Context = await round_3_tech_selection()  // No context needed
    const satisfied = await askSatisfaction("Round 3")
    if (satisfied === "Satisfied, proceed to next round") return round3Context
    if (satisfied === "End research") return round3Context
  } while (true)
}
```

**4. Custom Research (Custom Flow)** - Variable duration

```typescript
async function executeCustomResearch(selectedRounds: string[]) {
  let context = null

  // Execute selected rounds in order
  // Note: These match the English labels from Custom Flow AskUserQuestion
  for (const round of selectedRounds) {
    do {
      switch (round) {
        case "Round 1: Problem Discovery":
          context = await round_1_problem_discovery(context)
          break
        case "Round 2: Solution Exploration":
          context = await round_2_solution_exploration(context)
          break
        case "Round 3: Technology Selection":
          context = await round_3_tech_selection(context)
          break
        case "Round 4: Risk & Constraints":
          context = await round_4_risk_constraints(context)
          break
      }

      const satisfied = await askSatisfaction(round)
      if (satisfied === "Satisfied, proceed to next round/complete") break  // Move to next round
      if (satisfied === "End research") return context  // Exit early
    } while (true)
  }

  return context
}
```

### Satisfaction Check Helper

```typescript
// Note: At runtime, Claude will translate these to Chinese for user output
async function askSatisfaction(roundName: string): Promise<string> {
  const response = await AskUserQuestion({
    questions: [{
      question: `Are you satisfied with ${roundName} output?`,
      header: "Satisfaction Check",
      multiSelect: false,
      options: [
        { label: "Satisfied, proceed to next round/complete", description: "..." },
        { label: "Not satisfied, regenerate", description: "..." },
        { label: "End research", description: "..." }  // Not in Round 4
      ]
    }]
  })

  return response.answers["question1"]
}
```

### Efficiency Comparison

| Project Type | Traditional Flow | Scenario B | Time Saved | Efficiency Gain |
|--------------|------------------|------------|------------|-----------------|
| **New Project** | 70 min (4 rounds) | 70 min (4 rounds) | 0 min | 0% (but retry enabled) |
| **Incremental Feature** | 70 min (forced 4 rounds) ❌ | 30 min (2 rounds) ✅ | 40 min | 57% |
| **Tech Decision** | 70 min (forced 4 rounds) ❌ | 15 min (1 round) ✅ | 55 min | 79% |
| **Custom Flow** | 70 min (fixed flow) ❌ | Variable ✅ | Variable | Flexible |

**Key Benefits**:
- **User Control**: Exit early or repeat rounds
- **Time Efficiency**: 57-79% time savings for focused research
- **Quality Assurance**: Satisfaction checks on every round
- **Flexibility**: Custom flows for special cases

---

### Discovery Complete - Output Report

```
🔬 Ultra Research - Discovery Complete!
========================

✅ Round 1: Problem Discovery
   - Problem Statement: Complete ✅
   - Target Users: Complete ✅
   - Pain Points: Complete ✅

✅ Round 2: Solution Exploration
   - User Stories: 12 items ✅
   - Functional Requirements: Complete ✅
   - Non-Functional Requirements: Complete ✅

✅ Round 3: Technology Selection
   - Frontend: React + TypeScript ✅
   - Backend: Node.js + Express ✅
   - Database: PostgreSQL ✅
   - Infrastructure: AWS ✅

✅ Round 4: Risk & Constraints
   - Risks Identified: 8 items ✅
   - Mitigation Strategies: Complete ✅
   - Constraints Documented: Complete ✅

========================
📊 Specification Status
   - specs/product.md: 100% complete ✅
   - specs/architecture.md: 100% complete ✅
   - Research reports: 4 files saved ✅
   - Total time invested: 68 minutes

✅ Key Decisions
   1. Target: SMB bookkeeping automation
   2. Stack: React + Node + PostgreSQL
   3. Phase 1: Core features (3 months, 2 devs)
   4. Risks: 8 identified with mitigations

🚀 Next Steps
   - Run /ultra-plan to generate task breakdown

   Expected output: 15-20 tasks, ~12 weeks estimated

   Your 68-minute investment will save 10+ hours of rework! ✅
```

---
