# Serena Operations Router - Complete Reference

**Ultra Builder Pro 4.1** - Intelligent routing to Serena MCP for optimal efficiency and safety.

---

## Overview

This skill routes file and code operations to Serena MCP when beneficial, based on three dimensions:
1. **File size** - Large files (>5000 lines) need efficient handling
2. **Operation type** - Semantic operations require Serena's understanding
3. **Project scale** - Large codebases (>100 files) benefit from Serena memory

**Core mission**: 60x efficiency improvement, 98% success rate, zero token overflow errors.

---

## Quick Reference

### Routing Decision Tree

**File Size** (from config.file_routing.thresholds):
- `< {medium}` lines → Use Read tool
- `{medium}-{large}` lines → Suggest Serena MCP
- `> {large}` lines → ENFORCE Serena MCP (prevent overflow)

**Operation Type**:
- Cross-file rename → Serena only (30% error → 0%)
- Symbol-level operations → Serena only (scope understanding required)
- Simple text search → Built-in OK

**Project Scale**:
- `< 50` files → Built-in tools OK
- `50-100` files → Serena recommended
- `> 100` files → Serena + memory system

---

## Detailed Documentation

**Progressive disclosure**: Select topic for detailed reference.

### 1. File Size Routing
**Dimension 1: Efficient large file handling**

[View Details](./reference/file-size-routing.md)

Topics: Size detection, threshold logic, Serena command examples, efficiency comparison

---

### 2. Operation Type Routing
**Dimension 2: Semantic understanding requirements**

[View Details](./reference/operation-type-routing.md)

Topics: Cross-file rename, architecture understanding, find all references, symbol operations

---

### 3. Project Scale Routing
**Dimension 3: Multi-project management**

[View Details](./reference/project-scale-routing.md)

Topics: Project activation, memory system, knowledge archival, onboarding

---

### 4. Complete Workflows
**End-to-end routing examples**

[View Details](./reference/complete-workflows.md)

Topics: Read large file, refactor across files, understand codebase, record decisions

---

### 5. Serena Command Reference
**All available Serena MCP commands**

[View Details](./reference/serena-command-reference.md)

Topics: get_symbols_overview, find_symbol, find_referencing_symbols, rename_symbol, write_memory, read_memory

---

### 6. Safety Enforcement
**When and why operations get blocked**

[View Details](./reference/safety-enforcement.md)

Topics: File size enforcement, cross-file rename safety, symbol operation requirements

---

### 7. Performance Metrics
**Measured efficiency gains**

[View Details](./reference/performance-metrics.md)

Topics: Token savings (60x), success rate (98%), detection accuracy (100%)

---

### 8. Migration Notes
**From ultra-file-router + ultra-serena-advisor**

[View Details](./reference/migration-notes.md)

Topics: Why merged, feature consolidation, backward compatibility

---

## Configuration Integration

**Load from `.ultra/config.json`**:
```json
{
  "file_routing": {
    "thresholds": {
      "medium": 5000,
      "large": 8000
    },
    "actions": {
      "medium": "suggest_serena",
      "large": "enforce_serena"
    }
  }
}
```

All thresholds are configurable per project.

---

## Decision Algorithm

```
FUNCTION route_operation(file, operation_type):
  // Dimension 1: File Size
  file_size = check_file_size(file)
  IF file_size > config.file_routing.thresholds.large:
    ENFORCE Serena MCP
    RETURN serena_command

  ELIF file_size > config.file_routing.thresholds.medium:
    SUGGEST Serena MCP
    SHOW efficiency comparison
    AWAIT user decision

  // Dimension 2: Operation Type
  IF operation_type IN ["cross-file rename", "symbol operations"]:
    ENFORCE Serena MCP (safety requirement)
    RETURN serena_command

  // Dimension 3: Project Scale
  IF project_files > 100:
    SUGGEST Serena memory system
    RETURN memory_commands

  // Default: Built-in tools
  RETURN builtin_tool
```

---

## Token Efficiency

**Before modularization**: 824 lines in single REFERENCE.md
**After modularization**: ~170 lines main + 8 focused modules (~100-150 lines each)

**Benefit**: Load only needed sections, progressive disclosure optimizes context usage.

---

**For skill implementation details**, see `SKILL.md` (main skill file).


---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
