# Architecture Design

> **Purpose**: This document defines HOW the system is built, based on requirements in `product.md`.

## System Overview

[NEEDS CLARIFICATION]
- High-level description of system architecture
- Key components and their relationships
- Data flow overview

## Architecture Principles

Inherited from `constitution.md`:
- Specification-Driven
- Test-First Development
- Minimal Abstraction
- Anti-Future-Proofing
- [Add project-specific principles]

## Technology Stack

### Frontend (if applicable)

**Decision**: [Framework/Library chosen]

**Rationale**:
- **Traces to**: [Link to specific requirement in product.md]
- **Team expertise**: [Team's familiarity with chosen technology]
- **Performance**: [How it meets performance requirements]
- **Ecosystem**: [Community support and library availability]

**Technical Details**:
- **Framework**: [Chosen framework with version]
- **State Management**: [Solution chosen and why]
- **Styling**: [Approach selected]
- **Build Tool**: [Tooling selected]

### Backend (if applicable)

**Decision**: [Technology chosen]

**Rationale**:
- **Traces to**: [Link to specific requirement in product.md]
- **Workload type**: [I/O-bound, CPU-bound, or mixed]
- **Performance**: [How it meets performance requirements]
- **Team expertise**: [Team's familiarity with chosen technology]

**Technical Details**:
- **Runtime**: [Chosen runtime environment with version]
- **Framework**: [Framework selected and why]
- **API Style**: [REST/GraphQL/gRPC chosen based on use case]
- **Database Driver**: [Client library selected]

### Smart Contracts (if applicable)

**Decision**: [Blockchain platform]

**Rationale**:
- **Traces to**: [Link to specific requirement in product.md]
- **VM Compatibility**: [EVM-compatible, Non-EVM, or other]
- **Performance**: [Transaction speed and gas fee requirements]
- **Ecosystem**: [Developer tooling and community support]

**Technical Details**:
- **Platform**: [Chosen blockchain platform]
- **Language**: [Smart contract programming language]
- **Patterns**: [Design patterns used - upgradeable, factory, access control, etc.]

### Database

**Decision**: [Database chosen]

**Rationale**:
- **Traces to**: [Link to specific requirement in product.md]
- **Data model**: [Description of data structure]
- **Scalability**: [How it meets scalability requirements]
- **Consistency**: [ACID requirements or eventual consistency needs]

**Technical Details**:
- **Type**: [Relational, Document, Key-Value, Graph, Time-series]
- **Product**: [Specific database product chosen]
- **Version**: [Version selected]
- **Deployment**: [Managed service or self-hosted]

### Infrastructure

**Decision**: [Deployment platform]

**Rationale**:
- **Traces to**: [Link to specific NFR in product.md]
- **Scalability**: [Auto-scaling requirements]
- **Reliability**: [Uptime requirements]
- **Budget**: [Cost considerations]

**Technical Details**:
- **Platform**: [Cloud provider or hosting solution]
- **Containerization**: [Container technology and orchestration]
- **CI/CD**: [Automation tooling selected]

## Component Architecture

### High-Level Components

```
[Diagram or description]

Example for web app:
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │ HTTPS
┌──────▼──────────┐
│  Load Balancer  │
└──────┬──────────┘
       │
┌──────▼──────────┐
│   API Gateway   │
└──────┬──────────┘
       │
   ┌───┴───┬───────┬────────┐
   │       │       │        │
┌──▼───┐ ┌▼────┐ ┌▼─────┐ ┌▼──────┐
│ Auth │ │User │ │Order │ │Payment│
│Service│ │Svc  │ │Svc   │ │Svc    │
└──┬───┘ └┬────┘ └┬─────┘ └┬──────┘
   │      │       │        │
   └──────┴───────┴────────┘
          │
     ┌────▼────┐
     │Database │
     └─────────┘
```

### Component Details

#### Component 1: [Name]
- **Responsibility**: [What it does]
- **Technology**: [Implementation choice]
- **Interfaces**: [APIs it exposes]
- **Dependencies**: [What it depends on]
- **Trace to**: [product.md#user-story-001]

#### Component 2: [Name]
[Continue...]

## Data Architecture

### Data Models

#### Entity 1: [Name]
```
[Schema definition]

Example:
User {
  id: UUID
  email: string (unique, indexed)
  passwordHash: string
  role: enum (admin, user)
  createdAt: timestamp
  updatedAt: timestamp
}
```

**Trace to**: [product.md#functional-requirement-001]

#### Entity 2: [Name]
[Continue...]

### Data Flow

1. **Create User Flow**:
   - Client → API Gateway → Auth Service
   - Auth Service → Hash Password → Database
   - Database → Return User → Client

**Trace to**: [product.md#user-story-002]

## API Design

### API Contracts

Location: `specs/api-contracts/`

#### REST Endpoints (if applicable)

```
POST   /api/v1/users          - Create user
GET    /api/v1/users/:id      - Get user by ID
PUT    /api/v1/users/:id      - Update user
DELETE /api/v1/users/:id      - Delete user
GET    /api/v1/users          - List users (paginated)
```

**Trace to**: [product.md#functional-requirement-auth]

#### GraphQL Schema (if applicable)

```graphql
type User {
  id: ID!
  email: String!
  role: Role!
  createdAt: DateTime!
}

type Query {
  user(id: ID!): User
  users(limit: Int, offset: Int): [User!]!
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
}
```

## Project Structure

### Frontend Structure (if applicable)

```
src/
├── domain/              # Business logic (pure functions)
│   ├── entities/       # Data models
│   └── usecases/       # Business rules
├── application/         # Use case coordination
│   └── hooks/          # React hooks / composables
├── infrastructure/      # External dependencies
│   ├── api/            # API clients
│   ├── storage/        # LocalStorage, SessionStorage
│   └── services/       # Third-party integrations
├── presentation/        # UI components
│   ├── components/     # Reusable components
│   ├── pages/          # Page components
│   └── layouts/        # Layout components
└── store/              # State management
    ├── slices/         # State slices (Redux) or stores (Zustand)
    └── index.ts        # Store configuration
```

**Rationale**: Clean Architecture separation of concerns

### Backend Structure (if applicable)

```
src/
├── controllers/         # HTTP request handlers
├── services/            # Business logic
├── repositories/        # Data access layer
├── models/              # Data models
├── middleware/          # Express/FastAPI middleware
├── utils/               # Utility functions
├── config/              # Configuration
└── types/               # TypeScript types / Python types
```

**Rationale**: Three-layer architecture (Controller → Service → Repository)

### Smart Contract Structure (if applicable)

```
contracts/
├── core/                # Core business logic
│   └── Token.sol
├── interfaces/          # Interface definitions
│   └── IToken.sol
├── libraries/           # Reusable libraries
│   └── SafeMath.sol
├── access/              # Access control
│   └── Ownable.sol
└── utils/               # Utility contracts
    └── Address.sol
```

**Rationale**: Modular design, separation of concerns

## Security Architecture

### Authentication
- Method: [JWT / OAuth2 / Session]
- Token expiry: [Duration]
- Refresh mechanism: [Yes/No, how]

**Trace to**: [product.md#nfr-security]

### Authorization
- Model: [RBAC / ABAC]
- Roles: [admin, user, guest]
- Permissions: [Define per role]

### Data Protection
- Encryption at rest: [Yes/No, method if applicable]
- Encryption in transit: [Protocol and version]
- Secret management: [Solution chosen for secrets and credentials]

## Performance Architecture

### Caching Strategy
- Client-side: [Caching mechanism chosen]
- CDN: [CDN provider if applicable]
- Server-side: [Caching solution chosen]
- Database: [Query caching approach]

**Trace to**: [product.md#nfr-performance]

### Load Balancing
- Strategy: [Round-robin / Least connections]
- Health checks: [Interval, timeout]

### Monitoring
- APM: [New Relic / DataDog / Sentry]
- Metrics: [Prometheus + Grafana]
- Logs: [ELK Stack / CloudWatch]

## Testing Strategy

### Test Pyramid
```
       /\
      /E2E\        - 10%  (Playwright)
     /------\
    /Integra\      - 30%  (API tests)
   /----------\
  /Unit Tests \    - 60%  (Jest/Pytest)
 /--------------\
```

### Test Coverage Targets
See `.ultra/config.json` for all coverage targets:
- Overall coverage
- Critical paths coverage
- Branch coverage
- Function coverage

**Trace to**: .ultra/config.json#quality_gates.test_coverage

## Deployment Architecture

### Environments
- Development: [Local / Dev server]
- Staging: [Pre-production environment]
- Production: [Live environment]

### CI/CD Pipeline
1. Code push → GitHub
2. Run tests (unit + integration)
3. Build Docker image
4. Push to registry
5. Deploy to staging (auto)
6. Manual approval for production
7. Deploy to production
8. Health check + rollback on failure

### Rollback Strategy
- **Deployment strategy**: [Blue-Green, Canary, Rolling, etc.]
- **Rollback window**: [Maximum time before automated rollback]
- **Database migrations**: [Backward compatibility approach]

## Scalability Considerations

### Horizontal Scaling
- Stateless services: [Yes/No]
- Load balancer: [Required]
- Database read replicas: [Number]

**Trace to**: [product.md#nfr-scalability]

### Vertical Scaling
- Resource limits: [CPU, Memory]
- Auto-scaling triggers: [CPU >70%, Memory >80%]

## Architecture Decisions

All major decisions documented as ADRs in `.ultra/docs/decisions/`:

1. ADR-001: Technology Stack Selection
2. ADR-002: Database Choice
3. ADR-003: [Add as you make decisions]

## Open Questions

[NEEDS CLARIFICATION]
- Question 1: [Unresolved technical question]
- Question 2: [Alternative approaches to evaluate]

---

**Document Status**: Draft | In Review | Approved
**Last Updated**: [Date]
**Reviewed By**: [Name]
