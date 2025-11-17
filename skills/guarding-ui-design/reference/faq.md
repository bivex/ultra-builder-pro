## FAQ

### Q1: 我必须使用特定的设计系统吗？

**A**: 不。Guardian **不强制**特定设计系统（Material Design, Tailwind 等都可以）。

Guardian **强制**的是：
- ❌ 避免默认字体（Inter, Roboto, Open Sans）
- ❌ 避免硬编码颜色
- ❌ 避免紫色渐变陈词滥调

Guardian **建议**的是：
- ✅ Typography 层级（3x+ 尺寸跳跃）
- ✅ 颜色系统（1 主色 + 点缀色）
- ✅ 使用成熟的组件库

---

### Q2: 如果项目已经使用了 Inter 字体怎么办？

**A**: Guardian 会建议迁移，但不会阻止你继续使用。

**建议迁移路径**：
1. **评估影响**：字体切换是否影响品牌识别？
2. **渐进迁移**：先在新组件使用新字体，观察效果
3. **品牌一致性**：如果 Inter 是品牌指南的一部分，可以保留（添加例外说明）

**例外处理**：
```css
/* 如果 Inter 是品牌字体，添加注释说明 */
:root {
  /* Brand guideline: Inter is our corporate font */
  --font-brand: 'Inter', sans-serif;
}
```

Guardian 会识别注释并停止警告。

---

### Q3: 如何处理客户要求使用特定颜色（如企业蓝）？

**A**: Guardian 支持自定义主色，但会检查是否使用设计 token。

**正确做法**：
```css
:root {
  /* Client brand color: Enterprise Blue */
  --color-primary: #0052CC;  /* 企业蓝 */
}

.button-primary {
  background-color: var(--color-primary);
}
```

Guardian 会批准这种做法（使用了设计 token）。

**错误做法**：
```css
.button-primary {
  background-color: #0052CC;  /* ❌ 硬编码 */
}
```

Guardian 会警告并建议使用 token。

---

### Q4: 暗色模式是强制的吗？

**A**: 不强制，但**强烈建议**使用设计 token 以便未来支持。

**最佳实践**：
```css
/* 1. 定义 light mode（默认） */
:root {
  --color-bg: #FFFFFF;
  --color-text: #0F172A;
}

/* 2. 定义 dark mode（可选） */
[data-theme="dark"] {
  --color-bg: #0F172A;
  --color-text: #F8FAFC;
}

/* 3. 使用 token */
body {
  background-color: var(--color-bg);
  color: var(--color-text);
}
```

**好处**：
- 未来支持暗色模式：1 分钟完成
- 主题切换：用户偏好设置
- 可访问性：减少眼睛疲劳

---

### Q5: 如何知道我的设计是否"现代"？

**A**: Guardian 不评判"现代"（主观），而是检查：

**客观指标**：
1. ✅ 避免通用模式（默认字体、紫色渐变）
2. ✅ 系统化设计（设计 token、间距 grid）
3. ✅ 性能指标（Core Web Vitals）
4. ✅ 可访问性（WCAG 2.1 AA）

**主观评估**（由你决定）：
- 品牌个性表达
- 视觉独特性
- 用户体验创新

Guardian 确保你避开"AI slop"，但**创意由你主导**。

---

### Q6: Guardian 会检查响应式设计吗？

**A**: Guardian **不直接检查**响应式断点，但会**建议**使用标准断点。

**推荐断点**（基于统计数据）：
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

**组件库默认**：
- MUI: 600px, 960px, 1280px
- Tailwind: 640px, 768px, 1024px, 1280px, 1536px
- Ant Design: 576px, 768px, 992px, 1200px, 1600px

Guardian 会建议使用组件库的标准断点（一致性）。

---

### Q7: 如何处理第三方组件的默认样式？

**A**: Guardian 建议**覆盖**第三方组件的默认样式。

**示例：MUI Button**
```tsx
import { Button } from '@mui/material';

// ❌ 使用默认样式
<Button>Click me</Button>

// ✅ 覆盖默认样式
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

**或使用主题覆盖**：
```tsx
const theme = createTheme({
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          fontFamily: 'var(--font-display)',
          textTransform: 'none',  // 移除默认大写
        },
      },
    },
  },
});
```

---

