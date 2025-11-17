# Playwright Automation - Complete Reference

Detailed test patterns, advanced configurations, and troubleshooting for Playwright E2E testing.

**Note**: This file is loaded on-demand. The main SKILL.md contains essential instructions.

---

## Complete Test Patterns

### Pattern 1: Navigation and Interaction

```typescript
test('complete checkout flow', async ({ page }) => {
  await page.goto('http://localhost:3000/products');

  // Add to cart
  await page.click('button[data-product-id="123"]');
  await page.click('#cart-icon');

  // Checkout
  await page.click('#checkout-button');
  await page.fill('#shipping-address', '123 Main St');
  await page.fill('#payment-card', '4111111111111111');

  // Submit
  await page.click('#submit-order');

  // Verify
  await expect(page.locator('#order-confirmation')).toBeVisible();
  await expect(page.locator('#order-number')).toContainText(/ORD-\d+/);
});
```

---

### Pattern 2: Form Validation Testing

```typescript
test('validates email format', async ({ page }) => {
  await page.goto('http://localhost:3000/register');

  // Invalid email
  await page.fill('#email', 'invalid-email');
  await page.click('#submit');

  // Assert error message
  await expect(page.locator('#email-error')).toContainText('Invalid email');
  await expect(page.locator('#email-error')).toBeVisible();

  // Valid email
  await page.fill('#email', 'valid@example.com');
  await page.click('#submit');

  // Assert no error
  await expect(page.locator('#email-error')).not.toBeVisible();
});
```

**Additional validation scenarios**:
- Empty field validation
- Password strength validation
- Matching password confirmation
- Required field indicators
- Real-time validation feedback

---

### Pattern 3: Multi-Step User Flow

```typescript
test('end-to-end user journey', async ({ page }) => {
  // Step 1: Register
  await page.goto('http://localhost:3000/register');
  await page.fill('#username', 'newuser');
  await page.fill('#email', 'newuser@example.com');
  await page.fill('#password', 'SecurePass123');
  await page.click('#register-button');

  // Step 2: Verify email confirmation
  await expect(page.locator('#email-sent')).toBeVisible();
  await expect(page.locator('#email-sent')).toContainText('Check your inbox');

  // Step 3: Login
  await page.goto('http://localhost:3000/login');
  await page.fill('#email', 'newuser@example.com');
  await page.fill('#password', 'SecurePass123');
  await page.click('#login-button');

  // Step 4: Update profile
  await page.goto('http://localhost:3000/profile');
  await page.fill('#bio', 'This is my bio');
  await page.fill('#location', 'San Francisco');
  await page.click('#save-profile');

  // Verify
  await expect(page.locator('#success-message')).toContainText('Profile updated');

  // Step 5: Verify profile data persists
  await page.reload();
  await expect(page.locator('#bio')).toHaveValue('This is my bio');
});
```

---

### Pattern 4: Cross-Browser Testing

**Command-line approach**:
```bash
# Test on all browsers in parallel
npx playwright test --project=chromium --project=firefox --project=webkit

# Test on specific browser
npx playwright test --project=chromium

# Generate compatibility report
npx playwright test --reporter=html
npx playwright show-report
```

**Configuration approach** (`playwright.config.ts`):
```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  // Test directory
  testDir: './tests',

  // Maximum time one test can run
  timeout: 30000,

  // Test configuration
  use: {
    // Base URL
    baseURL: 'http://localhost:3000',

    // Browser options
    headless: true,
    viewport: { width: 1280, height: 720 },
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  // Multiple browser projects
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 12'] },
    },
    {
      name: 'tablet',
      use: { ...devices['iPad Pro'] },
    },
  ],

  // Web server configuration (optional)
  webServer: {
    command: 'npm run start',
    port: 3000,
    reuseExistingServer: !process.env.CI,
  },
});
```

---

### Pattern 5: Network Interception

**Mock API responses**:
```typescript
test('handles API errors gracefully', async ({ page }) => {
  // Intercept API call and simulate error
  await page.route('**/api/users', route => {
    route.fulfill({
      status: 500,
      contentType: 'application/json',
      body: JSON.stringify({ error: 'Internal Server Error' })
    });
  });

  await page.goto('http://localhost:3000/users');

  // Verify error handling
  await expect(page.locator('#error-message')).toContainText('Failed to load users');
  await expect(page.locator('#retry-button')).toBeVisible();
});
```

**Mock successful responses**:
```typescript
test('displays user data correctly', async ({ page }) => {
  // Mock successful API response
  await page.route('**/api/users', route => {
    route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        users: [
          { id: 1, name: 'Alice', email: 'alice@example.com' },
          { id: 2, name: 'Bob', email: 'bob@example.com' }
        ]
      })
    });
  });

  await page.goto('http://localhost:3000/users');

  // Verify UI displays mocked data
  await expect(page.locator('text=Alice')).toBeVisible();
  await expect(page.locator('text=Bob')).toBeVisible();
});
```

**Intercept and modify requests**:
```typescript
test('can modify request headers', async ({ page }) => {
  await page.route('**/api/**', route => {
    const headers = {
      ...route.request().headers(),
      'Authorization': 'Bearer test-token',
      'X-Custom-Header': 'custom-value'
    };
    route.continue({ headers });
  });

  await page.goto('http://localhost:3000/dashboard');
});
```

---

### Pattern 6: Performance Testing

**Load time measurement**:
```typescript
test('loads page within 3 seconds', async ({ page }) => {
  const startTime = Date.now();

  await page.goto('http://localhost:3000');
  await page.waitForLoadState('networkidle');

  const loadTime = Date.now() - startTime;
  expect(loadTime).toBeLessThan(3000);

  console.log(`Page load time: ${loadTime}ms`);
});
```

**Resource timing**:
```typescript
test('tracks resource loading performance', async ({ page }) => {
  await page.goto('http://localhost:3000');

  const performanceTimings = await page.evaluate(() => {
    const navigation = performance.getEntriesByType('navigation')[0];
    return {
      dns: navigation.domainLookupEnd - navigation.domainLookupStart,
      tcp: navigation.connectEnd - navigation.connectStart,
      request: navigation.responseStart - navigation.requestStart,
      response: navigation.responseEnd - navigation.responseStart,
      domParsing: navigation.domComplete - navigation.domInteractive,
      totalTime: navigation.loadEventEnd - navigation.fetchStart
    };
  });

  console.log('Performance timings:', performanceTimings);

  // Assert performance budgets
  expect(performanceTimings.totalTime).toBeLessThan(5000);
  expect(performanceTimings.request).toBeLessThan(500);
});
```

**Memory leak detection**:
```typescript
test('no memory leaks after interactions', async ({ page }) => {
  await page.goto('http://localhost:3000');

  // Get initial memory usage
  const initialMemory = await page.evaluate(() => {
    if (performance.memory) {
      return performance.memory.usedJSHeapSize;
    }
    return 0;
  });

  // Perform 100 interactions
  for (let i = 0; i < 100; i++) {
    await page.click('#open-modal');
    await page.click('#close-modal');
  }

  // Get final memory usage
  const finalMemory = await page.evaluate(() => {
    if (performance.memory) {
      return performance.memory.usedJSHeapSize;
    }
    return 0;
  });

  // Memory growth should be less than 10MB
  const memoryGrowth = finalMemory - initialMemory;
  expect(memoryGrowth).toBeLessThan(10 * 1024 * 1024);
});
```

---

## Advanced: CI/CD Integration

### GitHub Actions

**Complete workflow** (`.github/workflows/e2e.yml`):
```yaml
name: E2E Tests
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest
    strategy:
      matrix:
        browser: [chromium, firefox, webkit]

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps ${{ matrix.browser }}

      - name: Run E2E tests
        run: npx playwright test --project=${{ matrix.browser }}
        env:
          CI: true

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report-${{ matrix.browser }}
          path: playwright-report/
          retention-days: 30

      - name: Upload screenshots
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: screenshots-${{ matrix.browser }}
          path: test-results/
          retention-days: 7
```

### GitLab CI

**`.gitlab-ci.yml`**:
```yaml
image: mcr.microsoft.com/playwright:v1.40.0-focal

stages:
  - test

e2e-tests:
  stage: test
  script:
    - npm ci
    - npx playwright test
  artifacts:
    when: always
    paths:
      - playwright-report/
      - test-results/
    expire_in: 1 week
  only:
    - merge_requests
    - main
```

---

## Detailed Troubleshooting

### Issue: Browser not found

**Symptoms**:
```
browserType.launch: Executable doesn't exist at /path/to/chromium
```

**Solutions**:
```bash
# Install all browsers
npx playwright install

# Install specific browser
npx playwright install chromium

# Install with system dependencies (Linux)
npx playwright install --with-deps
```

---

### Issue: Tests timeout

**Symptoms**:
```
Test timeout of 30000ms exceeded
```

**Solutions**:

1. **Increase timeout for specific test**:
```typescript
test('slow operation', async ({ page }) => {
  test.setTimeout(60000); // 60 seconds
  await page.goto('http://localhost:3000/slow-page');
});
```

2. **Increase global timeout** (`playwright.config.ts`):
```typescript
export default defineConfig({
  timeout: 60000, // 60 seconds for all tests
  expect: {
    timeout: 10000 // 10 seconds for assertions
  }
});
```

3. **Wait for specific conditions**:
```typescript
// Wait for network to be idle
await page.waitForLoadState('networkidle');

// Wait for specific element
await page.waitForSelector('#content', { timeout: 60000 });

// Wait for URL change
await page.waitForURL('**/dashboard');
```

---

### Issue: Flaky tests

**Causes and solutions**:

1. **Race conditions**:
```typescript
// ❌ Bad: Assuming element is immediately available
await page.click('#button');

// ✅ Good: Wait for element to be actionable
await page.locator('#button').click(); // Auto-waits
```

2. **Network timing**:
```typescript
// ❌ Bad: Fixed wait times
await page.waitForTimeout(2000);

// ✅ Good: Wait for network or specific state
await page.waitForLoadState('networkidle');
await page.waitForResponse('**/api/data');
```

3. **Animation interference**:
```typescript
// Disable animations globally
await page.addStyleTag({
  content: `
    *, *::before, *::after {
      animation-duration: 0s !important;
      transition-duration: 0s !important;
    }
  `
});
```

---

### Issue: Element not found

**Symptoms**:
```
Timeout 30000ms exceeded waiting for selector "#element"
```

**Debugging steps**:

1. **Take screenshot**:
```typescript
await page.screenshot({ path: 'debug.png', fullPage: true });
```

2. **Inspect page HTML**:
```typescript
const html = await page.content();
console.log(html);
```

3. **Use less strict selector**:
```typescript
// Instead of exact ID
await page.click('#submit-button');

// Try text content
await page.click('text=Submit');

// Try role-based selector
await page.click('role=button[name="Submit"]');
```

4. **Wait for element**:
```typescript
await page.waitForSelector('#element', { state: 'visible' });
await page.click('#element');
```

---

### Issue: Authentication state

**Problem**: Need to test authenticated pages

**Solution 1: Reuse authentication state**:
```typescript
// global-setup.ts
import { chromium } from '@playwright/test';

async function globalSetup() {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  // Perform login
  await page.goto('http://localhost:3000/login');
  await page.fill('#email', 'test@example.com');
  await page.fill('#password', 'password');
  await page.click('#login-button');

  // Save authentication state
  await page.context().storageState({ path: 'auth.json' });
  await browser.close();
}

export default globalSetup;
```

**Use saved state in tests**:
```typescript
// playwright.config.ts
export default defineConfig({
  globalSetup: require.resolve('./global-setup'),
  use: {
    storageState: 'auth.json'
  }
});
```

**Solution 2: Login before each test**:
```typescript
test.beforeEach(async ({ page }) => {
  await page.goto('http://localhost:3000/login');
  await page.fill('#email', 'test@example.com');
  await page.fill('#password', 'password');
  await page.click('#login-button');
  await page.waitForURL('**/dashboard');
});

test('can access protected page', async ({ page }) => {
  await page.goto('http://localhost:3000/protected');
  // Test authenticated features
});
```

---

### Issue: Debugging failed tests

**Tools and techniques**:

1. **Playwright Inspector**:
```bash
# Run single test with inspector
npx playwright test --debug

# Debug specific test
npx playwright test tests/login.spec.ts:10 --debug
```

2. **Slow motion mode**:
```bash
# Run with 1 second delay between actions
npx playwright test --headed --slowmo=1000
```

3. **Trace viewer**:
```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    trace: 'on-first-retry', // or 'on', 'off', 'retain-on-failure'
  }
});
```

```bash
# View trace file
npx playwright show-trace trace.zip
```

4. **Video recording**:
```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    video: 'on-first-retry', // or 'on', 'off', 'retain-on-failure'
  }
});
```

---

## Performance Optimization Tips

1. **Parallelize tests**:
```typescript
// playwright.config.ts
export default defineConfig({
  workers: process.env.CI ? 1 : undefined, // Max workers locally, single in CI
});
```

2. **Reuse browser contexts**:
```typescript
// Reuse context for multiple tests
const browser = await chromium.launch();
const context = await browser.newContext();
// Use same context for related tests
```

3. **Optimize selectors**:
```typescript
// ❌ Slow: Complex CSS selector
await page.click('div > ul > li:nth-child(3) > button.submit');

// ✅ Fast: Simple, unique selector
await page.click('#submit-button');

// ✅ Fast: Role-based selector
await page.click('role=button[name="Submit"]');
```

4. **Minimize waits**:
```typescript
// ❌ Avoid arbitrary waits
await page.waitForTimeout(5000);

// ✅ Use specific conditions
await page.waitForLoadState('networkidle');
await page.waitForSelector('#content');
```

---

**This reference provides comprehensive examples and troubleshooting. Consult as needed for advanced scenarios.**
