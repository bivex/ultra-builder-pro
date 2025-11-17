#!/bin/bash

# Ultra Builder Pro 4.1 - Documentation Consistency Verification Script
# Purpose: Prevent documentation-implementation mismatches
# Usage: ./tests/verify-documentation-consistency.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
pass() {
    echo -e "${GREEN}✅ PASS:${NC} $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}❌ FAIL:${NC} $1"
    ((TESTS_FAILED++))
}

warn() {
    echo -e "${YELLOW}⚠️  WARN:${NC} $1"
}

# ============================================================================
# Test 1: Skills count matches across all sources
# ============================================================================
echo "Test 1: Skills count consistency"

# Count actual skill directories
ACTUAL_COUNT=$(ls -1 "$PROJECT_ROOT/skills" | wc -l | tr -d ' ')

# Extract declared count from ultra-skills-guide.md
DECLARED_COUNT=$(grep '([0-9]* total)' "$PROJECT_ROOT/config/ultra-skills-guide.md" | head -1 | sed 's/.*(\([0-9]*\) total).*/\1/')

# Extract count from config.json
CONFIG_COUNT=$(jq '.tools.skills | length' "$PROJECT_ROOT/.ultra-template/config.json")

if [ "$ACTUAL_COUNT" = "$DECLARED_COUNT" ] && [ "$ACTUAL_COUNT" = "$CONFIG_COUNT" ]; then
    pass "Skills count matches: actual=$ACTUAL_COUNT, declared=$DECLARED_COUNT, config=$CONFIG_COUNT"
else
    fail "Skills count mismatch: actual=$ACTUAL_COUNT, declared=$DECLARED_COUNT, config=$CONFIG_COUNT"
fi

# ============================================================================
# Test 2: All declared skills exist in filesystem
# ============================================================================
echo ""
echo "Test 2: Declared skills exist in filesystem"

# Extract skill names from ultra-skills-guide.md (### N. skill-name format)
# Using sed instead of grep -P for macOS compatibility
DECLARED_SKILLS=$(grep '^### [0-9]*\. [a-z]' "$PROJECT_ROOT/config/ultra-skills-guide.md" | sed 's/^### [0-9]*\. \([a-z0-9-]*\).*/\1/' | sort)

SKILL_EXIST_FAILED=0
for skill in $DECLARED_SKILLS; do
    if [ -d "$PROJECT_ROOT/skills/$skill" ]; then
        : # Skill exists, do nothing
    else
        fail "Declared skill '$skill' not found in skills/ directory"
        ((SKILL_EXIST_FAILED++))
    fi
done

if [ $SKILL_EXIST_FAILED -eq 0 ]; then
    pass "All declared skills exist in filesystem"
fi

# ============================================================================
# Test 3: config.json skills match filesystem
# ============================================================================
echo ""
echo "Test 3: config.json skills match filesystem"

CONFIG_SKILLS=$(jq -r '.tools.skills | keys[]' "$PROJECT_ROOT/.ultra-template/config.json" | sort)
FS_SKILLS=$(ls -1 "$PROJECT_ROOT/skills" | sort)

if [ "$CONFIG_SKILLS" = "$FS_SKILLS" ]; then
    pass "config.json skills match filesystem"
else
    fail "config.json skills don't match filesystem"
    echo "Expected (config.json):"
    echo "$CONFIG_SKILLS"
    echo ""
    echo "Actual (filesystem):"
    echo "$FS_SKILLS"
fi

# ============================================================================
# Test 4: No inappropriate references to old skill names
# ============================================================================
echo ""
echo "Test 4: No inappropriate references to old skill names"

OLD_SKILL_NAMES="ultra-file-router|ultra-serena-advisor"

# Search for old problematic names (excluding expected locations)
OLD_REFS=$(grep -r -E "$OLD_SKILL_NAMES" "$PROJECT_ROOT" \
    --include="*.md" \
    --exclude-dir=".deprecated" \
    --exclude-dir=".git" \
    --exclude-dir=".backup" \
    --exclude="MIGRATION_GUIDE.md" \
    --exclude="migration-notes.md" \
    --exclude="verify-documentation-consistency.sh" \
    --exclude="ULTRA_BUILDER_PRO_4.1_QUICK_START.md" \
    2>/dev/null | grep -v "REFERENCE.md" | grep -v "routing-serena-operations" || true)

if [ -z "$OLD_REFS" ]; then
    pass "No inappropriate references to old skill names found"
else
    fail "Found inappropriate references to old skill names:"
    echo "$OLD_REFS"
fi

# ============================================================================
# Test 5: Skills numbering is sequential (1-N)
# ============================================================================
echo ""
echo "Test 5: Skills numbering is sequential"

# Extract skill numbers using sed for macOS compatibility
SKILL_NUMBERS=$(grep '^### [0-9]*\. [a-z]' "$PROJECT_ROOT/config/ultra-skills-guide.md" | sed 's/^### \([0-9]*\)\..*/\1/' | sort -n | tr '\n' ' ')
EXPECTED_SEQUENCE=$(seq 1 $ACTUAL_COUNT | tr '\n' ' ')

if [ "$SKILL_NUMBERS" = "$EXPECTED_SEQUENCE" ]; then
    pass "Skills numbering is sequential (1-$ACTUAL_COUNT)"
else
    fail "Skills numbering is NOT sequential"
    echo "Expected: $EXPECTED_SEQUENCE"
    echo "Actual: $SKILL_NUMBERS"
fi

# ============================================================================
# Test 6: CLAUDE.md lists correct skill count
# ============================================================================
echo ""
echo "Test 6: CLAUDE.md Skills System header"

CLAUDE_HEADER=$(grep "## Skills System" "$PROJECT_ROOT/CLAUDE.md" | head -1)

if echo "$CLAUDE_HEADER" | grep -q "$ACTUAL_COUNT Auto-Loaded"; then
    pass "CLAUDE.md correctly shows '$ACTUAL_COUNT Auto-Loaded'"
else
    fail "CLAUDE.md header doesn't match actual count ($ACTUAL_COUNT)"
    echo "Found: $CLAUDE_HEADER"
fi

# ============================================================================
# Test 7: All SKILL.md files have correct 'name' field
# ============================================================================
echo ""
echo "Test 7: SKILL.md files have correct 'name' field"

NAME_MISMATCH=0
for skill_dir in "$PROJECT_ROOT/skills"/*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        skill_file="$skill_dir/SKILL.md"

        if [ -f "$skill_file" ]; then
            # Use sed instead of grep -P for macOS compatibility
            declared_name=$(grep '^name: ' "$skill_file" | head -1 | sed 's/^name: //')

            if [ "$declared_name" = "$skill_name" ]; then
                : # Match, do nothing
            else
                fail "SKILL.md name mismatch: directory='$skill_name', declared='$declared_name'"
                ((NAME_MISMATCH++))
            fi
        else
            warn "No SKILL.md found in $skill_dir"
        fi
    fi
done

if [ $NAME_MISMATCH -eq 0 ]; then
    pass "All SKILL.md files have correct 'name' field"
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo "========================================"
echo "Test Summary"
echo "========================================"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed! Documentation is consistent.${NC}"
    exit 0
else
    echo -e "${RED}❌ $TESTS_FAILED test(s) failed. Please fix the issues above.${NC}"
    exit 1
fi
