## Common Anti-Patterns and Fixes

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Anti-Pattern 1: "Corporate Memphis" Illustrations

**Problem**: Generic flat illustrations with purple/blue colors

**Guardian detection**:
```
⚠️ Detected "Corporate Memphis" Style

**Issue**:
- Overused illustration style
- Lacks brand personality
- "AI slop" characteristic

**Alternative approaches**:
1. Real product screenshots (best)
2. Custom illustrations (brand style)
3. Abstract geometric shapes (modern minimalism)
4. 3D renders (premium feel)

**Avoid**:
❌ Undraw default color schemes
❌ Purple gradient figures
❌ Floating geometric shapes
```

---

### Anti-Pattern 2: "Startup Landing Page" Template

**Problem**: Generic template structure (Hero + Features + CTA)

**Guardian suggestion**:
```
⚠️ Detected Generic Template Structure

**Issue**:
- Lacks differentiation
- Mediocre information architecture

**Suggested optimizations**:

1. **Break conventional layout**:
   - Asymmetric grid
   - Diagonal divisions
   - Unexpected scroll experiences

2. **Strengthen brand personality**:
   - Unique color system
   - Custom font pairing
   - Branded illustration style

3. **Information hierarchy innovation**:
   - Data visualization priority
   - Social proof upfront
   - Interactive demos

**Reference cases**:
- Linear.app (minimal restraint)
- Stripe.com (data-driven)
- Vercel.com (technical aesthetics)
```

---

### Anti-Pattern 3: Inconsistent Spacing

**Problem**: Random spacing values (7px, 13px, 19px)

**Guardian detection**:
```
❌ Detected Inconsistent Spacing System

**Found spacing values**:
- 7px, 13px, 19px, 23px, 31px (random values)

**Issues**:
- Visual chaos
- Difficult to maintain
- Lacks systematic approach

**Recommendation: 8px Grid System**

/* Define spacing tokens */
:root {
  --space-1: 8px;    /* 0.5rem */
  --space-2: 16px;   /* 1rem */
  --space-3: 24px;   /* 1.5rem */
  --space-4: 32px;   /* 2rem */
  --space-6: 48px;   /* 3rem */
  --space-8: 64px;   /* 4rem */
}

/* Use tokens */
.card {
  padding: var(--space-4);
  margin-bottom: var(--space-3);
}

**Migration tool**:
Run: npx @spacing-lint/cli to detect inconsistent spacing
```

**Auto-fix**:
```bash
# Automatically fix spacing
npx @spacing-lint/cli --fix --grid=8
```

---
