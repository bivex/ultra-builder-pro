---
name: automating-e2e-tests
description: "Automates E2E testing with Playwright. TRIGGERS: When user mentions E2E testing, browser automation, or UI testing. DO NOT TRIGGER: For unit, API, or backend tests."
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# Playwright Automation Skill

Browser automation and E2E testing using Playwright CLI (not Playwright MCP).

---

## When to Use This Skill

**Trigger on these keywords**:
- "E2E test", "end-to-end test"
- "browser automation"
- "Playwright test"
- "Core Web Vitals", "LCP", "INP", "CLS"
- "performance testing" (frontend)
- "UI testing", "integration testing" (frontend)

**Do NOT trigger for**:
- Unit tests (use `npm test`, `pytest` via Bash)
- API tests (use `curl`, `httpie` via Bash)
- Backend testing (use language-specific test runners)

---

## Core Principle

**Use Playwright CLI via Bash, NOT Playwright MCP.**

**Why?**
- Playwright MCP: 30 tools, ~19k tokens startup cost
- Playwright Skill: ~100 tokens startup, ~3k when activated
- **Token savings: 98.7%** (activated only 5% of time)

**Functionality**: 100% equivalent (CLI provides all MCP features)

---

## Instructions for Claude

### Step 1: Generate Test Code

**Use Write tool to create test files** (TypeScript):

```typescript
// tests/example.spec.ts
import { test, expect } from '@playwright/test';

test('user login flow', async ({ page }) => {
  // Navigate
  await page.goto('http://localhost:3000');

  // Interact
  await page.click('#login-button');
  await page.fill('#email', 'test@example.com');
  await page.fill('#password', 'SecurePass123');
  await page.press('#password', 'Enter');

  // Assert
  await expect(page.locator('#welcome-message')).toBeVisible();

  // Screenshot (optional)
  await page.screenshot({ path: 'tests/screenshots/after-login.png' });
});
```

**Key APIs**:
- `page.goto(url)` - Navigate
- `page.click(selector)` - Click element
- `page.fill(selector, value)` - Fill input
- `page.press(selector, key)` - Press key
- `expect(locator).toBeVisible()` - Assert visibility
- `expect(locator).toContainText(text)` - Assert text content

**For more patterns**: See `REFERENCE.md` (navigation, forms, multi-step flows, cross-browser, network interception, performance)

---

### Step 2: Run Tests via Bash

```bash
# Run all tests
npx playwright test

# Run specific test
npx playwright test tests/login.spec.ts

# Run in headed mode (visible browser)
npx playwright test --headed

# Run with specific browser
npx playwright test --project=chromium  # or firefox, webkit

# Debug mode
npx playwright test --debug
```

---

### Step 3: Core Web Vitals Measurement

**Use Lighthouse CLI** (not Playwright for performance):

```bash
# Measure Core Web Vitals
lighthouse http://localhost:3000 \
  --only-categories=performance \
  --output=json \
  --output-path=./lighthouse-report.json

# Parse results
cat lighthouse-report.json | jq '.audits | {
  LCP: ."largest-contentful-paint".numericValue,
  TBT: ."total-blocking-time".numericValue,
  CLS: ."cumulative-layout-shift".numericValue
}'

# Validate: LCP < 2500ms, TBT < 200ms, CLS < 0.1
```

**Why Lighthouse CLI?** Industry standard (Google official), authoritative Core Web Vitals scores.

---

## Test Code Generation Workflow

**When user requests E2E tests**:

1. **Clarify scope**: Which flows? (login, checkout, registration, etc.)
2. **Create test file**: Use Write tool with TypeScript
3. **Generate test code**: Follow patterns (navigate → interact → assert)
4. **Run tests**: `npx playwright test` via Bash
5. **Report results**: Parse output and show to user (in Chinese)

**Conversational approach** (recommended):
- User: "Create E2E test for login flow"
- Claude: Generates test code based on user description
- No need to ask for complete specifications—infer from context

---

## Integration with /ultra-test

**When /ultra-test is invoked**:

1. Check if E2E tests needed for frontend
2. Activate this Skill automatically
3. Generate tests using Write + Bash
4. Include in six-dimensional coverage report

---

## Output Format

**Report test results in Chinese**:

```
# Example output structure (in Chinese at runtime):
# - Test results summary (passed/failed count)
# - Failure details with file/line numbers
# - Suggestions for fixing issues
# See REFERENCE.md for detailed examples
```

---

## Common Issues

**Issue: Tests failing with "browser not found"**
→ Solution: `npx playwright install`

**Issue: Tests timeout**
→ Solution: Add `test.setTimeout(60000)` in test

**Issue: Need to debug**
→ Solution: `npx playwright test --debug`

**For detailed troubleshooting**: See `REFERENCE.md`

---

## Key Reminders

1. **Always use Playwright CLI** (not MCP)
2. **Generate test code with Write tool** (TypeScript)
3. **Execute with Bash** (`npx playwright test`)
4. **Use Lighthouse CLI for Core Web Vitals** (not Playwright)
5. **Report in Chinese** (user-facing output)
6. **Conversational approach**: Infer test requirements from user description
7. **Reference detailed patterns**: Use REFERENCE.md for advanced scenarios

---

**This Skill saves ~18.9k tokens per session by replacing Playwright MCP while maintaining 100% functionality through CLI.**
