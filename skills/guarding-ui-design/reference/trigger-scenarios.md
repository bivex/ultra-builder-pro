## Trigger Scenarios

### Scenario 1: Creating New Component

**User action**: Creating `Button.tsx`

**Trigger**: File extension `.tsx` detected

**Guardian activates**: Check for default fonts, hard-coded colors, clichéd patterns

**Example output** (in Chinese at runtime):
```
🎨 UI 设计建议

检测到新组件创建：Button.tsx

**避免的反模式**：
❌ 不要使用默认字体（Inter, Roboto, Open Sans）
❌ 不要硬编码颜色值
❌ 不要使用孤立的紫色渐变

**推荐设计模式**：
✅ 使用设计 token 系统（CSS 变量）
✅ 采用成熟的组件库（MUI, Ant Design, Chakra）
✅ 保持一致的间距系统（8px grid）

详见完整建议...
```

---

### Scenario 2: Editing Styles

**User action**: Editing `App.css` with hard-coded colors

**Trigger**: `.css` file modified + discussion about styling

**Guardian activates**: Check for design tokens, suggest migration

**Example output**:
```
⚠️ 设计债务警告

检测到硬编码颜色：
- `color: #3B82F6` (17 处)
- `background: #8B5CF6` (8 处)

**问题**：
- 无法统一切换主题
- 维护成本高（需逐个修改）
- 无法支持暗色模式

**建议迁移到设计 token**：

/* 1. 定义 CSS 变量 */
:root {
  --color-primary: #3B82F6;
  --color-accent: #8B5CF6;
}

/* 2. 使用 token */
.button {
  color: var(--color-primary);
}

**迁移效果**：
- 主题切换：1 秒（修改变量定义）
- 暗色模式：自动支持（定义暗色变量）
- 维护成本：降低 80%
```

---

### Scenario 3: Discussing UI Design

**User action**: "Help me design a modern dashboard"

**Trigger**: Keywords "design" + "dashboard" + file context (React project)

**Guardian activates**: Suggest cohesive design approach

**Example output**:
```
🎨 Dashboard 设计建议

**Typography（3x 层级跳跃）**：
- 标题：48px (bold)
- 副标题：16px (medium)
- 正文：12px (regular)
- 比例：4:1.33:1 (高对比度)

**字体配对建议**：
方案 1（专业）：Inter Display + JetBrains Mono
方案 2（现代）：Satoshi + IBM Plex Mono
方案 3（优雅）：Fraunces + Space Mono

**颜色系统**：
主色：选择 1 个主导色（不要紫色渐变）
示例：深蓝系（#1E3A8A）+ 中性灰（#64748B）

**组件库推荐**：
- MUI (Material Design 3) - 最成熟
- Ant Design - 中后台标准
- Chakra UI - 灵活定制

**Motion 设计**：
- 页面加载：编排式揭示动画（stagger 100ms）
- 交互反馈：CSS transition（200ms ease-out）
- 避免：随意的微交互

详细实现见下文...
```

---

