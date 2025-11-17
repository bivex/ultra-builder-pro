## Integration with Design Systems

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Material Design 3 (MUI)

**Setup**:
```bash
npm install @mui/material @emotion/react @emotion/styled
```

**Customization** (avoiding defaults):
```tsx
import { createTheme, ThemeProvider } from '@mui/material/styles';

const theme = createTheme({
  typography: {
    fontFamily: '"Satoshi", "IBM Plex Sans", sans-serif',
    h1: {
      fontSize: '3rem',    // 48px
      fontWeight: 700,
    },
    h2: {
      fontSize: '1.5rem',  // 24px
      fontWeight: 600,
    },
  },
  palette: {
    primary: {
      main: '#1E3A8A',     // Custom deep blue
      light: '#3B82F6',
      dark: '#1E293B',
    },
    secondary: {
      main: '#F59E0B',     // Custom orange
    },
  },
  spacing: 8,              // 8px grid
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      {/* Your app */}
    </ThemeProvider>
  );
}
```

**Guardian approval**:
```
✅ MUI Configuration Compliant with Design Standards

**Strengths**:
- Avoided default font (Roboto)
- Custom primary color (avoided default blue)
- Using 8px spacing grid

**Suggestions**:
- Add dark mode support
- Define complete spacing system (8, 16, 24, 32, 40, 48)
```

---

### Tailwind CSS

**Setup** (avoiding defaults):
```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        display: ['Satoshi', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      colors: {
        primary: {
          50: '#EFF6FF',
          500: '#1E3A8A',    // Custom primary
          900: '#1E293B',
        },
        accent: {
          500: '#F59E0B',    // Custom accent
        },
      },
      spacing: {
        '18': '4.5rem',      // Custom spacing
        '72': '18rem',
      },
    },
  },
};
```

**Usage**:
```tsx
<div className="font-display text-primary-500">
  <h1 className="text-6xl font-bold">Title</h1>
  <p className="font-mono text-base">Body text</p>
</div>
```

**Guardian approval**:
```
✅ Tailwind Configuration Compliant with Design Standards

**Strengths**:
- Custom fonts (avoided default sans-serif)
- Custom color system
- Extended spacing (8px grid)

**Suggestions**:
- Add design token documentation
- Define complete typography scale
```

---

### Ant Design

**Setup**:
```bash
npm install antd
```

**Customization** (theme config):
```tsx
import { ConfigProvider } from 'antd';

const theme = {
  token: {
    colorPrimary: '#1E3A8A',    // Custom primary
    fontFamily: '"IBM Plex Sans", sans-serif',
    fontSize: 14,
    borderRadius: 8,
  },
  components: {
    Button: {
      primaryColor: '#1E3A8A',
      borderRadius: 8,
    },
  },
};

function App() {
  return (
    <ConfigProvider theme={theme}>
      {/* Your app */}
    </ConfigProvider>
  );
}
```

**Guardian approval**:
```
✅ Ant Design Configuration Compliant with Design Standards

**Strengths**:
- Avoided default blue
- Custom font
- Unified border radius (8px)

**Suggestions**:
- Define complete design token system
- Add dark mode support
```

---
