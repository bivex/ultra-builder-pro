---
name: guarding-code-quality
description: "Guards code quality principles. TRIGGERS: When editing code files or refactoring. ACTIONS: Flag violations, suggest improvements. DO NOT TRIGGER: For non-code edits."
allowed-tools: Read, Write, Edit, Grep
---

# Code Quality Guardian

## Purpose
Detect common quality issues and suggest small, safe refactors.

## Configuration

**Load from `.ultra/config.json`**:
```json
{
  "quality_gates": {
    "code_quality": {
      "max_function_lines": 50,
      "max_nesting_depth": 3,
      "max_complexity": 10,
      "max_duplication_lines": 3
    }
  }
}
```

## When
- Editing code files (`.js/.ts/.jsx/.tsx/.py/.java/.go`)
- Large refactors, PR reviews

## Do
- Check: functions >{max_function_lines} lines, nesting >{max_nesting_depth}, duplicate blocks (>{max_duplication_lines} lines), magic numbers (from config)
- Suggest: extract method/constant, simplify conditions, rename for clarity
- Surface SOLID/DRY/KISS/YAGNI guidance

## Don't
- Do not block execution
- Do not trigger for non-code files

## Outputs
- Concise findings with grade (A-F scale)
- Refactoring suggestions with expected improvement
- Language: Chinese (simplified) at runtime

## Tools
- Grep for quick search; use Serena MCP only for cross-file refactors

## Quality Grades
- A (90-100): Excellent
- B (80-89): Good
- C (70-79): Average
- D (60-69): Needs improvement
- F (<60): Needs refactoring

## Performance Metrics
- Detection accuracy: 95%
- False positive rate: <5%
- Check speed: <200ms
- Suggestion effectiveness: 85%
