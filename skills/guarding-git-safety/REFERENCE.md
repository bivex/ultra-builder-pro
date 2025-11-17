# Git Workflow Guardian - Reference

## Git Workflow Standards Source (Single Source of Truth)

**All git workflow standards are defined in**:
- **Branch Naming**: See `@guidelines/ultra-git-workflow.md` for conventions
- **Commit Format**: See `@guidelines/ultra-git-workflow.md` for Conventional Commits standards
- **Branch Strategy**: See `@guidelines/ultra-git-workflow.md` for feature/fix/hotfix workflows
- **Git Configuration**: See `@guidelines/ultra-git-workflow.md` for setup commands

This file only contains **danger detection algorithms and confirmation flows** and does NOT duplicate workflow standards.

---

## Dangerous Operations Detection

### Force Push
```bash
git push --force origin main
```

**Risks**:
- Overwrites remote history
- Can cause data loss for collaborators
- Difficult to recover

**Safe Alternatives**:
```bash
# Use force-with-lease (checks if remote changed)
git push --force-with-lease origin feature-branch

# Or rebase and create new commits
git pull --rebase origin main
git push origin feature-branch
```

---

### Hard Reset
```bash
git reset --hard HEAD~5
```

**Risks**:
- Permanently deletes uncommitted changes
- Deletes specified commits from history
- Cannot undo without reflog

**Safe Alternatives**:
```bash
# Soft reset (keeps changes staged)
git reset --soft HEAD~5

# Mixed reset (keeps changes unstaged)
git reset --mixed HEAD~5

# Create backup branch first
git branch backup-$(date +%Y%m%d-%H%M%S)
git reset --hard HEAD~5
```

---

### Interactive Rebase
```bash
git rebase -i HEAD~10
```

**Risks**:
- Rewrites commit history
- Can cause conflicts for collaborators
- Risk of losing commits if done incorrectly

**Safe Practices**:
```bash
# Only rebase on local branches
git checkout feature-branch
git rebase -i main

# Create backup first
git branch backup-feature-branch
git rebase -i main
```

---

### Clean Untracked Files
```bash
git clean -fd
```

**Risks**:
- Permanently deletes untracked files
- Cannot recover deleted files
- May delete important local configs

**Safe Alternatives**:
```bash
# Dry run first (see what would be deleted)
git clean -fd --dry-run

# Interactive mode (confirm each file)
git clean -fdi

# Use gitignore or git stash instead
echo "local-config.json" >> .gitignore
```

---

## Confirmation Prompt Structure

**Note**: All examples below show structure in English. At runtime, output in Chinese per Language Protocol.

### Template

```
⚠️  Dangerous Operation Detected!

Operation type: [Force Push | Hard Reset | Interactive Rebase | Clean]
Impact scope: [Branch/file description]
Risk level: [High | Medium | Low]
Risk explanation: [Specific risk description]

Recommended actions:
1. [Safe alternative 1]
2. [Safe alternative 2]

To continue, enter: "continue"
To cancel, enter: "cancel"
```

### Example: Force Push Detection

```
⚠️  Dangerous Operation Detected!

Operation type: Force Push
Impact scope: origin/main branch
Risk level: High
Risk explanation:
- Will overwrite remote repository history
- May cause data loss for team members
- Difficult to recover

Recommended actions:
1. Use git push --force-with-lease instead
2. Create new branch to avoid overwriting main
3. Communicate with team before force pushing

To continue, enter: "continue"
To cancel, enter: "cancel"
```

### Example: Hard Reset Detection

```
⚠️  Dangerous Operation Detected!

Operation type: Hard Reset
Impact scope: Last 5 commits
Risk level: High
Risk explanation:
- Will permanently delete uncommitted changes
- Will delete 5 commits from history
- Cannot be undone (unless using reflog)

Recommended actions:
1. Use git reset --soft to preserve changes
2. Create backup branch: git branch backup-$(date)
3. Use git stash to save changes

To continue, enter: "continue"
To cancel, enter: "cancel"
```

---

## Smart Suggestions

### Before Commit

**Checks**:
1. Staged changes review
2. Commit message format
3. File size check (no large binaries)
4. Sensitive data check (no API keys, passwords)

**Suggested Workflow**:
```bash
# Review staged changes
git diff --staged

# Check for sensitive data
git diff --staged | grep -E 'API_KEY|PASSWORD|SECRET'

# Commit with conventional format
git commit -m "feat: add user authentication"
```

---

### Before Push

**Checks**:
1. Unpushed commits count
2. Branch up-to-date with remote
3. Tests passing (if applicable)

**Suggested Workflow**:
```bash
# Check unpushed commits
git log origin/main..HEAD

# Pull latest changes
git pull origin main

# Run tests
npm test  # or pytest, go test, etc.

# Push
git push origin feature-branch
```

---

### Before Merge

**Checks**:
1. Merge conflicts
2. Branch protection rules
3. Required reviews

**Suggested Workflow**:
```bash
# Check for conflicts
git fetch origin
git diff main...origin/main

# Update local branch
git checkout feature-branch
git rebase main

# Create pull request
gh pr create --title "feat: add feature" --body "Description"
```

---

**Branch and commit standards**: See `@guidelines/ultra-git-workflow.md` for complete conventions.

---

## Recovery Procedures

### Recover Deleted Branch

```bash
# Find deleted branch in reflog
git reflog

# Restore from reflog
git checkout -b recovered-branch <commit-hash>
```

### Recover After Hard Reset

```bash
# Find lost commits in reflog
git reflog

# Reset to previous state
git reset --hard <commit-hash>
```

### Recover After Force Push

```bash
# On affected user's machine
git reflog
git reset --hard <previous-commit-hash>
git push --force-with-lease origin main
```

---

## Best Practices

1. **Never force push to main/master**
   - Use feature branches
   - Merge via pull requests

2. **Always pull before push**
   ```bash
   git pull origin main
   git push origin feature-branch
   ```

3. **Create backup branches before risky operations**
   ```bash
   git branch backup-$(date +%Y%m%d-%H%M%S)
   git rebase main
   ```

4. **Use --force-with-lease instead of --force**
   ```bash
   git push --force-with-lease origin feature-branch
   ```

5. **Review changes before commit**
   ```bash
   git diff --staged
   git status
   ```

---

**Remember**: Git safety is about prevention, not just recovery. Always think twice before destructive operations.


---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
