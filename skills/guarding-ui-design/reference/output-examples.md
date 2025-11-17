## Output Examples (Chinese)

### Example 1: New Component Creation

**Scenario**: User creates `Dashboard.tsx`

**Guardian output** (in Chinese at runtime):
```
🎨 UI 设计建议 - Dashboard 组件

**检测到的潜在问题**：
1. ⚠️ 未定义设计 token（可能使用硬编码颜色）
2. ⚠️ 未指定字体（可能使用默认字体）

**推荐设计方案**：

**1. 设计系统选择**
   - 推荐：Ant Design（中后台标准）
   - 备选：MUI (Material Design 3)
   - 自定义：基于 Radix + Tailwind

**2. Typography 系统**
   - 标题：32px bold（Satoshi）
   - 卡片标题：16px semibold
   - 正文：14px regular（IBM Plex Sans）
   - 数据：24px bold（JetBrains Mono）

**3. 颜色系统**
   主色：深蓝 #1E3A8A（70%）
   点缀色：橙色 #F59E0B（20%）
   中性灰：#64748B（背景、边框）

**4. 布局建议**
   - Grid: 12 列系统
   - Spacing: 8px 基准（8, 16, 24, 32）
   - Breakpoints: 768px, 1024px, 1440px

**5. Motion 设计**
   - 页面加载：卡片依次 fadeInUp（stagger 100ms）
   - 数据刷新：淡入淡出（300ms）
   - 交互：微妙 hover 效果（transform scale 1.02）

**实现参考**：
- 完整代码示例：见 REFERENCE.md
- 设计系统文档：见 examples/ant-design-dashboard.md
```

---

### Example 2: Style File Edit (Blocking Hard-Coded Colors)

**Scenario**: User edits CSS with hard-coded colors

**Guardian output**:
```
❌ 设计债务检测 - 硬编码颜色

**检测到 23 处硬编码颜色**：
- #3B82F6 (蓝色) - 12 处
- #8B5CF6 (紫色) - 8 处
- #FFFFFF (白色) - 3 处

**问题分析**：
1. 无法统一切换主题
2. 暗色模式支持困难
3. 品牌色调整需修改 23 处
4. 维护成本高（80% 时间浪费）

**建议迁移方案**：

**步骤 1：定义设计 token**
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

**步骤 2：替换硬编码值**
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

**迁移效果**：
- ✅ 主题切换：23 处 → 1 处修改
- ✅ 暗色模式：自动支持
- ✅ 品牌调整：1 分钟完成
- ✅ 维护成本：降低 80%

**自动迁移工具**（可选）：
运行：`npx @csstools/postcss-design-tokens` 自动转换
```

---

### Example 3: Design Discussion

**Scenario**: User asks "如何设计一个现代感的 Landing Page？"

**Guardian output**:
```
🎨 Landing Page 现代化设计建议

**核心设计原则**：

**1. Hero Section（视觉冲击）**

Typography：
- 主标题：64px ultra-bold（Fraunces）
- 副标题：20px light（Space Grotesk）
- 比例：3.2:1（高对比度）

背景设计：
- 避免：紫色渐变（陈词滥调）
- 推荐：微妙光效 + 深色背景

```css
.hero {
  background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
  background-image:
    radial-gradient(circle at 30% 20%, rgba(59,130,246,0.1) 0%, transparent 50%),
    radial-gradient(circle at 70% 80%, rgba(245,158,11,0.08) 0%, transparent 50%);
}
```

**2. Color System（品牌识别）**

主色选择：
- 深蓝：#1E3A8A（信任、专业）
- 深红：#991B1B（活力、决心）
- 深绿：#065F46（成长、稳定）

点缀色：橙色 #F59E0B（行动召唤）

**3. Motion Design（视觉流程）**

页面加载顺序：
1. Hero 标题：fadeInUp（0ms delay）
2. 副标题：fadeInUp（100ms delay）
3. CTA 按钮：fadeInUp（200ms delay）
4. Hero 图片：fadeIn（300ms delay）

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

**4. 组件库推荐**

方案 1（快速）：
- Chakra UI + Framer Motion
- 优势：组件丰富，定制灵活

方案 2（专业）：
- MUI + Material Design 3
- 优势：成熟稳定，最佳实践

方案 3（定制）：
- Radix + Tailwind + shadcn/ui
- 优势：完全控制，无样式约束

**5. 完整示例**

参考实现：
- examples/landing-page-modern.tsx
- examples/landing-page-minimal.tsx
- examples/landing-page-bold.tsx

**6. 性能指标**

Core Web Vitals 目标：
- LCP < 2.5s（首屏加载）
- INP < 200ms（交互响应）
- CLS < 0.1（布局稳定）

测量工具：Lighthouse CLI
```

---

