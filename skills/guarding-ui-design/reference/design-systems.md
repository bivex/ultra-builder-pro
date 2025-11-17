## Integration with Design Systems

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
✅ MUI 配置符合设计规范

**优点**：
- 避免了默认字体（Roboto）
- 自定义主色（避免默认蓝色）
- 使用 8px spacing grid

**建议**：
- 添加暗色模式支持
- 定义完整的 spacing 系统（8, 16, 24, 32, 40, 48）
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
✅ Tailwind 配置符合设计规范

**优点**：
- 自定义字体（避免默认 sans-serif）
- 自定义颜色系统
- 扩展 spacing（8px grid）

**建议**：
- 添加设计 token 文档
- 定义完整的 typography scale
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
✅ Ant Design 配置符合设计规范

**优点**：
- 避免了默认蓝色
- 自定义字体
- 统一圆角（8px）

**建议**：
- 定义完整的 design token 系统
- 添加暗色模式支持
```

---

