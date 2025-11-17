## Filesystem Detection Signals

### Detection Logic

The guiding-workflow skill uses filesystem signals to determine project state:

```typescript
interface ProjectState {
  hasInit: boolean;              // .ultra/ directory exists
  hasSpecs: boolean;             // specs/ or .ultra/docs/prd.md exists
  specsComplete: boolean;        // No [NEEDS CLARIFICATION] markers
  hasResearch: boolean;          // .ultra/docs/research/*.md exists
  hasTasks: boolean;             // .ultra/tasks/tasks.json exists
  hasCode: boolean;              // git status shows modified files
  hasTests: boolean;             // *.test.* or *.spec.* files exist
  projectType?: string;          // Detected from research report
}
```

---

### Signal Detection Methods

#### Signal 1: Project Initialization

**Check**: `.ultra/` directory exists

**Command**:
```typescript
Glob(".ultra/", { pattern: "**/*" })
```

**Result**:
- If `.ultra/` exists → Project initialized
- If not → Suggest `/ultra-init`

---

#### Signal 2: Specifications Exist

**Check**: `specs/product.md` OR `.ultra/docs/prd.md` exists

**Command**:
```typescript
Glob("specs/product.md")
// OR (fallback for old projects)
Glob(".ultra/docs/prd.md")
```

**Result**:
- If specs exist → Continue to completeness check
- If not → Suggest `/ultra-research`

---

#### Signal 3: Specifications Complete

**Check**: No `[NEEDS CLARIFICATION]` markers in specs

**Command**:
```typescript
Read("specs/product.md")
Read("specs/architecture.md")
```

**Detection**:
```typescript
const content = readResult.content;
const hasPlaceholders = content.includes("[NEEDS CLARIFICATION]");

if (hasPlaceholders) {
  return { specsComplete: false };
}
```

**Result**:
- If incomplete → Suggest `/ultra-research`
- If complete → Continue to task check

---

#### Signal 4: Research Reports Exist

**Check**: `.ultra/docs/research/*.md` exists

**Command**:
```typescript
Glob(".ultra/docs/research/*.md")
```

**Result**:
- If exists → Read latest report for project type detection
- If not → No Scenario B context

---

#### Signal 5: Tasks Planned

**Check**: `.ultra/tasks/tasks.json` exists

**Command**:
```typescript
Read(".ultra/tasks/tasks.json")
```

**Result**:
- If exists → Check task status
- If not → Suggest `/ultra-plan`

---

#### Signal 6: Code Changes

**Check**: `git status` shows modified files

**Command**:
```bash
git status --short
```

**Result**:
- If modified files → Dev in progress
- If clean → Ready for next phase

---

#### Signal 7: Tests Exist

**Check**: `*.test.*` or `*.spec.*` files exist

**Command**:
```typescript
Glob("**/*.test.*")
Glob("**/*.spec.*")
```

**Result**:
- If exists → Tests available
- If not → Tests needed

---

### Complete Detection Workflow

```typescript
async function detectProjectState(): ProjectState {
  // 1. Check initialization
  const hasInit = await checkPath(".ultra/");

  if (!hasInit) {
    return { phase: "uninitialized", nextCommand: "/ultra-init" };
  }

  // 2. Check specifications
  const hasNewSpecs = await checkPath("specs/product.md");
  const hasOldSpecs = await checkPath(".ultra/docs/prd.md");
  const hasSpecs = hasNewSpecs || hasOldSpecs;

  if (!hasSpecs) {
    return { phase: "no-specs", nextCommand: "/ultra-research" };
  }

  // 3. Check spec completeness
  const specsPath = hasNewSpecs ? "specs/product.md" : ".ultra/docs/prd.md";
  const specsContent = await readFile(specsPath);
  const specsComplete = !specsContent.includes("[NEEDS CLARIFICATION]");

  if (!specsComplete) {
    return { phase: "incomplete-specs", nextCommand: "/ultra-research" };
  }

  // 4. Check research reports (for Scenario B)
  const researchFiles = await glob(".ultra/docs/research/*.md");
  let projectType = null;
  if (researchFiles.length > 0) {
    const latestResearch = researchFiles[researchFiles.length - 1];
    projectType = await detectProjectType(latestResearch);
  }

  // 5. Check task plan
  const hasTasks = await checkPath(".ultra/tasks/tasks.json");

  if (!hasTasks) {
    return {
      phase: "ready-to-plan",
      nextCommand: "/ultra-plan",
      projectType
    };
  }

  // 6. Check task status
  const tasks = await readJSON(".ultra/tasks/tasks.json");
  const { pending, inProgress, completed } = analyzeTasks(tasks);

  if (pending > 0 || inProgress > 0) {
    return {
      phase: "development",
      nextCommand: "/ultra-dev",
      taskStats: { pending, inProgress, completed }
    };
  }

  // 7. All tasks done, check if tested
  const hasTests = (await glob("**/*.test.*")).length > 0;

  if (!hasTests || needsRetesting) {
    return { phase: "ready-to-test", nextCommand: "/ultra-test" };
  }

  // 8. All tested, ready to deliver
  return { phase: "ready-to-deliver", nextCommand: "/ultra-deliver" };
}
```

---



---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
