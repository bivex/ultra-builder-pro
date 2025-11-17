# Test Strategy Guardian - Reference

## Testing Standards Source (Single Source of Truth)

**All testing standards and definitions are in**:
- **Six-Dimensional Testing**: See `@guidelines/ultra-quality-standards.md` for complete definitions, examples, and requirements
- **Coverage Requirements**: See `.ultra/ultra-quality-rules.yaml` for project-specific thresholds
- **Test Frameworks**: See `@guidelines/ultra-quality-standards.md` for framework recommendations

This file only contains **test execution guidance** and does NOT duplicate testing standard definitions.

---

## Six-Dimensional Test Execution Strategy

**Reference**: All dimension definitions and examples are in `@guidelines/ultra-quality-standards.md`

### Test Dimension Checklist

Before marking task complete, verify all 6 dimensions are covered:

- [ ] **Functional**: Core business logic tested
- [ ] **Boundary**: Edge cases (empty, max, min, null) tested
- [ ] **Exception**: Error handling tested
- [ ] **Performance**: Load tests/benchmarks executed
- [ ] **Security**: Input validation, injection prevention tested
- [ ] **Compatibility**: Cross-browser/platform tested (frontend only)

---

## Coverage Measurement Commands

**Thresholds defined in**: `.ultra/ultra-quality-rules.yaml`

### JavaScript/TypeScript
```bash
npm test -- --coverage
# Verify: coverage ≥80%, critical paths 100%, branches ≥75%
```

### Python
```bash
pytest --cov=src --cov-report=html
# Verify: coverage ≥80%
```

### Go
```bash
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
# Verify: coverage ≥80%
```

---

## Test Execution Checklist

### Before Running /ultra-test

1. [ ] All code changes committed
2. [ ] Test files created for new features
3. [ ] Mock external services (APIs, databases)
4. [ ] Environment variables configured

### During Test Execution

1. [ ] Run all 6 dimensions sequentially
2. [ ] Capture coverage report
3. [ ] Log failures with stack traces
4. [ ] Measure performance benchmarks

### After Test Execution

1. [ ] Verify coverage ≥80% overall
2. [ ] Verify critical paths 100%
3. [ ] Verify all 6 dimensions passed
4. [ ] Document any test debt in tasks.json

---

## Test Prioritization Strategy

### Priority 1: Critical Features
- Authentication, Payment processing, Data integrity
- **Required**: All 6 dimensions, 100% coverage

### Priority 2: Core Features
- User management, Business logic, API endpoints
- **Required**: All 6 dimensions, 90% coverage

### Priority 3: Supporting Features
- UI components, Utility functions, Display logic
- **Required**: Functional + Boundary + Exception, 80% coverage

---

**Complete Testing Standards**: `@guidelines/ultra-quality-standards.md`
