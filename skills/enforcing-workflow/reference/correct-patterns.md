## Correct Workflow Patterns

### Pattern: Independent Task Branches

**Workflow**:
```
main (always active, always deployable)
 ├── feat/task-1-user-model
 │   ├── Create branch
 │   ├── Develop + TDD
 │   ├── Pass quality gates
 │   ├── Merge to main
 │   └── Delete branch
 ├── feat/task-2-user-crud
 │   ├── Create branch
 │   ├── Develop + TDD
 │   ├── Pass quality gates
 │   ├── Merge to main
 │   └── Delete branch
 └── ... (repeat for all tasks)
```

**Commands**:
```bash
# Task #1
git checkout main && git pull
git checkout -b feat/task-1-user-model
# ... develop ...
git add . && git commit -m "feat: add User model with validation"
git push origin feat/task-1-user-model
# Create PR, review, merge
git checkout main && git pull
git branch -d feat/task-1-user-model

# Task #2
git checkout -b feat/task-2-user-crud
# ... develop ...
git add . && git commit -m "feat: implement User CRUD operations"
git push origin feat/task-2-user-crud
# Create PR, review, merge
git checkout main && git pull
git branch -d feat/task-2-user-crud

# Repeat for all tasks...
```

---



---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
