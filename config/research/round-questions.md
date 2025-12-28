# Research Round Questions

Core questions for each round. Use with 6-step-template.md.

---

## Round 1: Problem Discovery

**Focus**: Understand the problem space and user context.

### Core Questions (1-5)

| # | Question | Header | Options |
|---|----------|--------|---------|
| 1 | Target User Type | "User Type" | B2C / B2B / Internal / B2D |
| 2 | Core Pain Point | "Pain Point" | Performance / Usability / Features / Cost / Reliability |
| 3 | Success Metrics | "Metrics" | User Growth / Performance / Business / Quality / Cost |
| 4 | Project Scale | "Scale" | Small / Medium / Large / Very Large |
| 5 | Time Constraints | "Timeline" | Urgent / Normal / Flexible / Long-term |

### Extension Question Examples

| Domain | Header | Options |
|--------|--------|---------|
| Healthcare | "Compliance" | HIPAA / GDPR / Local / None |
| Fintech | "Regulation" | SEC / MAS / Local / None |
| Startup | "Team Size" | 1-3 / 4-10 / 11-50 / 50+ |
| Enterprise | "Integration" | ERP / CRM / Legacy / None |

### Output Target
- `specs/product.md` Section 1-2: Problem Statement, Target Users

---

## Round 2: Solution Exploration

**Focus**: Define MVP features and user stories.

### Core Questions (6-8)

| # | Question | Header | Options |
|---|----------|--------|---------|
| 6 | MVP Feature Scope | "MVP Scope" | Core Functionality / User Management / Data Management / Integration / Analytics |
| 7 | NFR Priority | "NFR Focus" | Performance / Security / Scalability / Reliability / Accessibility |
| 8 | User Scenario Count | "Scenarios" | 1-3 / 4-6 / 7-10 / 10+ |

### Extension Question Examples

| Domain | Header | Options |
|--------|--------|---------|
| High Scale | "Data Volume" | <1TB / 1-10TB / 10-100TB / >100TB |
| Real-time | "Latency" | <50ms / 50-200ms / 200-500ms / >500ms |
| Multi-tenant | "Isolation" | Schema / Database / App-level / Physical |
| Mobile First | "Offline" | Full / Partial / Read-only / None |

### Output Target
- `specs/product.md` Section 3-5: User Stories, Requirements, NFRs

---

## Round 3: Technology Selection

**Focus**: Evaluate and justify technology choices.

### Core Questions (9-11)

| # | Question | Header | Options |
|---|----------|--------|---------|
| 9 | Tech Constraints | "Constraints" | Specific language / Framework / Cloud / Database / None |
| 10 | Team Skills | "Skills" | Frontend / Backend / DevOps / Database / Beginner |
| 11 | Performance Needs | "Performance" | Low Latency / High Throughput / Core Web Vitals / Cost Efficiency / Standard |

### Extension Question Examples

| Domain | Header | Options |
|--------|--------|---------|
| AI/ML | "Deployment" | Cloud API / Self-hosted / Edge / Hybrid |
| Blockchain | "Consensus" | PoW / PoS / PoA / BFT |
| Video | "Codec" | H.264 / H.265 / VP9 / AV1 |
| IoT | "Protocol" | MQTT / CoAP / HTTP / WebSocket |

### Output Target
- `specs/architecture.md`: Tech stack with rationale, architecture decisions

### MCP Usage
- Context7: Official library documentation
- Exa: Code examples and best practices

---

## Round 4: Risk & Constraints

**Focus**: Identify risks and hard constraints.

### Core Questions (12-13)

| # | Question | Header | Options |
|---|----------|--------|---------|
| 12 | Critical Risks | "Risks" | Technical Complexity / Time / Budget / Scalability / Security / Vendor Lock-in |
| 13 | Hard Constraints | "Constraints" | Fixed Deadline / Fixed Budget / Compliance / Technology / Team Size |

### Extension Question Examples

| Domain | Header | Options |
|--------|--------|---------|
| Regulated | "Audit Freq" | Monthly / Quarterly / Yearly / None |
| Global | "Time Zones" | Single / Regional / Global / 24/7 |
| Open Source | "License" | MIT / Apache / GPL / Proprietary |
| Critical | "Fault" | Zero-downtime / Hot-standby / Cold-standby / Best-effort |

### Output Target
- `specs/product.md`: Risk Management section
- `specs/architecture.md`: Technical Risks section

---

## Research Reports

Each round saves a report to `.ultra/docs/research/`:

| Round | Report Name |
|-------|-------------|
| 1 | `problem-analysis-{date}.md` |
| 2 | `solution-exploration-{date}.md` |
| 3 | `tech-evaluation-{date}.md` |
| 4 | `risk-assessment-{date}.md` |
