## Trigger Scenarios

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Scenario 1: Creating New Component

**User action**: Creating `Button.tsx`

**Trigger**: File extension `.tsx` detected

**Guardian activates**: Check for default fonts, hard-coded colors, clichéd patterns

**Example output**:
```
🎨 UI Design Suggestions

Detected new component creation: Button.tsx

**Anti-patterns to avoid**:
❌ Don't use default fonts (Inter, Roboto, Open Sans)
❌ Don't hard-code color values
❌ Don't use isolated purple gradients

**Recommended design patterns**:
✅ Use design token system (CSS variables)
✅ Adopt mature component libraries (MUI, Ant Design, Chakra)
✅ Maintain consistent spacing system (8px grid)

See complete suggestions...
```

---

### Scenario 2: Editing Styles

**User action**: Editing `App.css` with hard-coded colors

**Trigger**: `.css` file modified + discussion about styling

**Guardian activates**: Check for design tokens, suggest migration

**Example output**:
```
⚠️ Design Debt Warning

Detected hard-coded colors:
- `color: #3B82F6` (17 locations)
- `background: #8B5CF6` (8 locations)

**Issues**:
- Cannot uniformly switch themes
- High maintenance cost (need to modify individually)
- Cannot support dark mode

**Suggested migration to design tokens**:

/* 1. Define CSS variables */
:root {
  --color-primary: #3B82F6;
  --color-accent: #8B5CF6;
}

/* 2. Use tokens */
.button {
  color: var(--color-primary);
}

**Migration impact**:
- Theme switching: 1 second (modify variable definition)
- Dark mode: Automatic support (define dark variables)
- Maintenance cost: Reduced 80%
```

---

### Scenario 3: Discussing UI Design

**User action**: "Help me design a modern dashboard"

**Trigger**: Keywords "design" + "dashboard" + file context (React project)

**Guardian activates**: Suggest cohesive design approach

**Example output**:
```
🎨 Dashboard Design Recommendations

**Typography (3x hierarchy jumps)**:
- Headings: 48px (bold)
- Subheadings: 16px (medium)
- Body: 12px (regular)
- Ratio: 4:1.33:1 (high contrast)

**Font pairing suggestions**:
Option 1 (Professional): Inter Display + JetBrains Mono
Option 2 (Modern): Satoshi + IBM Plex Mono
Option 3 (Elegant): Fraunces + Space Mono

**Color system**:
Primary: Choose 1 dominant color (not purple gradients)
Example: Deep blue (#1E3A8A) + Neutral gray (#64748B)

**Component library recommendations**:
- MUI (Material Design 3) - Most mature
- Ant Design - Admin dashboard standard
- Chakra UI - Flexible customization

**Motion design**:
- Page load: Orchestrated reveal animations (stagger 100ms)
- Interaction feedback: CSS transitions (200ms ease-out)
- Avoid: Random micro-interactions

Detailed implementation below...
```

---
