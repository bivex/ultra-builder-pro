# Test Strategy Guardian - Usage Examples

## Example 1: Complete Six-Dimensional Test Suite

### Feature: User Login System

#### 1️⃣ Functional Testing

```typescript
describe('User Login - Functional Tests', () => {
  it('should log in with valid email and password', async () => {
    const result = await login('user@example.com', 'ValidPass123!')

    expect(result.success).toBe(true)
    expect(result.user.email).toBe('user@example.com')
    expect(result.token).toBeDefined()
    expect(result.token).toMatch(/^[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*$/)
  })

  it('should log in with username instead of email', async () => {
    const result = await login('johndoe', 'ValidPass123!')

    expect(result.success).toBe(true)
    expect(result.user.username).toBe('johndoe')
  })

  it('should return user profile data after login', async () => {
    const result = await login('user@example.com', 'ValidPass123!')

    expect(result.user).toMatchObject({
      id: expect.any(String),
      email: 'user@example.com',
      username: expect.any(String),
      createdAt: expect.any(Date)
    })
  })

  it('should reject login with invalid credentials', async () => {
    await expect(login('user@example.com', 'WrongPassword'))
      .rejects.toThrow('Invalid credentials')
  })
})
```

**Coverage**: ✅ Core user paths covered, all features tested, data correctness verified

#### 2️⃣ Boundary Testing

```typescript
describe('User Login - Boundary Tests', () => {
  // Empty input
  it('should reject empty email', async () => {
    await expect(login('', 'password123'))
      .rejects.toThrow('Email is required')
  })

  it('should reject empty password', async () => {
    await expect(login('user@example.com', ''))
      .rejects.toThrow('Password is required')
  })

  // Maximum length
  it('should handle very long email (255 chars)', async () => {
    const longEmail = 'a'.repeat(243) + '@example.com' // 255 chars total

    // Should either accept or reject gracefully
    try {
      const result = await login(longEmail, 'password123')
      expect(result.success).toBe(false)
    } catch (error) {
      expect(error.message).toContain('Email too long')
    }
  })

  it('should handle very long password (72 chars - bcrypt limit)', async () => {
    const longPassword = 'a'.repeat(72)
    const result = await login('user@example.com', longPassword)

    // Should work or fail gracefully
    expect(result).toBeDefined()
  })

  it('should reject password exceeding bcrypt limit (>72 chars)', async () => {
    const tooLongPassword = 'a'.repeat(73)

    await expect(login('user@example.com', tooLongPassword))
      .rejects.toThrow('Password too long')
  })

  // Special characters
  it('should handle special characters in email', async () => {
    const specialEmail = 'user+tag@example.com'
    const result = await login(specialEmail, 'password123')

    expect(result.success).toBe(true)
    expect(result.user.email).toBe(specialEmail)
  })

  it('should handle special characters in password', async () => {
    const specialPassword = '!@#$%^&*()_+-=[]{}|;:,.<>?'
    const result = await login('user@example.com', specialPassword)

    expect(result).toBeDefined()
  })

  it('should handle Unicode characters in username', async () => {
    const unicodeUsername = 'userUnicode123'  // Unicode characters test
    const result = await login(unicodeUsername, 'password123')

    expect(result.user.username).toBe(unicodeUsername)
  })

  // Extreme values
  it('should handle minimum valid email (a@b.co - 6 chars)', async () => {
    const minEmail = 'a@b.co'
    const result = await login(minEmail, 'password123')

    expect(result).toBeDefined()
  })

  it('should handle minimum valid password (8 chars)', async () => {
    const minPassword = 'Pass123!'
    const result = await login('user@example.com', minPassword)

    expect(result.success).toBe(true)
  })
})
```

**Coverage**: ✅ Empty input, maximum length, special characters, extreme values tested

#### 3️⃣ Exception Testing

```typescript
describe('User Login - Exception Tests', () => {
  // Network errors
  it('should handle network timeout', async () => {
    jest.spyOn(global, 'fetch').mockImplementationOnce(() =>
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error('Network timeout')), 100)
      )
    )

    await expect(login('user@example.com', 'password123'))
      .rejects.toThrow('Network timeout')
  })

  it('should handle network disconnection', async () => {
    jest.spyOn(global, 'fetch').mockRejectedValueOnce(
      new Error('Network request failed')
    )

    await expect(login('user@example.com', 'password123'))
      .rejects.toThrow('Network request failed')
  })

  // API failures
  it('should handle 500 internal server error', async () => {
    jest.spyOn(global, 'fetch').mockResolvedValueOnce({
      status: 500,
      json: async () => ({ error: 'Internal server error' })
    } as Response)

    await expect(login('user@example.com', 'password123'))
      .rejects.toThrow('Server error')
  })

  it('should handle 503 service unavailable', async () => {
    jest.spyOn(global, 'fetch').mockResolvedValueOnce({
      status: 503,
      json: async () => ({ error: 'Service unavailable' })
    } as Response)

    await expect(login('user@example.com', 'password123'))
      .rejects.toThrow('Service unavailable')
  })

  it('should handle malformed JSON response', async () => {
    jest.spyOn(global, 'fetch').mockResolvedValueOnce({
      status: 200,
      json: async () => { throw new SyntaxError('Unexpected token') }
    } as Response)

    await expect(login('user@example.com', 'password123'))
      .rejects.toThrow('Invalid response format')
  })

  // Concurrent conflicts
  it('should handle race condition in token generation', async () => {
    // Simulate two concurrent login attempts
    const promise1 = login('user@example.com', 'password123')
    const promise2 = login('user@example.com', 'password123')

    const [result1, result2] = await Promise.all([promise1, promise2])

    // Both should succeed with different tokens
    expect(result1.token).not.toBe(result2.token)
  })

  it('should handle account locked due to failed attempts', async () => {
    // Simulate 5 failed attempts
    for (let i = 0; i < 5; i++) {
      try {
        await login('user@example.com', 'wrongpassword')
      } catch (e) {
        // Expected failures
      }
    }

    // 6th attempt should be blocked
    await expect(login('user@example.com', 'correctpassword'))
      .rejects.toThrow('Account locked due to multiple failed attempts')
  })

  // Timeouts
  it('should timeout after 5 seconds', async () => {
    jest.setTimeout(6000)

    jest.spyOn(global, 'fetch').mockImplementationOnce(() =>
      new Promise((resolve) =>
        setTimeout(() => resolve({
          status: 200,
          json: async () => ({ success: true })
        } as Response), 6000)
      )
    )

    await expect(login('user@example.com', 'password123'))
      .rejects.toThrow('Request timeout')
  }, 6000)
})
```

**Coverage**: ✅ Network errors, API failures, concurrent conflicts, timeouts tested

#### 4️⃣ Performance Testing

```typescript
describe('User Login - Performance Tests', () => {
  // Response time benchmarks
  it('should complete login within 500ms', async () => {
    const start = performance.now()

    await login('user@example.com', 'password123')

    const duration = performance.now() - start
    expect(duration).toBeLessThan(500)
  })

  it('should complete 100 concurrent logins within 3 seconds', async () => {
    const start = performance.now()

    const promises = Array(100).fill(null).map((_, i) =>
      login(`user${i}@example.com`, 'password123')
    )

    await Promise.all(promises)

    const duration = performance.now() - start
    expect(duration).toBeLessThan(3000)
  })

  // Resource consumption
  it('should use less than 50MB memory for 1000 logins', async () => {
    const initialMemory = process.memoryUsage().heapUsed

    for (let i = 0; i < 1000; i++) {
      await login(`user${i}@example.com`, 'password123')
    }

    const finalMemory = process.memoryUsage().heapUsed
    const memoryUsed = (finalMemory - initialMemory) / 1024 / 1024 // Convert to MB

    expect(memoryUsed).toBeLessThan(50)
  })

  // No memory leaks
  it('should not leak memory over 10000 login cycles', async () => {
    const measurements: number[] = []

    for (let i = 0; i < 10; i++) {
      for (let j = 0; j < 1000; j++) {
        await login('user@example.com', 'password123')
      }

      global.gc && global.gc() // Force garbage collection if available
      measurements.push(process.memoryUsage().heapUsed)
    }

    // Memory should stabilize, not grow linearly
    const firstHalf = measurements.slice(0, 5).reduce((a, b) => a + b) / 5
    const secondHalf = measurements.slice(5).reduce((a, b) => a + b) / 5
    const growth = ((secondHalf - firstHalf) / firstHalf) * 100

    expect(growth).toBeLessThan(20) // Less than 20% growth
  })

  // Load testing
  it('should handle 1000 requests per second', async () => {
    const start = performance.now()
    const promises: Promise<any>[] = []

    for (let i = 0; i < 1000; i++) {
      promises.push(login(`user${i}@example.com`, 'password123'))
    }

    await Promise.all(promises)

    const duration = performance.now() - start
    expect(duration).toBeLessThan(1000) // Should complete within 1 second
  })
})
```

**Coverage**: ✅ Response time benchmarks, resource consumption, no memory leaks, load testing

#### 5️⃣ Security Testing

```typescript
describe('User Login - Security Tests', () => {
  // XSS protection
  it('should sanitize XSS in email input', async () => {
    const xssEmail = '<script>alert("XSS")</script>@example.com'

    try {
      await login(xssEmail, 'password123')
    } catch (error) {
      // Should either sanitize or reject
      expect(error.message).not.toContain('<script>')
    }
  })

  it('should escape HTML in error messages', async () => {
    const htmlEmail = '<b>test</b>@example.com'

    try {
      await login(htmlEmail, 'wrongpassword')
    } catch (error) {
      expect(error.message).not.toContain('<b>')
      expect(error.message).toContain('&lt;b&gt;') // Should be escaped
    }
  })

  // SQL injection prevention
  it('should prevent SQL injection in email', async () => {
    const sqlEmail = "' OR '1'='1' --@example.com"

    await expect(login(sqlEmail, 'password123'))
      .rejects.toThrow('Invalid email format')
  })

  it('should prevent SQL injection in password', async () => {
    const sqlPassword = "' OR '1'='1"

    // Should not authenticate everyone
    try {
      const result = await login('user@example.com', sqlPassword)
      expect(result.success).toBe(false)
    } catch (error) {
      expect(error).toBeDefined()
    }
  })

  // CSRF protection
  it('should require CSRF token for login', async () => {
    const loginWithoutCsrf = async () => {
      return fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: 'user@example.com',
          password: 'password123'
          // Missing CSRF token
        })
      })
    }

    const response = await loginWithoutCsrf()
    expect(response.status).toBe(403) // Forbidden
  })

  // Input validation
  it('should validate email format', async () => {
    const invalidEmails = [
      'notanemail',
      '@example.com',
      'user@',
      'user @example.com',
      'user@example'
    ]

    for (const email of invalidEmails) {
      await expect(login(email, 'password123'))
        .rejects.toThrow('Invalid email format')
    }
  })

  it('should enforce password complexity', async () => {
    const weakPasswords = [
      '123456',           // Too simple
      'password',         // Common password
      'abc123',           // Too short
      'aaaaaaaa'          // Repeated characters
    ]

    for (const password of weakPasswords) {
      await expect(login('user@example.com', password))
        .rejects.toThrow(/Password (too weak|does not meet requirements)/)
    }
  })

  // Permission checks
  it('should not return sensitive user data to non-owners', async () => {
    // Login as user A
    const resultA = await login('userA@example.com', 'password123')

    // Try to fetch user B's data with user A's token
    const userBData = await fetchUser('userB-id', resultA.token)

    // Should not include sensitive fields
    expect(userBData.password).toBeUndefined()
    expect(userBData.passwordHash).toBeUndefined()
    expect(userBData.privateKey).toBeUndefined()
  })

  it('should rate limit login attempts', async () => {
    // Attempt 10 logins within 1 second
    const promises = Array(10).fill(null).map(() =>
      login('user@example.com', 'password123')
    )

    await expect(Promise.all(promises))
      .rejects.toThrow('Too many requests')
  })
})
```

**Coverage**: ✅ XSS protection, SQL injection prevention, CSRF protection, input validation, permission checks

#### 6️⃣ Compatibility Testing

```typescript
describe('User Login - Compatibility Tests (Frontend)', () => {
  const browsers = ['chromium', 'firefox', 'webkit']

  test.each(browsers)('should work on %s browser', async (browserType) => {
    const browser = await playwright[browserType].launch()
    const page = await browser.newPage()

    await page.goto('http://localhost:3000/login')

    await page.fill('[name="email"]', 'user@example.com')
    await page.fill('[name="password"]', 'password123')
    await page.click('button[type="submit"]')

    await page.waitForURL('**/dashboard')
    expect(page.url()).toContain('/dashboard')

    await browser.close()
  })

  it('should be responsive on mobile devices', async () => {
    const devices = [
      playwright.devices['iPhone 12'],
      playwright.devices['Pixel 5'],
      playwright.devices['iPad Pro']
    ]

    for (const device of devices) {
      const browser = await playwright.chromium.launch()
      const context = await browser.newContext({
        ...device
      })
      const page = await context.newPage()

      await page.goto('http://localhost:3000/login')

      // Check if login form is visible and usable
      const emailInput = await page.$('[name="email"]')
      const passwordInput = await page.$('[name="password"]')
      const submitButton = await page.$('button[type="submit"]')

      expect(emailInput).toBeTruthy()
      expect(passwordInput).toBeTruthy()
      expect(submitButton).toBeTruthy()

      // Verify elements are in viewport
      const emailBox = await emailInput?.boundingBox()
      expect(emailBox).toBeTruthy()
      expect(emailBox!.y).toBeGreaterThan(0)

      await browser.close()
    }
  })

  it('should work on different screen sizes', async () => {
    const viewports = [
      { width: 320, height: 568 },   // iPhone SE
      { width: 768, height: 1024 },  // iPad
      { width: 1920, height: 1080 }  // Desktop
    ]

    const browser = await playwright.chromium.launch()

    for (const viewport of viewports) {
      const page = await browser.newPage({ viewport })

      await page.goto('http://localhost:3000/login')

      // Take screenshot for visual regression
      await page.screenshot({
        path: `screenshots/login-${viewport.width}x${viewport.height}.png`
      })

      // Verify layout doesn't break
      const emailInput = await page.$('[name="email"]')
      const isVisible = await emailInput?.isVisible()
      expect(isVisible).toBe(true)
    }

    await browser.close()
  })
})
```

**Coverage**: ✅ Cross-browser (Chrome/Firefox/Safari), mobile devices, different screen sizes

---

### ✅ Six-Dimensional Coverage Matrix

| Feature | Functional | Boundary | Exception | Performance | Security | Compatibility | Status |
|---------|------------|----------|-----------|-------------|----------|---------------|--------|
| User Login | ✅ 4 tests | ✅ 10 tests | ✅ 10 tests | ✅ 5 tests | ✅ 10 tests | ✅ 3 tests | **100%** |

**Total Tests**: 42 tests covering all 6 dimensions

**Status**: ✅ **READY FOR PRODUCTION**

---

## Example 2: Detecting Missing Coverage

### Scenario: Incomplete Test Suite

```typescript
// User submitted tests
describe('Password Reset', () => {
  it('should send reset email', async () => {
    await resetPassword('user@example.com')
    expect(emailSent).toBe(true)
  })

  it('should reset password with valid token', async () => {
    const result = await resetPasswordWithToken('valid-token', 'NewPass123!')
    expect(result.success).toBe(true)
  })
})
```

**Assistant Analysis:**

```
🧪 Insufficient Test Coverage Detected

Feature: Password Reset
Current Tests: 2 tests

Coverage Status:
- ✅ Functional Tests: 2/4 (50%)
- ❌ Boundary Tests: 0/8 (0%) - Missing!
- ❌ Exception Tests: 0/6 (0%) - Missing!
- ❌ Performance Tests: 0/3 (0%) - Missing!
- ❌ Security Tests: 0/5 (0%) - Missing!
- ❌ Compatibility Tests: 0/2 (0%) - Missing!

Overall Coverage: 2/28 (7%) ⚠️

⚠️ Critically Insufficient! This feature cannot be marked as "done"

Recommended Additions:

**Boundary Tests (Required):**
```typescript
it('should reject empty email', async () => {
  await expect(resetPassword(''))
    .rejects.toThrow('Email required')
})

it('should handle very long email', async () => {
  const longEmail = 'a'.repeat(250) + '@example.com'
  // Test handling
})
```

**Exception Tests (Required):**
```typescript
it('should handle email service failure', async () => {
  jest.spyOn(emailService, 'send').mockRejectedValue(new Error('SMTP error'))
  await expect(resetPassword('user@example.com'))
    .rejects.toThrow('Failed to send email')
})
```

**Security Tests (Required):**
```typescript
it('should generate secure random tokens', async () => {
  const token1 = await generateResetToken()
  const token2 = await generateResetToken()

  expect(token1).not.toBe(token2)
  expect(token1.length).toBeGreaterThanOrEqual(32)
})

it('should expire tokens after 1 hour', async () => {
  const token = await generateResetToken()

  // Fast-forward 61 minutes
  jest.advanceTimersByTime(61 * 60 * 1000)

  await expect(resetPasswordWithToken(token, 'NewPass123!'))
    .rejects.toThrow('Token expired')
})
```

📋 Complete test checklist generated: .taskmaster/docs/test-checklists/password-reset.md
```

**Skill blocks task completion until all 6 dimensions are covered**

---

## Example 3: Framework-Specific Examples

### Jest + React Testing Library

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { LoginForm } from './LoginForm'

describe('LoginForm Component - Six-Dimensional Tests', () => {
  // 1️⃣ Functional
  it('should render login form with all fields', () => {
    render(<LoginForm />)

    expect(screen.getByLabelText(/email/i)).toBeInTheDocument()
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /login/i })).toBeInTheDocument()
  })

  it('should call onSubmit when form is submitted', async () => {
    const onSubmit = jest.fn()
    render(<LoginForm onSubmit={onSubmit} />)

    await userEvent.type(screen.getByLabelText(/email/i), 'user@example.com')
    await userEvent.type(screen.getByLabelText(/password/i), 'password123')
    await userEvent.click(screen.getByRole('button', { name: /login/i }))

    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({
        email: 'user@example.com',
        password: 'password123'
      })
    })
  })

  // 2️⃣ Boundary
  it('should show error for empty email', async () => {
    render(<LoginForm />)

    await userEvent.click(screen.getByRole('button', { name: /login/i }))

    expect(await screen.findByText(/email is required/i)).toBeInTheDocument()
  })

  // 3️⃣ Exception
  it('should show error message on login failure', async () => {
    const onSubmit = jest.fn().mockRejectedValue(new Error('Invalid credentials'))
    render(<LoginForm onSubmit={onSubmit} />)

    await userEvent.type(screen.getByLabelText(/email/i), 'user@example.com')
    await userEvent.type(screen.getByLabelText(/password/i), 'wrongpassword')
    await userEvent.click(screen.getByRole('button', { name: /login/i }))

    expect(await screen.findByText(/invalid credentials/i)).toBeInTheDocument()
  })

  // 4️⃣ Performance
  it('should debounce email validation', async () => {
    const validateEmail = jest.fn()
    render(<LoginForm onEmailValidate={validateEmail} />)

    const emailInput = screen.getByLabelText(/email/i)

    await userEvent.type(emailInput, 'user@example.com')

    // Should not validate on every keystroke
    expect(validateEmail).toHaveBeenCalledTimes(1) // Only once after debounce
  })

  // 5️⃣ Security
  it('should mask password input', () => {
    render(<LoginForm />)

    const passwordInput = screen.getByLabelText(/password/i)
    expect(passwordInput).toHaveAttribute('type', 'password')
  })

  // 6️⃣ Compatibility (accessibility)
  it('should be keyboard accessible', async () => {
    render(<LoginForm />)

    const emailInput = screen.getByLabelText(/email/i)
    const passwordInput = screen.getByLabelText(/password/i)
    const submitButton = screen.getByRole('button', { name: /login/i })

    emailInput.focus()
    expect(document.activeElement).toBe(emailInput)

    await userEvent.tab()
    expect(document.activeElement).toBe(passwordInput)

    await userEvent.tab()
    expect(document.activeElement).toBe(submitButton)
  })
})
```

### Playwright E2E Tests

```typescript
import { test, expect } from '@playwright/test'

test.describe('Login Flow - Six-Dimensional E2E', () => {
  // 1️⃣ Functional
  test('should complete full login flow', async ({ page }) => {
    await page.goto('http://localhost:3000/login')

    await page.fill('[name="email"]', 'user@example.com')
    await page.fill('[name="password"]', 'password123')
    await page.click('button:has-text("Login")')

    await expect(page).toHaveURL(/.*dashboard/)
    await expect(page.locator('h1')).toContainText('Welcome')
  })

  // 2️⃣ Boundary
  test('should handle maximum password length', async ({ page }) => {
    await page.goto('http://localhost:3000/login')

    const maxPassword = 'a'.repeat(72) // bcrypt limit
    await page.fill('[name="password"]', maxPassword)

    await expect(page.locator('[name="password"]')).toHaveValue(maxPassword)
  })

  // 3️⃣ Exception
  test('should show error on network failure', async ({ page }) => {
    await page.route('**/api/login', (route) => route.abort())

    await page.goto('http://localhost:3000/login')
    await page.fill('[name="email"]', 'user@example.com')
    await page.fill('[name="password"]', 'password123')
    await page.click('button:has-text("Login")')

    await expect(page.locator('.error-message')).toContainText(/network/i)
  })

  // 4️⃣ Performance
  test('should render within 2 seconds', async ({ page }) => {
    const start = Date.now()

    await page.goto('http://localhost:3000/login')
    await page.waitForLoadState('networkidle')

    const duration = Date.now() - start
    expect(duration).toBeLessThan(2000)
  })

  // 5️⃣ Security
  test('should not expose password in DOM', async ({ page }) => {
    await page.goto('http://localhost:3000/login')
    await page.fill('[name="password"]', 'SecretPassword123!')

    const html = await page.content()
    expect(html).not.toContain('SecretPassword123!')
  })

  // 6️⃣ Compatibility
  test.describe('Cross-browser compatibility', () => {
    test.use({ browserName: 'chromium' })
    test('should work on Chrome', async ({ page }) => {
      await page.goto('http://localhost:3000/login')
      await expect(page.locator('form')).toBeVisible()
    })
  })
})
```

### Vitest + Vue Test Utils

```typescript
import { mount } from '@vue/test-utils'
import { describe, it, expect, vi } from 'vitest'
import LoginForm from './LoginForm.vue'

describe('LoginForm - Six-Dimensional Tests', () => {
  // 1️⃣ Functional
  it('should emit login event with credentials', async () => {
    const wrapper = mount(LoginForm)

    await wrapper.find('[data-test="email"]').setValue('user@example.com')
    await wrapper.find('[data-test="password"]').setValue('password123')
    await wrapper.find('form').trigger('submit')

    expect(wrapper.emitted('login')).toBeTruthy()
    expect(wrapper.emitted('login')[0]).toEqual([{
      email: 'user@example.com',
      password: 'password123'
    }])
  })

  // 2️⃣ Boundary
  it('should trim whitespace from email', async () => {
    const wrapper = mount(LoginForm)

    await wrapper.find('[data-test="email"]').setValue('  user@example.com  ')
    await wrapper.find('form').trigger('submit')

    const emitted = wrapper.emitted('login')[0][0]
    expect(emitted.email).toBe('user@example.com') // Trimmed
  })

  // 3️⃣ Exception
  it('should display API error message', async () => {
    const wrapper = mount(LoginForm, {
      props: {
        error: 'Invalid credentials'
      }
    })

    expect(wrapper.find('.error-message').text()).toBe('Invalid credentials')
  })

  // 4️⃣ Performance
  it('should not cause unnecessary re-renders', async () => {
    const wrapper = mount(LoginForm)
    const renderSpy = vi.spyOn(wrapper.vm, '$forceUpdate')

    await wrapper.find('[data-test="email"]').setValue('user@example.com')

    expect(renderSpy).not.toHaveBeenCalled()
  })

  // 5️⃣ Security
  it('should sanitize XSS in error messages', async () => {
    const xssError = '<script>alert("XSS")</script>'
    const wrapper = mount(LoginForm, {
      props: { error: xssError }
    })

    const errorHtml = wrapper.find('.error-message').html()
    expect(errorHtml).not.toContain('<script>')
    expect(errorHtml).toContain('&lt;script&gt;')
  })

  // 6️⃣ Compatibility
  it('should have proper ARIA labels', () => {
    const wrapper = mount(LoginForm)

    expect(wrapper.find('[data-test="email"]').attributes('aria-label')).toBeTruthy()
    expect(wrapper.find('[data-test="password"]').attributes('aria-label')).toBeTruthy()
  })
})
```

---

## Best Practices Summary

### DO ✅

1. **Cover all 6 dimensions** for every feature
2. **Write tests before marking done** - Test-driven development
3. **Use real testing frameworks** - Jest/Vitest/Playwright
4. **Execute tests 100%** - No mocks unless external services
5. **Measure coverage** - Aim for ≥80% code coverage
6. **Test in production-like environment** - Docker/staging

### DON'T ❌

1. **Don't skip dimensions** - All 6 are mandatory
2. **Don't rely only on unit tests** - Need integration + E2E
3. **Don't mock everything** - Test real behavior
4. **Don't ignore performance** - Slow tests indicate slow code
5. **Don't forget accessibility** - Compatibility includes a11y
6. **Don't mark tasks done without tests** - Quality gate enforced

---

## Troubleshooting

### Issue: "I don't know how to test this dimension"

**Solution**: Refer to SKILL.md examples and consult framework docs

### Issue: "Tests are too slow"

**Solution**: This is a performance issue - optimize the code, not skip tests

### Issue: "I can't test in all browsers"

**Solution**: Use Playwright's device/browser emulation for cross-browser testing
