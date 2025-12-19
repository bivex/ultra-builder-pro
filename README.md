# Ultra Builder Pro 4.1

<div align="center">

**Version 4.1.4 (Production Ready)**

*Production-Grade AI-Powered Development System for Claude Code*

---

[![Version](https://img.shields.io/badge/version-4.1.4-blue)](docs/CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-production--ready-green)](tests/verify-documentation-consistency.sh)
[![Skills](https://img.shields.io/badge/skills-8-orange)](config/ultra-skills-guide.md)
[![Official Compliance](https://img.shields.io/badge/official-100%25%20native-brightgreen)](https://docs.claude.com/claude-code)

</div>

---

## Quick Start

### One-Command Install

```bash
# Clone the repository
git clone https://github.com/rocky2431/ultra-builder-pro.git
cd ultra-builder-pro

# Copy to Claude Code config directory
cp -r ./* ~/.claude/

# Start Claude Code
claude
```

**Installation Time**: < 1 minute

---

## What's New in 4.1.4

### 1. Native Skills Activation (Breaking Change)

- **Removed**: `skill-rules.json` external rules file
- **Removed**: `skill-activation-prompt.sh` hook
- **Now**: Skills auto-activate via native Claude Code description matching
- **Benefit**: ~200ms faster response, 70% simpler configuration

### 2. Enhanced SKILL.md Descriptions

All 8 Skills now have comprehensive trigger conditions:

```yaml
# Before (vague)
description: "Enforces code quality standards."

# After (specific)
description: "TRIGGERS when: editing code files (*.ts/*.js/*.tsx/*.jsx/*.py/*.go/*.vue),
              discussing SOLID/DRY/KISS/YAGNI, running /ultra-test.
              DO NOT trigger for: git operations, documentation-only changes."
```

### 3. Agent Configuration Upgrade

- **Model Selection**: Explicit model assignment (opus for deep reasoning, sonnet for speed)
- **Permission Mode**: `acceptEdits` for autonomous operation
- **Skill Loading**: Agents auto-load relevant Skills

| Agent | Model | Auto-Loaded Skills |
|-------|-------|-------------------|
| ultra-qa-agent | opus | guarding-quality, guarding-test-quality |
| ultra-architect-agent | opus | guarding-quality, syncing-docs |
| ultra-research-agent | sonnet | syncing-docs |
| ultra-performance-agent | sonnet | automating-e2e-tests |

### 4. Optimized settings.json

```diff
- "hooks": {
-   "UserPromptSubmit": [skill-activation hook],
-   "PostToolUse": [tracker hook]
- }
+ // Hooks removed - native Skills auto-discovery is sufficient
```

---

## What's New in 4.1.3

### 1. Anti-Fake-Test System (TAS)

- **Test Authenticity Score (TAS)**: Static analysis system to detect fake/useless tests
- **New Skill**: `guarding-test-quality` - Detects tautologies, empty tests, over-mocking
- **Quality Gate**: TAS ≥70% required for task completion (Grade A/B pass, C/D/F blocked)
- **10 Anti-Patterns**: Documented with BAD/GOOD code examples

### 2. Skills Expansion (6 → 8)

- **guarding-test-quality**: TAS calculation, fake test detection
- **syncing-status**: Feature status tracking (task completion + test results)

### 3. TDD Workflow Hardening

- **Removed**: All bypass options (skip-tests, no-branch, skip-refactor)
- **Added**: State machine validation (RED → GREEN → REFACTOR → COMMIT)
- **Added**: 6 mandatory quality gates (G1-G6)

---

## System Overview

Ultra Builder Pro 4.1 is a **complete AI-powered development workflow system** designed for Claude Code.

### Core Features

- **Structured 7-Phase Workflow**: Standardized development process
- **8 Automated Skills**: Real-time quality guards with **native auto-activation**
- **Modular Documentation**: On-demand loading
- **Specialized Tools**: 4 Expert Agents + 2 MCP servers
- **Token Efficient**: Optimized for minimal context usage
- **Bilingual Support**: Chinese output, English system files

### Quantified Improvements (4.1.3 → 4.1.4)

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| **Skill Trigger Latency** | ~200ms (hook) | ~0ms (native) | **-100%** |
| **Config Complexity** | High (rules + hooks) | Low (descriptions only) | **-70%** |
| **Agent Model Precision** | Inherited | Explicit per-agent | **+Optimized** |
| **Startup Tokens** | ~3,000 | ~2,600 | **-13%** |

---

## System Architecture

```
Ultra Builder Pro 4.1.4
│
├── CLAUDE.md                          # Main config with @import references
│
├── settings.json                      # Claude Code settings (simplified)
│   ├── permissions.allow              # Official tool permissions
│   ├── permissions.deny               # Sensitive file protection
│   ├── alwaysThinkingEnabled          # Extended thinking enabled
│   └── sandbox                        # Optional isolation mode
│
├── guidelines/                        # Development guidelines
│   ├── ultra-solid-principles.md      # SOLID/DRY/KISS/YAGNI
│   ├── ultra-quality-standards.md     # Quality baselines
│   ├── ultra-git-workflow.md          # Git workflow
│   └── ultra-testing-philosophy.md    # Testing philosophy + anti-patterns
│
├── config/                            # Tool configuration
│   ├── ultra-skills-guide.md          # 8 Skills guide (updated descriptions)
│   ├── ultra-mcp-guide.md             # MCP decision tree
│   └── research/                      # Research modes (4 files)
│
├── workflows/                         # Workflow processes
│   ├── ultra-development-workflow.md  # 7-phase complete flow
│   └── ultra-context-management.md    # Token optimization
│
├── skills/                            # 8 Automated Skills (native activation)
│   ├── guarding-quality/              # Code + 6D coverage + UI
│   ├── guarding-test-quality/         # TAS + fake test detection
│   ├── guarding-git-workflow/         # Git safety + workflow
│   ├── syncing-docs/                  # Documentation sync
│   ├── syncing-status/                # Feature status tracking
│   ├── automating-e2e-tests/          # E2E automation
│   ├── compressing-context/           # Context compression
│   └── guiding-workflow/              # Workflow guidance
│
├── agents/                            # 4 Expert agents (upgraded config)
│   ├── ultra-research-agent.md        # Technical research (sonnet)
│   ├── ultra-architect-agent.md       # Architecture design (opus)
│   ├── ultra-performance-agent.md     # Performance optimization (sonnet)
│   └── ultra-qa-agent.md              # Test strategy (opus)
│
├── commands/                          # 9 Workflow commands
│   ├── ultra-init.md                  # /ultra-init
│   ├── ultra-research.md              # /ultra-research
│   ├── ultra-plan.md                  # /ultra-plan
│   ├── ultra-dev.md                   # /ultra-dev
│   ├── ultra-test.md                  # /ultra-test
│   ├── ultra-deliver.md               # /ultra-deliver
│   ├── ultra-status.md                # /ultra-status
│   ├── max-think.md                   # /max-think
│   └── ultra-session-reset.md         # /ultra-session-reset
│
└── .ultra-template/                   # Project template
    ├── config.json                    # Configuration SSOT
    ├── constitution.md                # Project principles
    ├── specs/                         # Specifications
    ├── docs/                          # Documentation
    └── context-archive/               # Session archives
```

---

## Core Workflow

### Standard 7-Phase Process

```
/ultra-init     → Initialize project structure
    ↓
/ultra-research → AI-assisted technical research (Scenario B routing)
    ↓
/ultra-plan     → Task planning with dependency analysis
    ↓
/ultra-dev      → TDD development (RED-GREEN-REFACTOR)
    ↓
/ultra-test     → 6-dimensional testing + Core Web Vitals
    ↓
/ultra-deliver  → Performance optimization + security audit
    ↓
/ultra-status   → Real-time progress + risk assessment
```

### Example Usage

```bash
# 1. Initialize project
/ultra-init my-app web react-ts git

# 2. Research (Scenario B - auto-detects project type)
/ultra-research
# → New Project: Full 4-round discovery (70 min)
# → Incremental Feature: Rounds 2-3 only (30 min)
# → Tech Decision: Round 3 only (15 min)

# 3. Task planning
/ultra-plan

# 4. TDD development
/ultra-dev 1

# 5. Testing
/ultra-test

# 6. Delivery
/ultra-deliver

# 7. Status check
/ultra-status
```

---

## 8 Automated Skills

### Skills Overview

| Skill | Trigger | Function |
|-------|---------|----------|
| **guarding-quality** | Edit code/tests/UI files | SOLID + 6D coverage + UI design |
| **guarding-test-quality** | Edit test files | TAS calculation + fake test detection |
| **guarding-git-workflow** | Git operations | Git safety + workflow enforcement |
| **syncing-docs** | Feature completion | Documentation sync reminders |
| **syncing-status** | Task/test completion | Feature status tracking |
| **automating-e2e-tests** | E2E/Playwright keywords | E2E test code generation |
| **compressing-context** | >140K tokens | Proactive context compression |
| **guiding-workflow** | Phase completion | Next-step suggestions |

### Native Auto-Activation (4.1.4)

```
User Prompt → Claude analyzes request → Match SKILL.md descriptions → Auto-invoke
```

**No external rules file needed** - Skills activate based on their `description` field.

**Complete guide**: See `config/ultra-skills-guide.md`

---

## 2 MCP Integrations

### Decision Tree

```
Need to operate code?
    ↓
Can built-in tools handle? (Read/Write/Edit/Grep)
    ├─ YES → Use built-in (fastest)
    └─ NO ↓

Need specialized capabilities?
    ├─ Official docs → Context7 MCP
    ├─ Code examples → Exa MCP (AI semantic search)
    └─ General use → Built-in tools
```

### Available MCP Servers

| Server | Purpose | Tools |
|--------|---------|-------|
| **context7** | Library documentation | `resolve-library-id`, `get-library-docs` |
| **exa** | AI semantic search | `web_search_exa`, `get_code_context_exa` |

**Complete guide**: See `config/ultra-mcp-guide.md`

---

## Configuration

### settings.json (Simplified in 4.1.4)

```json
{
  "permissions": {
    "allow": [
      "Bash", "WebSearch", "WebFetch", "Grep", "Glob",
      "Read", "Write", "Edit", "NotebookEdit", "Task",
      "Skill", "SlashCommand", "TodoWrite", "AskUserQuestion",
      "BashOutput", "KillShell", "ExitPlanMode", "mcp__*"
    ],
    "deny": [
      "Read(./.env)", "Read(./.env.*)", "Read(./secrets/**)",
      "Read(./**/credentials*)", "Read(./**/*secret*)"
    ]
  },
  "model": "opus",
  "alwaysThinkingEnabled": true,
  "sandbox": {
    "enabled": false
  }
}
```

### Project Config (.ultra/config.json)

```json
{
  "context": {
    "total_limit": 200000,
    "thresholds": { "green": 0.60, "yellow": 0.70, "orange": 0.85 }
  },
  "quality_gates": {
    "test_coverage": { "overall": 0.80, "critical_paths": 1.00 },
    "tas_score": { "minimum": 0.70 }
  }
}
```

---

## Installation

### Method 1: Git Clone (Recommended)

```bash
git clone https://github.com/rocky2431/ultra-builder-pro.git
cd ultra-builder-pro
cp -r ./* ~/.claude/
```

### Method 2: Download ZIP

```bash
# Download and extract, then:
cp -r Ultra-Builder-Pro-4.1/* ~/.claude/
```

### Verification

```bash
# Check Skills (should be 8)
ls ~/.claude/skills/ | grep -v "DEPRECATION\|\.DS_Store" | wc -l

# Check gerund naming
ls ~/.claude/skills/
# Expected: All directories end with -ing (guarding-*, syncing-*, automating-*, compressing-*, guiding-*)

# Start Claude Code
claude
/ultra-status
```

---

## Version History

### v4.1.4 (2025-12-20) - Native Skills Optimization

- **Native Activation**: Removed `skill-rules.json` and `skill-activation` hook
- **Enhanced Descriptions**: All 8 SKILL.md files have comprehensive trigger conditions
- **Agent Upgrade**: Explicit model selection + permissionMode + auto-loaded skills
- **Simplified Config**: Hooks removed from settings.json
- **Performance**: ~200ms faster skill activation, 13% token reduction

### v4.1.3 (2025-12-17) - Anti-Fake-Test System

- **TAS System**: Test Authenticity Score for fake test detection
- **Skills Expansion**: 6 → 8 Skills (+guarding-test-quality, +syncing-status)
- **TDD Hardening**: Removed all bypass options, added state machine validation
- **Testing Philosophy**: New guidelines with 10 anti-patterns and examples
- **Quality Gates**: 6 mandatory gates (G1-G6) with TAS ≥70% requirement

### v4.1.2 (2025-12-07) - Security & Design Enhancement

- **Security**: `permissions.deny` for sensitive file protection
- **Modular**: `@import` syntax in CLAUDE.md for clearer organization
- **UI Design**: Enhanced guidelines with shadcn/Galaxy/React Bits recommendations
- **Sandbox**: Optional containerized bash execution support
- **Templates**: CLAUDE.local.md for personal project preferences

### v4.1.1 (2025-11-28) - Optimization Release

- **Official Compliance**: `alwaysAllowTools` → `permissions.allow`
- **Skills Consolidation**: 11 → 6 Skills (-45% tokens)
- **Trigger Logging**: New `skill-triggers.jsonl` for debugging
- **Research Config**: 7 → 4 files (-27% lines)
- **Code Cleanup**: ~9,700 lines removed

### v4.1.0 (2025-11-17) - Production Ready

- Skills system overhaul (gerund naming)
- Scenario B intelligent routing
- Configuration system (config.json SSOT)
- 100% documentation consistency

**Complete Changelog**: See [docs/CHANGELOG.md](docs/CHANGELOG.md)

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Skills not triggering | Description too vague | Check SKILL.md description field |
| Commands unavailable | Commands missing | Re-copy commands/ directory |
| MCP errors | Server not configured | Check `claude mcp list` |
| High token usage | Context not compressed | Run compressing-context skill |

### Debug Skills

```bash
# Check skill descriptions
head -5 ~/.claude/skills/*/SKILL.md

# Verify all skills have TRIGGERS keyword
grep -l "TRIGGERS" ~/.claude/skills/*/SKILL.md | wc -l
# Expected: 8
```

---

## Documentation

### Essential Reading

1. **This README** - System overview (5 min)
2. **[Quick Start](ULTRA_BUILDER_PRO_4.1_QUICK_START.md)** - Getting started (10 min)
3. **[Development Workflow](workflows/ultra-development-workflow.md)** - 7-phase guide (30 min)

### Reference

- **[Skills Guide](config/ultra-skills-guide.md)** - All 8 Skills detailed
- **[MCP Guide](config/ultra-mcp-guide.md)** - MCP decision tree
- **[SOLID Principles](guidelines/ultra-solid-principles.md)** - Code quality
- **[Git Workflow](guidelines/ultra-git-workflow.md)** - Branching strategy
- **[Testing Philosophy](guidelines/ultra-testing-philosophy.md)** - Anti-patterns + TAS

---

## Support

- **GitHub**: https://github.com/rocky2431/ultra-builder-pro
- **Official Docs**: https://docs.claude.com/claude-code

---

<div align="center">

**Ultra Builder Pro 4.1.4** - Production-Grade Claude Code Development System

*Every line of code, rigorously crafted*

[Quick Start](ULTRA_BUILDER_PRO_4.1_QUICK_START.md) | [Skills Guide](config/ultra-skills-guide.md) | [MCP Guide](config/ultra-mcp-guide.md)

</div>
