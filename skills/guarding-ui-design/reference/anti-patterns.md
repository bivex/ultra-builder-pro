## Common Anti-Patterns and Fixes

### Anti-Pattern 1: "Corporate Memphis" Illustrations

**Problem**: Generic flat illustrations with purple/blue colors

**Guardian detection**:
```
⚠️ 检测到 "Corporate Memphis" 风格

**问题**：
- 过度使用的插画风格
- 缺乏品牌个性
- "AI slop" 特征

**替代方案**：
1. 真实产品截图（最佳）
2. 自定义插画（品牌风格）
3. 抽象几何图形（现代简约）
4. 3D 渲染（高级感）

**避免**：
❌ Undraw 默认配色
❌ 紫色渐变人物
❌ 浮动几何形状
```

---

### Anti-Pattern 2: "Startup Landing Page" Template

**Problem**: Generic template structure (Hero + Features + CTA)

**Guardian suggestion**:
```
⚠️ 检测到通用模板结构

**问题**：
- 缺乏差异化
- 信息架构平庸

**建议优化**：

1. **打破常规布局**：
   - 非对称网格
   - 对角线分割
   - 意外的滚动体验

2. **强化品牌个性**：
   - 独特的色彩系统
   - 定制字体配对
   - 品牌插画风格

3. **信息层级创新**：
   - 数据可视化优先
   - 社会证明前置
   - 互动式 Demo

**参考案例**：
- Linear.app（简约克制）
- Stripe.com（数据驱动）
- Vercel.com（技术美学）
```

---

### Anti-Pattern 3: Inconsistent Spacing

**Problem**: Random spacing values (7px, 13px, 19px)

**Guardian detection**:
```
❌ 检测到不一致间距系统

**发现的间距值**：
- 7px, 13px, 19px, 23px, 31px（随机值）

**问题**：
- 视觉混乱
- 难以维护
- 缺乏系统性

**建议：8px Grid 系统**

/* 定义间距 token */
:root {
  --space-1: 8px;    /* 0.5rem */
  --space-2: 16px;   /* 1rem */
  --space-3: 24px;   /* 1.5rem */
  --space-4: 32px;   /* 2rem */
  --space-6: 48px;   /* 3rem */
  --space-8: 64px;   /* 4rem */
}

/* 使用 token */
.card {
  padding: var(--space-4);
  margin-bottom: var(--space-3);
}

**迁移工具**：
运行：npx @spacing-lint/cli 检测不一致间距
```

**Auto-fix**:
```bash
# 自动修复间距
npx @spacing-lint/cli --fix --grid=8
```

---

