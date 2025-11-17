# Code Quality Guardian - Reference

## Quality Rules Source (Single Source of Truth)

**All quality rules are defined in**:
- **SOLID Principles**: See `@guidelines/ultra-solid-principles.md` for complete definitions and examples
- **Quality Standards**: See `@guidelines/ultra-quality-standards.md` for all baselines
- **Project Thresholds**: See `.ultra/ultra-quality-rules.yaml` for project-specific thresholds

This file only contains **detection algorithms** and does NOT duplicate rule definitions.

---

## Detection Algorithms

### Function Length Check
```javascript
// Algorithm: Count lines between function declaration and closing brace
// Threshold: Read from .ultra/ultra-quality-rules.yaml (default: 50 lines)
function detectLongFunction(functionNode, threshold) {
  const lineCount = functionNode.loc.end.line - functionNode.loc.start.line;
  if (lineCount > threshold) {
    return {
      violation: "Function exceeds max length",
      current: lineCount,
      threshold: threshold,
      suggestion: "Split into smaller functions"
    };
  }
  return null;
}
```

### Cyclomatic Complexity Check
```javascript
// Algorithm: Count decision points (if, for, while, case, &&, ||, ?, catch)
// Threshold: Read from .ultra/ultra-quality-rules.yaml (default: 10)
function detectHighComplexity(functionNode, threshold) {
  const complexity = calculateCyclomaticComplexity(functionNode);
  if (complexity > threshold) {
    return {
      violation: "Complexity exceeds threshold",
      current: complexity,
      threshold: threshold,
      suggestion: "Simplify branching logic or extract methods"
    };
  }
  return null;
}
```

### Code Duplication Check
```javascript
// Algorithm: Find identical code blocks exceeding threshold
// Threshold: Read from .ultra/ultra-quality-rules.yaml (default: 3 lines)
function detectDuplication(fileNode, threshold) {
  const duplicates = findDuplicateBlocks(fileNode, threshold);
  if (duplicates.length > 0) {
    return duplicates.map(dup => ({
      violation: "Duplicate code detected",
      lines: dup.lines,
      locations: dup.locations,
      suggestion: "Extract to shared function"
    }));
  }
  return null;
}
```

### Magic Number Detection
```javascript
// Algorithm: Find numeric literals (excluding 0, 1, -1)
// Threshold: Read from .ultra/ultra-quality-rules.yaml
function detectMagicNumbers(node) {
  const literals = findNumericLiterals(node);
  const magicNumbers = literals.filter(lit =>
    ![0, 1, -1].includes(lit.value) && !lit.hasComment
  );

  return magicNumbers.map(num => ({
    violation: "Magic number found",
    value: num.value,
    location: num.loc,
    suggestion: `Extract to named constant: const ${suggestName(num)} = ${num.value};`
  }));
}
```

### Nesting Depth Check
```javascript
// Algorithm: Calculate maximum nesting depth
// Threshold: Read from .ultra/ultra-quality-rules.yaml (default: 3 levels)
function detectDeepNesting(node, threshold) {
  const maxDepth = calculateMaxNestingDepth(node);
  if (maxDepth > threshold) {
    return {
      violation: "Nesting depth exceeds threshold",
      current: maxDepth,
      threshold: threshold,
      suggestion: "Extract nested blocks to separate functions or use early returns"
    };
  }
  return null;
}
```

### SOLID Violation Patterns

**Detection strategy**: Pattern matching against known anti-patterns.

#### SRP Violation Detection
```javascript
// Detect classes/functions with multiple unrelated responsibilities
function detectSRPViolation(node) {
  const responsibilities = identifyResponsibilities(node);
  if (responsibilities.length > 1) {
    return {
      violation: "Single Responsibility Principle violated",
      responsibilities: responsibilities,
      suggestion: `Split into ${responsibilities.length} separate classes/functions`
    };
  }
  return null;
}

// Helper: Identify responsibilities by method naming patterns
function identifyResponsibilities(classNode) {
  const methods = classNode.methods;
  const categories = {
    persistence: ['save', 'load', 'delete', 'update', 'insert'],
    communication: ['send', 'notify', 'email', 'message'],
    validation: ['validate', 'check', 'verify'],
    transformation: ['transform', 'convert', 'map', 'format'],
    calculation: ['calculate', 'compute', 'sum', 'total']
  };

  const found = new Set();
  methods.forEach(method => {
    for (const [category, keywords] of Object.entries(categories)) {
      if (keywords.some(kw => method.name.toLowerCase().includes(kw))) {
        found.add(category);
      }
    }
  });

  return Array.from(found);
}
```

#### OCP Violation Detection
```javascript
// Detect long if-else chains that require modification for extension
function detectOCPViolation(node) {
  const ifChains = findIfElseChains(node);
  const longChains = ifChains.filter(chain => chain.length > 3);

  return longChains.map(chain => ({
    violation: "Open/Closed Principle violated",
    chainLength: chain.length,
    suggestion: "Replace with strategy pattern or polymorphism"
  }));
}
```

---

## Output Format

All violations should be reported in this format:

```json
{
  "file": "path/to/file.ts",
  "violations": [
    {
      "type": "SOLID_SRP",
      "severity": "high",
      "line": 10,
      "message": "Class has 3 responsibilities: persistence, validation, communication",
      "suggestion": "Split into UserRepository, UserValidator, UserNotifier",
      "rule_source": "@guidelines/ultra-solid-principles.md#single-responsibility"
    },
    {
      "type": "COMPLEXITY",
      "severity": "medium",
      "line": 45,
      "message": "Cyclomatic complexity is 15 (threshold: 10)",
      "suggestion": "Simplify branching logic or extract methods",
      "rule_source": ".ultra/ultra-quality-rules.yaml#solid.max_complexity"
    }
  ]
}
```

---

## Integration with Commands

This detection logic is invoked by:
- `/ultra-dev` (REFACTOR phase)
- User explicitly runs quality check

**Note**: All rule definitions and examples are in `@guidelines/ultra-solid-principles.md`. Do NOT duplicate content here.


---

**OUTPUT: All examples show English templates. User messages output in Chinese at runtime; keep this file English-only.**
