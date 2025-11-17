## Performance Integration

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Core Web Vitals Monitoring

Guardian recommends checking performance metrics during design review:

**Largest Contentful Paint (LCP) < 2.5s**:
- Optimization: Image lazy loading, CDN, compression
- Measurement: Lighthouse CLI

**Interaction to Next Paint (INP) < 200ms**:
- Optimization: CSS-first motion, avoid JS blocking
- Measurement: Chrome DevTools

**Cumulative Layout Shift (CLS) < 0.1**:
- Optimization: Image size attributes, skeleton screens
- Measurement: Layout Shift tracking

**Guardian integration**:
```
✅ Design Compliant with Performance Best Practices

**LCP Optimization**:
- Hero images: WebP format (60% size reduction)
- Font loading: font-display: swap

**INP Optimization**:
- Motion: CSS transitions (avoid JS)
- Interactions: < 200ms response

**CLS Optimization**:
- Images: width/height attributes
- Dynamic content: Reserved space
```

---
