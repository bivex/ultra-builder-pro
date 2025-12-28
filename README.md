# Ultra Builder Pro 4.2

<div align="center">

**Version 4.2.0 (Production Ready)**

*Production-Grade AI-Powered Development System for Claude Code*

---

[![Version](https://img.shields.io/badge/version-4.2.0-blue)](docs/CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-production--ready-green)](tests/verify-documentation-consistency.sh)
[![Skills](https://img.shields.io/badge/skills-6-orange)](config/ultra-skills-guide.md)
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

## What's New in 4.2.0

### 1. Anthropic Prompt Engineering Compliance

All prompts rewritten following official Anthropic best practices:

- **Positive Framing**: "DO this" instead of "DON'T do that"
- **Core Principles**: 3-5 focused rules instead of exhaustive lists
- **Concrete Examples**: Real code snippets over abstract descriptions
- **Reduced Verbosity**: ultra-qa-agent reduced from 441 → 128 lines (-71%)

### 2. Intellectual Honesty Framework

New principles added to CLAUDE.md:

| Principle | Description |
|-----------|-------------|
| Challenge Assumptions | Question user conclusions directly |
| Mark Uncertainty | Distinguish Fact / Inference / Speculation |
| Actionable Output | Concrete next steps with priorities |
| Prioritize User Growth | Truth over comfort |
| Verify Before Claiming | Query official docs first |

### 3. Single Source Configuration

- **Removed**: `.ultra-template/config.json`
- **Consolidated**: All rules now in CLAUDE.md
- **Benefit**: One file to maintain, clearer ownership

### 4. Streamlined Skills (8 → 6)

Removed rarely-used skills:
- `compressing-context` (manual context management preferred)
- `automating-e2e-tests` (integrated into ultra-test workflow)

### 5. Streamlined Commands (9 → 8)

Removed:
- `ultra-session-reset` (consolidated into workflow)

### 6. Parallel Development Workflow

New git workflow supporting concurrent task development:

```
main (always deployable)
 ├── feat/task-1 ──────→ rebase → merge
 ├── feat/task-2 ──────→ rebase → merge (parallel)
 └── feat/task-3 ──────→ rebase → merge (parallel)
```

**Key Features:**
- Multiple tasks can run simultaneously
- Dependencies are soft constraints (warning only, not blocking)
- Rebase before merge ensures conflict resolution
- Each merge is atomic and independently reversible

---

## System Overview

Ultra Builder Pro 4.2 is a **complete AI-powered development workflow system** designed for Claude Code.

### Core Features

- **Structured 7-Phase Workflow**: Standardized development process
- **6 Automated Skills**: Real-time quality guards with **native auto-activation**
- **4 Expert Agents**: Specialized sub-agents for research, architecture, QA, performance
- **Modular Documentation**: On-demand loading
- **2 MCP Integrations**: Context7 (docs) + Exa (code search)
- **Bilingual Support**: Chinese output, English system files

### Quantified Improvements (4.1.4 → 4.2.0)

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| **Prompt Lines** | ~2,175 | ~898 | **-59%** |
| **Skills Count** | 8 | 6 | **-25%** |
| **Config Files** | 2 (CLAUDE.md + config.json) | 1 (CLAUDE.md) | **-50%** |
| **Agent Verbosity** | 441 lines (QA) | 128 lines | **-71%** |

---

## System Architecture

```
Ultra Builder Pro 4.2.0
│
├── CLAUDE.md                          # Single source of truth (config + principles)
│
├── settings.json                      # Claude Code settings
│   ├── permissions.allow              # Official tool permissions
│   ├── permissions.deny               # Sensitive file protection
│   └── alwaysThinkingEnabled          # Extended thinking enabled
│
├── skills/                            # 6 Automated Skills (native activation)
│   ├── guarding-quality/              # Code quality enforcement
│   ├── guarding-test-quality/         # TAS + fake test detection
│   ├── guarding-git-workflow/         # Git safety + workflow
│   ├── syncing-docs/                  # Documentation sync
│   ├── syncing-status/                # Feature status tracking
│   └── guiding-workflow/              # Workflow guidance
│
├── agents/                            # 4 Expert agents (Anthropic-compliant)
│   ├── ultra-research-agent.md        # Technical research (sonnet)
│   ├── ultra-architect-agent.md       # Architecture design (opus)
│   ├── ultra-performance-agent.md     # Performance optimization (sonnet)
│   └── ultra-qa-agent.md              # Test strategy (opus)
│
├── commands/                          # 8 Workflow commands
│   ├── ultra-init.md                  # /ultra-init
│   ├── ultra-research.md              # /ultra-research
│   ├── ultra-plan.md                  # /ultra-plan
│   ├── ultra-dev.md                   # /ultra-dev
│   ├── ultra-test.md                  # /ultra-test
│   ├── ultra-deliver.md               # /ultra-deliver
│   ├── ultra-status.md                # /ultra-status
│   └── max-think.md                   # /max-think
│
├── guidelines/                        # Development guidelines
│   ├── ultra-solid-principles.md      # SOLID/DRY/KISS/YAGNI
│   ├── ultra-quality-standards.md     # Quality baselines
│   ├── ultra-git-workflow.md          # Git workflow
│   └── ultra-testing-philosophy.md    # Testing philosophy
│
├── config/                            # Tool configuration
│   ├── ultra-skills-guide.md          # Skills guide
│   ├── ultra-mcp-guide.md             # MCP decision tree
│   └── research/                      # Research modes
│
├── workflows/                         # Workflow processes
│   └── ultra-development-workflow.md  # 7-phase complete flow
│
└── .ultra-template/                   # Project template
    ├── constitution.md                # Project principles
    ├── specs/                         # Specifications
    └── docs/                          # Documentation
```

---

## Core Workflow

### Standard 7-Phase Process

```
/ultra-init     → Initialize project structure
    ↓
/ultra-research → AI-assisted technical research
    ↓
/ultra-plan     → Task planning with dependency analysis
    ↓
/ultra-dev      → TDD development (RED-GREEN-REFACTOR)
    ↓
/ultra-test     → 6-dimensional testing
    ↓
/ultra-deliver  → Performance optimization + security audit
    ↓
/ultra-status   → Real-time progress + risk assessment
```

### Example Usage

```bash
# 1. Initialize project
/ultra-init my-app web react-ts git

# 2. Research
/ultra-research

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

## 6 Automated Skills

### Skills Overview

| Skill | Trigger | Function |
|-------|---------|----------|
| **guarding-quality** | Edit code files | SOLID + code quality enforcement |
| **guarding-test-quality** | Edit test files | TAS calculation + fake test detection |
| **guarding-git-workflow** | Git operations | Parallel workflow + conflict resolution |
| **syncing-docs** | Feature completion | Documentation sync reminders |
| **syncing-status** | Task/test completion | Feature status tracking |
| **guiding-workflow** | Phase completion | Next-step suggestions |

### Native Auto-Activation

```
User Prompt → Claude analyzes request → Match SKILL.md descriptions → Auto-invoke
```

Skills activate based on their `description` field - no external rules needed.

---

## 4 Expert Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| **ultra-research-agent** | sonnet | Technical research with evidence-based analysis |
| **ultra-architect-agent** | opus | System design with SOLID compliance scoring |
| **ultra-qa-agent** | opus | Test strategy with six-dimensional coverage |
| **ultra-performance-agent** | sonnet | Core Web Vitals optimization |

Agents are auto-delegated by Claude Code when specialized expertise is needed.

---

## 2 MCP Integrations

### Decision Tree

```
Need specialized capabilities?
    ├─ Official docs → Context7 MCP
    ├─ Code examples → Exa MCP (AI semantic search)
    └─ General use → Built-in tools (Read/Write/Edit/Grep)
```

### Available MCP Servers

| Server | Purpose | Tools |
|--------|---------|-------|
| **context7** | Library documentation | `resolve-library-id`, `get-library-docs` |
| **exa** | AI semantic search | `web_search_exa`, `get_code_context_exa` |

---

## Quality Gates

All gates defined in CLAUDE.md (single source):

| Gate | Requirement |
|------|-------------|
| TDD | RED → GREEN → REFACTOR mandatory |
| Coverage | ≥80% overall, 100% critical paths |
| TAS | ≥70% Test Authenticity Score |
| SOLID | Full compliance enforced |
| Git | Parallel branches → rebase → merge → delete |

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
cp -r Ultra-Builder-Pro-4.2/* ~/.claude/
```

### Verification

```bash
# Check Skills (should be 6)
ls ~/.claude/skills/ | wc -l

# Check Commands (should be 8)
ls ~/.claude/commands/ | wc -l

# Start Claude Code
claude
/ultra-status
```

---

## Version History

### v4.2.0 (2025-12-28) - Anthropic Compliance Release

- **Prompt Engineering**: All prompts rewritten following Anthropic best practices
- **Intellectual Honesty**: New framework for principled pushback
- **Parallel Development**: Git workflow supporting concurrent task execution
- **Single Source**: Removed config.json, consolidated to CLAUDE.md
- **Skills Reduction**: 8 → 6 Skills (-25%)
- **Agent Optimization**: -71% verbosity (QA agent 441 → 128 lines)
- **Positive Framing**: Eliminated negative instruction patterns

### v4.1.4 (2025-12-20) - Native Skills Optimization

- **Native Activation**: Removed `skill-rules.json` and `skill-activation` hook
- **Enhanced Descriptions**: All SKILL.md files have comprehensive trigger conditions
- **Agent Upgrade**: Explicit model selection + permissionMode
- **Performance**: ~200ms faster skill activation

### v4.1.3 (2025-12-17) - Anti-Fake-Test System

- **TAS System**: Test Authenticity Score for fake test detection
- **Skills Expansion**: 6 → 8 Skills
- **TDD Hardening**: Removed all bypass options

### v4.1.2 (2025-12-07) - Security & Design Enhancement

- **Security**: `permissions.deny` for sensitive file protection
- **Modular**: `@import` syntax in CLAUDE.md

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Skills not triggering | Description mismatch | Check SKILL.md description field |
| Commands unavailable | Commands missing | Re-copy commands/ directory |
| MCP errors | Server not configured | Check `claude mcp list` |

---

## Documentation

### Essential Reading

1. **This README** - System overview (5 min)
2. **[Development Workflow](workflows/ultra-development-workflow.md)** - 7-phase guide (30 min)

### Reference

- **[Skills Guide](config/ultra-skills-guide.md)** - All 6 Skills detailed
- **[MCP Guide](config/ultra-mcp-guide.md)** - MCP decision tree
- **[SOLID Principles](guidelines/ultra-solid-principles.md)** - Code quality
- **[Testing Philosophy](guidelines/ultra-testing-philosophy.md)** - Anti-patterns + TAS

---

## Support

- **GitHub**: https://github.com/rocky2431/ultra-builder-pro
- **Official Docs**: https://docs.claude.com/claude-code

---

<div align="center">

**Ultra Builder Pro 4.2.0** - Production-Grade Claude Code Development System

*Truth over comfort. Precision over confidence.*

[Skills Guide](config/ultra-skills-guide.md) | [MCP Guide](config/ultra-mcp-guide.md) | [Workflow](workflows/ultra-development-workflow.md)

</div>
