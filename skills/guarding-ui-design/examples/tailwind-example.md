# Tailwind CSS - Example Implementation

**When to use**: Utility-first approach, rapid prototyping, highly customizable projects

---

## Typography Configuration

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        // Avoid default fonts
        display: ['"Playfair Display"', 'serif'],
        body: ['"JetBrains Mono"', 'monospace'],
      },
      fontSize: {
        // 3x+ scale jumps
        'display-xl': ['4.5rem', { lineHeight: '1.1' }],  // 72px
        'display-lg': ['3.5rem', { lineHeight: '1.2' }],  // 56px
        'heading': ['2rem', { lineHeight: '1.3' }],       // 32px
        'body': ['1rem', { lineHeight: '1.5' }],          // 16px
      },
    },
  },
};
```

## Color Theming with Design Tokens

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        // Design tokens for brand colors
        primary: {
          50: '#FEE2E2',
          100: '#FECACA',
          500: '#EF4444',  // Dominant color
          900: '#7F1D1D',
        },
        accent: {
          500: '#8B5CF6',  // Accent color
        },
      },
    },
  },
};
```

## Component Example

```tsx
// Using Radix UI (headless) + Tailwind for styling
import * as Dialog from '@radix-ui/react-dialog';

function ExampleDialog() {
  return (
    <Dialog.Root>
      <Dialog.Trigger className="px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition-colors duration-300">
        Open
      </Dialog.Trigger>

      <Dialog.Portal>
        <Dialog.Overlay className="fixed inset-0 bg-black/50 backdrop-blur-sm" />
        <Dialog.Content className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-xl p-6 shadow-xl max-w-md w-full">
          <Dialog.Title className="font-display text-2xl font-bold mb-4">
            Title
          </Dialog.Title>
          <Dialog.Description className="font-body text-sm text-gray-600 mb-6">
            Description
          </Dialog.Description>
          <Dialog.Close className="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200 transition-colors duration-200">
            Close
          </Dialog.Close>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
```

## Motion (CSS-only with Tailwind)

```tsx
// Orchestrated page load animation
function PageTransition({ children }) {
  return (
    <div className="animate-fadeIn">
      <header className="animate-slideDown delay-100">Header</header>
      <main className="animate-slideUp delay-200">{children}</main>
      <footer className="animate-fadeIn delay-300">Footer</footer>
    </div>
  );
}

// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      animation: {
        fadeIn: 'fadeIn 0.3s ease-in-out',
        slideDown: 'slideDown 0.3s ease-out',
        slideUp: 'slideUp 0.3s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      },
    },
  },
};
```

## Accessibility

```tsx
// WCAG 2.1 AA contrast
<button
  className="bg-primary-500 text-white"  // Ensure 4.5:1 ratio
  aria-label="Submit form"
  type="submit"
>
  Submit
</button>

// Focus states
<input
  className="border rounded px-3 py-2 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
  aria-describedby="input-help"
/>
```

## Recommended Component Libraries

- **Radix UI** - Headless, accessible primitives
- **Headless UI** - Tailwind-official components
- **shadcn/ui** - Copy-paste components with Tailwind

---

**Key Principles**:
- Avoid default system fonts
- Use design tokens (Tailwind theme)
- CSS-only animations with `@keyframes`
- WCAG 2.1 AA compliance
- Prefer headless + Tailwind over custom
