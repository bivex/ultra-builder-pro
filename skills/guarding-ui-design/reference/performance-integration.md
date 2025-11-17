## Performance Integration

### Core Web Vitals Monitoring

Guardian 建议在设计评审时同时检查性能指标：

**Largest Contentful Paint (LCP) < 2.5s**:
- 优化：图片懒加载、CDN、压缩
- 测量：Lighthouse CLI

**Interaction to Next Paint (INP) < 200ms**:
- 优化：CSS-first motion、避免 JS 阻塞
- 测量：Chrome DevTools

**Cumulative Layout Shift (CLS) < 0.1**:
- 优化：图片尺寸属性、骨架屏
- 测量：Layout Shift tracking

**Guardian 集成**：
```
✅ 设计符合性能最佳实践

**LCP 优化**：
- Hero 图片：WebP 格式（60% 体积减少）
- 字体加载：font-display: swap

**INP 优化**：
- Motion：CSS transitions（避免 JS）
- 交互：200ms 以内响应

**CLS 优化**：
- 图片：width/height 属性
- 动态内容：预留空间
```

---

