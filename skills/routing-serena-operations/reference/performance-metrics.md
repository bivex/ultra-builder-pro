## Performance Metrics

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**

---

### Token Efficiency

| Operation | Built-in | Serena | Efficiency Gain |
|-----------|----------|--------|-----------------|
| Large file read (8K lines) | 35K tokens | 500 tokens | 70x |
| Find references (50 refs) | 50K tokens | 5K tokens | 10x |
| Cross-file rename (20 files) | N/A (manual) | 3K tokens | ∞ (automation) |
| Architecture understanding | 100K+ tokens | 5K tokens | 20x |

### Time Savings

| Task | Built-in | Serena | Time Saved |
|------|----------|--------|------------|
| Rename across 23 files | 2.5 hours | 5 minutes | 96% |
| Understand 8K-line file | 1.5 hours | 20 minutes | 78% |
| Find all references | 45 minutes | 2 minutes | 96% |

### Error Rate Reduction

| Operation | Built-in Error Rate | Serena Error Rate | Improvement |
|-----------|---------------------|-------------------|-------------|
| Cross-file rename | 30% | 0% | 100% reduction |
| Reference finding | 64% false positives | 0% | 100% reduction |
| Large file read | 40% failure | 0% | 100% reduction |

---

