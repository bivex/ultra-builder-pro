## Project Scale Routing

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Large Project Detection

**Threshold**: > 100 code files

**Detection**:
```bash
find src/ -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | wc -l
```

**Suggested Workflow**:
```
Detected Large Project (150+ files)

Recommended: Use Serena project management features

🎯 1. Activate Project Context

mcp__serena__activate_project("ecommerce-platform")

Benefits:
- Multi-project development: Quick context switching
- Isolated configuration: Each project independent settings
- Knowledge accumulation: Record project-specific information

📝 2. Record Project Knowledge

mcp__serena__write_memory("coding-conventions", `
# Coding Conventions

## Code Style
- ESLint: Airbnb config
- Prettier: 2 spaces, single quotes
- TypeScript: strict mode

## Testing
- Framework: Vitest
- Coverage: ≥80%
- Naming: *.test.ts

## Architecture
- State management: Zustand
- API client: Axios + React Query
- Routing: React Router v6

## Important Decisions
- Using server components (2024-03-15)
- Deprecated Redux, migrated to Zustand (2024-02-20)
`)

📖 3. Query Project Knowledge

# When onboarding new team members or switching context
mcp__serena__read_memory("coding-conventions")

# View all recorded memories
mcp__serena__list_memories()

🔄 4. Multi-Project Workflow

# Switch to another project
mcp__serena__activate_project("admin-dashboard")

# This project's memories become immediately available
mcp__serena__read_memory("api-endpoints")

Benefits:
- Context switching: From 10 minutes → 30 seconds
- Knowledge preservation: Technical decisions, conventions, pitfalls all recorded
- Onboarding friendly: Instant onboarding knowledge base
```

---
