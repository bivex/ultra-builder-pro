## Complete Workflows

### Workflow 1: Refactor Large Legacy File

**Scenario**: Refactor a 8,500-line legacy monolith

**Step-by-Step**:

```
Step 1: Understand Structure (5 min)
→ mcp__serena__get_symbols_overview({
    relative_path: "src/legacy/monolith.ts"
  })
→ Result: 45 classes, 230 methods

Step 2: Identify Extraction Candidates (10 min)
→ mcp__serena__find_symbol({
    name_path: "LegacyService",
    depth: 1
  })
→ Result: Method signatures show cohesive groups

Step 3: Extract First Module (15 min)
→ mcp__serena__find_symbol({
    name_path: "LegacyService/userManagement",
    include_body: true
  })
→ Copy to new file: src/services/userService.ts

Step 4: Find All Usages (2 min)
→ mcp__serena__find_referencing_symbols({
    name_path: "userManagement",
    relative_path: "src/legacy/monolith.ts"
  })
→ Result: 18 references in 6 files

Step 5: Safe Rename/Move (5 min)
→ Update imports in 6 files
→ Test

Total: 37 minutes (vs 4-6 hours with Read+Grep+Edit)
```

---

### Workflow 2: Cross-Repository Code Migration

**Scenario**: Migrate shared utility functions to monorepo

**Step-by-Step**:

```
Step 1: Find All Utilities (Project A)
→ mcp__serena__get_symbols_overview({
    relative_path: "src/utils/index.ts"
  })

Step 2: Understand Dependencies
→ For each utility, check references:
  mcp__serena__find_referencing_symbols({...})

Step 3: Switch to Monorepo Project
→ mcp__serena__activate_project("monorepo")

Step 4: Create Shared Package
→ Create @shared/utils with migrated code

Step 5: Update All References (Project A)
→ mcp__serena__rename_symbol to update imports
  (if symbol names change)

Step 6: Record Migration
→ mcp__serena__write_memory("migration-log", `
    Migrated utilities on 2024-11-17
    - From: projectA/src/utils
    - To: @shared/utils
    - Utilities: formatDate, validateEmail, ...
  `)
```

---

