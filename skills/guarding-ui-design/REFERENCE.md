# UI Design Guardian - Complete Reference

**Ultra Builder Pro 4.1** - Detailed examples, patterns, and integration guide.

---

## Overview

This skill prevents UI anti-patterns and guides toward cohesive, maintainable design. All user-facing output is in Chinese (simplified).

**Core mission**: Stop distributional convergence ("AI slop" appearance), enforce design discipline.

---

## Quick Reference

### Enforced Rules (BLOCK)
- ❌ Default fonts (Inter, Roboto, Open Sans, Lato, system-ui)
- ❌ Purple gradients on white backgrounds
- ❌ Hard-coded colors (use design tokens/CSS variables)
- ❌ Inconsistent spacing (use theme multiples)

### Design Guidance (SUGGEST)
- ✅ **Typography**: 3x+ size jumps, high-contrast font pairing
- ✅ **Color**: Design tokens, one dominant color with accents
- ✅ **Motion**: CSS-only first, orchestrated page load animations
- ✅ **Component Libraries**: MUI, Ant Design, Chakra, Radix, shadcn/ui

---

## Detailed Documentation

**Progressive disclosure**: Select topic for detailed reference.

### 1. Trigger Scenarios
**When skill activates and how it responds**

[View Details](./reference/trigger-scenarios.md)

Topics: Creating new components, editing styles, discussing UI, refactoring frontend, code reviews

---

### 2. Enforced Constraints
**Hard rules that block violations**

[View Details](./reference/enforced-constraints.md)

Topics: Prohibited fonts, color anti-patterns, spacing violations, background clichés

---

### 3. Design Suggestions
**Constructive guidance with code examples**

[View Details](./reference/design-suggestions.md)

Topics: Typography systems, color palettes, motion design, layout patterns

---

### 4. Output Examples
**Real output examples in Chinese**

[View Details](./reference/output-examples.md)

Topics: Violation warnings, design suggestions, refactoring guidance, approval confirmations

---

### 5. Design System Integration
**Working with established design systems**

[View Details](./reference/design-systems.md)

Topics: Material Design, Tailwind CSS, Chakra UI, Ant Design, custom systems

Includes: Real code examples for each system (see `examples/` directory)

---

### 6. Common Anti-Patterns
**Frequent mistakes and how to fix them**

[View Details](./reference/anti-patterns.md)

Topics: Default font trap, color hard-coding, purple gradient syndrome, spacing chaos

---

### 7. FAQ
**Frequently asked questions**

[View Details](./reference/faq.md)

Topics: Customization, design system selection, accessibility, performance

---

### 8. Performance Integration
**UI design meets Core Web Vitals**

[View Details](./reference/performance-integration.md)

Topics: Font loading optimization, color rendering, motion performance

---

### 9. Related Skills
**Integration with other Ultra Builder skills**

[View Details](./reference/related-skills.md)

Topics: guarding-code-quality, automating-e2e-tests, guarding-test-coverage

---

## Example Code Repositories

Located in `examples/` directory:
- `chakra-ui-example.md` - Complete Chakra UI setup
- `material-design-example.md` - Material Design 3 implementation
- `tailwind-example.md` - Tailwind with custom design tokens

---

## Token Efficiency

**Before modularization**: 1,233 lines in single REFERENCE.md
**After modularization**: ~200 lines main + 9 focused modules (~100-200 lines each)

**Benefit**: Load only needed sections, progressive disclosure optimizes context usage.

---

**For skill implementation details**, see `SKILL.md` (main skill file).


---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
