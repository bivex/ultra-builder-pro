## FAQ

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Q1: Must I use a specific design system?

**A**: No. Guardian does **not enforce** specific design systems (Material Design, Tailwind, etc. are all acceptable).

Guardian **enforces**:
- ❌ Avoid default fonts (Inter, Roboto, Open Sans)
- ❌ Avoid hard-coded colors
- ❌ Avoid purple gradient clichés

Guardian **suggests**:
- ✅ Typography hierarchy (3x+ size jumps)
- ✅ Color system (1 primary + accents)
- ✅ Use mature component libraries

---

### Q2: What if project already uses Inter font?

**A**: Guardian will suggest migration, but won't block continued use.

**Suggested migration path**:
1. **Assess impact**: Does font change affect brand recognition?
2. **Gradual migration**: Use new font in new components first, observe effects
3. **Brand consistency**: If Inter is part of brand guidelines, can keep (add exception documentation)

**Exception handling**:
```css
/* If Inter is brand font, add comment explanation */
:root {
  /* Brand guideline: Inter is our corporate font */
  --font-brand: 'Inter', sans-serif;
}
```

Guardian will recognize the comment and stop warnings.

---

### Q3: How to handle client requirements for specific colors (like corporate blue)?

**A**: Guardian supports custom primary colors, but will check if design tokens are used.

**Correct approach**:
```css
:root {
  /* Client brand color: Enterprise Blue */
  --color-primary: #0052CC;  /* Enterprise blue */
}

.button-primary {
  background-color: var(--color-primary);
}
```

Guardian will approve this approach (uses design tokens).

**Wrong approach**:
```css
.button-primary {
  background-color: #0052CC;  /* ❌ Hard-coded */
}
```

Guardian will warn and suggest using tokens.

---

### Q4: Is dark mode mandatory?

**A**: Not mandatory, but **strongly recommended** to use design tokens for future support.

**Best practice**:
```css
/* 1. Define light mode (default) */
:root {
  --color-bg: #FFFFFF;
  --color-text: #0F172A;
}

/* 2. Define dark mode (optional) */
[data-theme="dark"] {
  --color-bg: #0F172A;
  --color-text: #F8FAFC;
}

/* 3. Use tokens */
body {
  background-color: var(--color-bg);
  color: var(--color-text);
}
```

**Benefits**:
- Future dark mode support: 1 minute completion
- Theme switching: User preference settings
- Accessibility: Reduced eye strain

---

### Q5: How do I know if my design is "modern"?

**A**: Guardian doesn't judge "modern" (subjective), but checks:

**Objective metrics**:
1. ✅ Avoid generic patterns (default fonts, purple gradients)
2. ✅ Systematic design (design tokens, spacing grid)
3. ✅ Performance metrics (Core Web Vitals)
4. ✅ Accessibility (WCAG 2.1 AA)

**Subjective assessment** (you decide):
- Brand personality expression
- Visual uniqueness
- User experience innovation

Guardian ensures you avoid "AI slop", but **creativity is your domain**.

---

### Q6: Does Guardian check responsive design?

**A**: Guardian does **not directly check** responsive breakpoints, but **suggests** using standard breakpoints.

**Recommended breakpoints** (based on statistics):
```css
/* Mobile-first */
@media (min-width: 768px) {  /* Tablet */
  /* ... */
}

@media (min-width: 1024px) { /* Desktop */
  /* ... */
}

@media (min-width: 1440px) { /* Large Desktop */
  /* ... */
}
```

**Component library defaults**:
- MUI: 600px, 960px, 1280px
- Tailwind: 640px, 768px, 1024px, 1280px, 1536px
- Ant Design: 576px, 768px, 992px, 1200px, 1600px

Guardian will suggest using component library standard breakpoints (consistency).

---

### Q7: How to handle third-party component default styles?

**A**: Guardian suggests **overriding** third-party component default styles.

**Example: MUI Button**
```tsx
import { Button } from '@mui/material';

// ❌ Use default styles
<Button>Click me</Button>

// ✅ Override default styles
<Button
  sx={{
    fontFamily: 'var(--font-display)',
    backgroundColor: 'var(--color-primary)',
    '&:hover': {
      backgroundColor: 'var(--color-primary-dark)',
    },
  }}
>
  Click me
</Button>
```

**Or use theme overrides**:
```tsx
const theme = createTheme({
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          fontFamily: 'var(--font-display)',
          textTransform: 'none',  // Remove default uppercase
        },
      },
    },
  },
});
```

---
