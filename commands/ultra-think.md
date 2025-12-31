---
description: Deep analysis with structured reasoning and human-AI collaboration
argument-hint: [problem or decision to analyze]
---

# /ultra-think

Deep analysis for complex problems and decisions.

## Instructions

Think through this problem thoroughly and in great detail:

$ARGUMENTS

**Core guidance** (high-level, not step-by-step):
- Consider multiple approaches and show your complete reasoning
- Try different methods if your first approach doesn't work
- Challenge your own assumptions and identify blind spots
- Before concluding, verify your reasoning is sound

**Interactive collaboration**:
- If the problem is ambiguous, ask clarifying questions first
- Surface implicit requirements and hidden complexities
- Present trade-offs clearly so the user can make informed decisions

## Optional Thinking Dimensions

These are reference perspectives, not required steps. Choose what's relevant:

- **Technical**: Feasibility, scalability, security, maintainability
- **Business**: Value, cost, time-to-market, competitive advantage
- **User**: Needs, experience, edge cases, accessibility
- **System**: Integration, dependencies, emergent behaviors
- **Risk**: Failure modes, mitigation, reversibility

## Output Format (Chinese)

Use `<thinking>` for internal reasoning, then provide:

```
## 问题
[1-2 句: 核心决策 + 关键约束]

## 分析
[自主选择相关维度，深入分析]

## 方案对比
| 维度 | 方案A | 方案B |
|------|-------|-------|
[量化对比，不只是定性描述]

## 推荐
- **选择**: [方案]
- **置信度**: High/Medium/Low + 理由
- **关键假设**: [推荐依赖的假设]
- **风险**: [主要风险 + 缓解措施]

## 验证
[如何验证这个决策是正确的？测试标准是什么？]

## 下一步
[具体可执行的行动]
```

## Evidence Requirement

Per CLAUDE.md `<evidence_first>`: External claims require verification (Context7/Exa MCP). Label assertions as:
- **Fact**: Verified from official source
- **Inference**: Deduced from facts
- **Speculation**: Needs verification

