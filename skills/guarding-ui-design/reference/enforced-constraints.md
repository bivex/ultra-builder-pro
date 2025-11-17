## Enforced Constraints Examples

### Constraint 1: Default Fonts (BLOCKED)

**Bad code** ❌:
```css
body {
  font-family: 'Inter', sans-serif; /* ❌ Default font */
}
```

**Guardian intervention** (in Chinese):
```
❌ 检测到默认字体：Inter

**问题**：分布式收敛（所有 AI 生成的 UI 看起来一样）

**替代方案**：

方案 1（专业）：
font-family: 'Inter Display', 'JetBrains Mono', monospace;

方案 2（现代）：
font-family: 'Satoshi', 'IBM Plex Mono', monospace;

方案 3（优雅）：
font-family: 'Fraunces', 'Space Mono', monospace;

**规则**：显示字体 + 等宽字体配对（高对比度）
```

**Good code** ✅:
```css
:root {
  --font-display: 'Satoshi', system-ui;
  --font-mono: 'IBM Plex Mono', monospace;
}

body {
  font-family: var(--font-display);
}

code, pre {
  font-family: var(--font-mono);
}
```

---

### Constraint 2: Hard-Coded Colors (BLOCKED)

**Bad code** ❌:
```tsx
<button style={{ backgroundColor: '#3B82F6', color: '#FFFFFF' }}>
  Click me
</button>
```

**Guardian intervention**:
```
❌ 检测到硬编码颜色

**问题**：
- 无法切换主题
- 无法支持暗色模式
- 维护成本高

**建议使用设计 token**：

/* tokens.css */
:root {
  --color-primary: #3B82F6;
  --color-on-primary: #FFFFFF;
}

[data-theme="dark"] {
  --color-primary: #60A5FA;
  --color-on-primary: #1E293B;
}

/* Component */
<button className="btn-primary">Click me</button>

.btn-primary {
  background-color: var(--color-primary);
  color: var(--color-on-primary);
}
```

**Good code** ✅:
```tsx
// Using design tokens
<button className={styles.primary}>Click me</button>

// styles.module.css
.primary {
  background-color: var(--color-primary);
  color: var(--color-on-primary);
}
```

---

### Constraint 3: Purple Gradients (BLOCKED)

**Bad code** ❌:
```css
.hero {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

**Guardian intervention**:
```
❌ 检测到紫色渐变反模式

**问题**：AI 生成 UI 的常见陈词滥调（"AI slop"）

**替代方案**：

方案 1（深度氛围）：
background: linear-gradient(135deg, #1E3A8A 0%, #0F172A 100%);
/* 深蓝到深灰，专业感 */

方案 2（暖色调）：
background: linear-gradient(135deg, #DC2626 0%, #991B1B 100%);
/* 红色系，活力感 */

方案 3（微妙纹理）：
background: #F8FAFC;
background-image:
  radial-gradient(circle at 25% 25%, rgba(59,130,246,0.05) 0%, transparent 50%);
/* 微妙光效，现代感 */
```

**Good code** ✅:
```css
.hero {
  background: var(--color-surface);
  background-image:
    radial-gradient(
      circle at 25% 25%,
      var(--color-accent-alpha-10) 0%,
      transparent 50%
    );
}
```

---

