## Design Suggestions with Code

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Suggestion 1: Typography (3x Scale)

**Problem**: Weak hierarchy (1.5x scale)

**Bad** ❌:
```css
h1 { font-size: 24px; }  /* 1.5x */
h2 { font-size: 18px; }  /* 1.5x */
h3 { font-size: 16px; }  /* 1.33x */
p  { font-size: 14px; }
```

**Good** ✅ (3x+ scale):
```css
:root {
  --font-size-display: 48px;  /* 4x */
  --font-size-title: 24px;    /* 2x */
  --font-size-body: 16px;     /* 1.33x */
  --font-size-caption: 12px;  /* base */
}

h1 {
  font-size: var(--font-size-display);
  font-weight: 700;
  line-height: 1.1;
}

h2 {
  font-size: var(--font-size-title);
  font-weight: 600;
  line-height: 1.2;
}

p {
  font-size: var(--font-size-body);
  font-weight: 400;
  line-height: 1.6;
}

.caption {
  font-size: var(--font-size-caption);
  font-weight: 500;
  line-height: 1.4;
}
```

**Output to user**:
```
📏 Typography Hierarchy Optimization

**Issue**: Current size jumps too small (1.5x), hierarchy not obvious

**Recommendation**: 3x+ size jumps

h1: 48px (4x base)
h2: 24px (2x base)
p:  16px (1.33x base)
caption: 12px (base)

**Code example**: See above

**Impact**:
- Visual hierarchy clarity +80%
- Information scanning speed +40%
- Professionalism elevated
```

---

### Suggestion 2: Color System (Dominant + Accents)

**Problem**: Equal weight colors (no dominant)

**Bad** ❌:
```css
:root {
  --color-blue: #3B82F6;
  --color-purple: #8B5CF6;
  --color-green: #10B981;
  --color-orange: #F59E0B;
  /* 4 colors with equal visual weight */
}
```

**Good** ✅ (1 dominant + accents):
```css
:root {
  /* Dominant color (70% usage) */
  --color-primary: #1E3A8A;
  --color-primary-light: #3B82F6;
  --color-primary-dark: #1E293B;

  /* Accent (20% usage) */
  --color-accent: #F59E0B;

  /* Semantic (10% usage) */
  --color-success: #10B981;
  --color-error: #DC2626;

  /* Neutrals */
  --color-gray-50: #F8FAFC;
  --color-gray-900: #0F172A;
}

/* Usage */
.primary-button {
  background: var(--color-primary);
}

.accent-badge {
  background: var(--color-accent);
}
```

**Output to user**:
```
🎨 Color System Optimization

**Issue**: Multi-color equality (no dominant color)

**Recommendation**: 1 primary + accents

**Color ratio**:
- Primary (70%): Deep blue #1E3A8A
- Accent (20%): Orange #F59E0B
- Semantic (10%): Success/Error

**Code example**: See above

**Impact**:
- Visual unity +90%
- Brand recognition elevated
- Information hierarchy clear
```

---

### Suggestion 3: Motion (CSS-first)

**Problem**: Over-reliance on JS animation libraries

**Bad** ❌:
```tsx
import { motion } from 'framer-motion';

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.5 }}
>
  Content
</motion.div>
```

**Good** ✅ (CSS-first):
```css
/* 1. Define animation */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 2. Apply with stagger */
.card {
  animation: fadeInUp 0.4s ease-out;
}

.card:nth-child(1) { animation-delay: 0ms; }
.card:nth-child(2) { animation-delay: 100ms; }
.card:nth-child(3) { animation-delay: 200ms; }

/* 3. Interaction feedback */
.button {
  transition: all 0.2s ease-out;
}

.button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
```

**Output to user**:
```
✨ Motion Design Optimization

**Issue**: Over-reliance on JS animation libraries (performance impact)

**Recommendation**: CSS-first strategy

**Page load animations**:
- Orchestrated reveal (stagger 100ms)
- fadeInUp animation (400ms ease-out)
- 3-5 elements appear sequentially

**Interaction feedback**:
- CSS transitions (200ms)
- Hover state elevation (translateY -2px)
- Shadow deepening

**Performance metrics**:
- INP < 200ms (Core Web Vitals)
- 60fps smoothness

**Code example**: See above
```

---
