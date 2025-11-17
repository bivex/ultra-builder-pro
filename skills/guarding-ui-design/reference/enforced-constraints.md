## Enforced Constraints Examples

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Constraint 1: Default Fonts (BLOCKED)

**Bad code** ❌:
```css
body {
  font-family: 'Inter', sans-serif; /* ❌ Default font */
}
```

**Guardian intervention**:
```
❌ Detected Default Font: Inter

**Issue**: Distributional convergence (all AI-generated UIs look the same)

**Alternative options**:

Option 1 (Professional):
font-family: 'Inter Display', 'JetBrains Mono', monospace;

Option 2 (Modern):
font-family: 'Satoshi', 'IBM Plex Mono', monospace;

Option 3 (Elegant):
font-family: 'Fraunces', 'Space Mono', monospace;

**Rule**: Display font + Monospace font pairing (high contrast)
```

**Good code** ✅:
```css
:root {
  --font-display: 'Satoshi', system-ui;
  --font-mono: 'IBM Plex Mono', monospace;
}

body {
  font-family: var(--font-display);
}

code, pre {
  font-family: var(--font-mono);
}
```

---

### Constraint 2: Hard-Coded Colors (BLOCKED)

**Bad code** ❌:
```tsx
<button style={{ backgroundColor: '#3B82F6', color: '#FFFFFF' }}>
  Click me
</button>
```

**Guardian intervention**:
```
❌ Detected Hard-Coded Colors

**Issues**:
- Cannot switch themes
- Cannot support dark mode
- High maintenance cost

**Suggested using design tokens**:

/* tokens.css */
:root {
  --color-primary: #3B82F6;
  --color-on-primary: #FFFFFF;
}

[data-theme="dark"] {
  --color-primary: #60A5FA;
  --color-on-primary: #1E293B;
}

/* Component */
<button className="btn-primary">Click me</button>

.btn-primary {
  background-color: var(--color-primary);
  color: var(--color-on-primary);
}
```

**Good code** ✅:
```tsx
// Using design tokens
<button className={styles.primary}>Click me</button>

// styles.module.css
.primary {
  background-color: var(--color-primary);
  color: var(--color-on-primary);
}
```

---

### Constraint 3: Purple Gradients (BLOCKED)

**Bad code** ❌:
```css
.hero {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

**Guardian intervention**:
```
❌ Detected Purple Gradient Anti-Pattern

**Issue**: Common cliché of AI-generated UIs ("AI slop")

**Alternative options**:

Option 1 (Deep atmosphere):
background: linear-gradient(135deg, #1E3A8A 0%, #0F172A 100%);
/* Deep blue to deep gray, professional feel */

Option 2 (Warm tone):
background: linear-gradient(135deg, #DC2626 0%, #991B1B 100%);
/* Red spectrum, energetic feel */

Option 3 (Subtle texture):
background: #F8FAFC;
background-image:
  radial-gradient(circle at 25% 25%, rgba(59,130,246,0.05) 0%, transparent 50%);
/* Subtle light effect, modern feel */
```

**Good code** ✅:
```css
.hero {
  background: var(--color-surface);
  background-image:
    radial-gradient(
      circle at 25% 25%,
      var(--color-accent-alpha-10) 0%,
      transparent 50%
    );
}
```

---
