## Design Suggestions with Code

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

**Output to user** (in Chinese):
```
📏 Typography 层级优化

**问题**：当前尺寸跳跃过小（1.5x），层级不明显

**建议**：3x+ 尺寸跳跃

h1: 48px (4x 基准)
h2: 24px (2x 基准)
p:  16px (1.33x 基准)
caption: 12px (基准)

**代码示例**：见上方

**效果**：
- 视觉层级清晰 +80%
- 信息扫读速度 +40%
- 专业度提升
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
🎨 颜色系统优化

**问题**：多色平权（无主导色）

**建议**：1 主色 + 点缀色

**配色比例**：
- 主色（70%）：深蓝系 #1E3A8A
- 点缀色（20%）：橙色 #F59E0B
- 语义色（10%）：成功/错误

**代码示例**：见上方

**效果**：
- 视觉统一性 +90%
- 品牌识别度提升
- 信息层级清晰
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
✨ Motion 设计优化

**问题**：过度依赖 JS 动画库（性能影响）

**建议**：CSS 优先策略

**页面加载动画**：
- 编排式揭示（stagger 100ms）
- fadeInUp 动画（400ms ease-out）
- 3-5 个元素依次出现

**交互反馈**：
- CSS transition（200ms）
- hover 状态提升（translateY -2px）
- 阴影加深

**性能指标**：
- INP < 200ms（Core Web Vitals）
- 60fps 流畅度

**代码示例**：见上方
```

---

