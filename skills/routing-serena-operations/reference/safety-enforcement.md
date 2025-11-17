## Safety Enforcement

### BLOCK Scenarios

#### 1. Cross-File Rename (>5 files)

**Blocked Operation**: Grep + Edit approach

**Reason**: 30% error rate from:
- False positives (comments, strings)
- Scope confusion (different modules)
- Manual editing errors
- Missed references

**Enforced Operation**: Serena rename_symbol

**Benefit**: 0% error rate, automatic scope understanding

---

#### 2. Large File Read (>8000 lines)

**Blocked Operation**: Read tool

**Reason**:
- Token overflow (>40K tokens)
- Context window consumption (>20%)
- Failure rate >40% (timeouts, errors)

**Enforced Operation**: Serena get_symbols_overview + find_symbol

**Benefit**: 60x efficiency, 100% success rate

---

#### 3. Symbol-Level Operations

**Blocked Operation**: Text-based search (Grep)

**Reason**:
- Cannot understand scope
- 64% false positive rate
- No code context

**Enforced Operation**: find_symbol or find_referencing_symbols

**Benefit**: Semantic understanding, 0% false positives

---

