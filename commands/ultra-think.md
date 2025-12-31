---
description: Analyze decisions with structured trade-off comparison
argument-hint: [decision question]
allowed-tools: Read, Grep, Glob, WebFetch, WebSearch, TodoWrite
---

# /ultra-think - Decision Analysis

Structured analysis for technical decisions. Converges to clear recommendation.

## Workflow

### 1. Problem Clarification (1-2 sentences)
- What is the core decision?
- What constraints exist?

### 2. Dimension Selection
Pick **2-4 most relevant** dimensions (not all 6):

| Dimension | When Relevant |
|-----------|---------------|
| Technical | Architecture, performance, security involved |
| Business | Cost, timeline, ROI matters |
| Team | Skills, learning curve, velocity impact |
| Ecosystem | Dependencies, vendor lock-in, community |
| Strategic | Long-term direction, competitive positioning |
| Risk | High-stakes, irreversible, compliance |

### 3. Options Comparison (2-3 options)

| Criteria | Option A | Option B | Option C |
|----------|----------|----------|----------|
| [Dimension 1] | ... | ... | ... |
| [Dimension 2] | ... | ... | ... |
| [Dimension 3] | ... | ... | ... |

### 4. Recommendation

**推荐**: [Option]
**置信度**: High (>80%) / Medium (50-80%) / Low (<50%)
**理由**: 1-2 sentences
**风险**: Key risk + mitigation
**下一步**: `/ultra-plan` or `/ultra-dev`

---

## Output Format (Chinese)

```markdown
## 问题
[1-2 sentences: core decision + constraints]

## 分析维度
[Only relevant dimensions, not all 6]

## 方案对比
| 维度 | 方案A | 方案B |
|------|-------|-------|
| ... | ... | ... |

## 推荐
- **选择**: [Option]
- **置信度**: High/Medium/Low
- **理由**: [1-2 sentences]
- **主要风险**: [Risk + mitigation]

## 下一步
1. [Immediate action]
```

---

## Evidence Requirements

Per CLAUDE.md `<evidence_first>`:
- Technical claims → verify with Context7/Exa MCP
- Mark unverified claims as **Speculation**
- Include sources for key assertions

---

## When NOT to Use

- Simple questions → direct answer
- Implementation details → `/ultra-dev`
- Research needed → `/ultra-research`

Use `/ultra-think` only for **decisions with trade-offs**.
