## Output Examples

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Example 1: New Component Creation

**Scenario**: User creates `Dashboard.tsx`

**Guardian output**:
```
🎨 UI Design Suggestions - Dashboard Component

**Detected potential issues**:
1. ⚠️ Design tokens not defined (may use hard-coded colors)
2. ⚠️ Font not specified (may use default fonts)

**Recommended design approach**:

**1. Design System Selection**
   - Recommended: Ant Design (standard for admin dashboards)
   - Alternative: MUI (Material Design 3)
   - Custom: Based on Radix + Tailwind

**2. Typography System**
   - Headings: 32px bold (Satoshi)
   - Card titles: 16px semibold
   - Body text: 14px regular (IBM Plex Sans)
   - Data display: 24px bold (JetBrains Mono)

**3. Color System**
   Primary: Deep blue #1E3A8A (70%)
   Accent: Orange #F59E0B (20%)
   Neutral gray: #64748B (backgrounds, borders)

**4. Layout Recommendations**
   - Grid: 12-column system
   - Spacing: 8px base (8, 16, 24, 32)
   - Breakpoints: 768px, 1024px, 1440px

**5. Motion Design**
   - Page load: Cards fadeInUp sequentially (stagger 100ms)
   - Data refresh: Fade in/out (300ms)
   - Interactions: Subtle hover effects (transform scale 1.02)

**Implementation reference**:
- Complete code examples: See REFERENCE.md
- Design system documentation: See examples/ant-design-dashboard.md
```

---

### Example 2: Style File Edit (Blocking Hard-Coded Colors)

**Scenario**: User edits CSS with hard-coded colors

**Guardian output**:
```
❌ Design Debt Detected - Hard-Coded Colors

**Detected 23 hard-coded colors**:
- #3B82F6 (blue) - 12 locations
- #8B5CF6 (purple) - 8 locations
- #FFFFFF (white) - 3 locations

**Problem analysis**:
1. Cannot uniformly switch themes
2. Dark mode support difficult
3. Brand color adjustments require modifying 23 locations
4. High maintenance cost (80% wasted time)

**Suggested migration plan**:

**Step 1: Define design tokens**
```css
:root {
  /* Primary colors */
  --color-primary-500: #3B82F6;
  --color-primary-600: #2563EB;

  /* Accent colors */
  --color-accent-500: #8B5CF6;

  /* Neutrals */
  --color-white: #FFFFFF;
  --color-gray-50: #F8FAFC;
}

[data-theme="dark"] {
  --color-primary-500: #60A5FA;
  --color-white: #0F172A;
  --color-gray-50: #1E293B;
}
```

**Step 2: Replace hard-coded values**
```css
/* Before */
.button {
  background-color: #3B82F6;
  color: #FFFFFF;
}

/* After */
.button {
  background-color: var(--color-primary-500);
  color: var(--color-white);
}
```

**Migration impact**:
- ✅ Theme switching: 23 locations → 1 modification
- ✅ Dark mode: Automatically supported
- ✅ Brand adjustment: 1 minute completion
- ✅ Maintenance cost: Reduced 80%

**Auto-migration tool** (optional):
Run: `npx @csstools/postcss-design-tokens` for automatic conversion
```

---

### Example 3: Design Discussion

**Scenario**: User asks "How to design a modern Landing Page?"

**Guardian output**:
```
🎨 Modern Landing Page Design Recommendations

**Core design principles**:

**1. Hero Section (Visual Impact)**

Typography:
- Main headline: 64px ultra-bold (Fraunces)
- Subheading: 20px light (Space Grotesk)
- Ratio: 3.2:1 (high contrast)

Background design:
- Avoid: Purple gradients (cliché)
- Recommended: Subtle light effects + dark background

```css
.hero {
  background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
  background-image:
    radial-gradient(circle at 30% 20%, rgba(59,130,246,0.1) 0%, transparent 50%),
    radial-gradient(circle at 70% 80%, rgba(245,158,11,0.08) 0%, transparent 50%);
}
```

**2. Color System (Brand Recognition)**

Primary color selection:
- Deep blue: #1E3A8A (trust, professionalism)
- Deep red: #991B1B (energy, determination)
- Deep green: #065F46 (growth, stability)

Accent color: Orange #F59E0B (call to action)

**3. Motion Design (Visual Flow)**

Page load sequence:
1. Hero headline: fadeInUp (0ms delay)
2. Subheading: fadeInUp (100ms delay)
3. CTA button: fadeInUp (200ms delay)
4. Hero image: fadeIn (300ms delay)

```css
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

.hero-title {
  animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.hero-subtitle {
  animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) 0.1s both;
}
```

**4. Component Library Recommendations**

Option 1 (Fast):
- Chakra UI + Framer Motion
- Advantage: Rich components, flexible customization

Option 2 (Professional):
- MUI + Material Design 3
- Advantage: Mature, stable, best practices

Option 3 (Custom):
- Radix + Tailwind + shadcn/ui
- Advantage: Complete control, no style constraints

**5. Complete Examples**

Reference implementations:
- examples/landing-page-modern.tsx
- examples/landing-page-minimal.tsx
- examples/landing-page-bold.tsx

**6. Performance Metrics**

Core Web Vitals targets:
- LCP < 2.5s (first screen load)
- INP < 200ms (interaction response)
- CLS < 0.1 (layout stability)

Measurement tool: Lighthouse CLI
```

---
