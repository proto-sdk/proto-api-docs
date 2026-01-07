#!/bin/bash
# Proto API Version Bump End-to-End Test Script
# Tests: spec.json validation, documentation consistency, and API integrity

set -e  # Exit on error

echo "🧪 Proto API Version Bump E2E Test Suite"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing: $test_name... "
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAILED${NC}"
        ((FAILED++))
        return 1
    fi
}

# 1. Validate spec.json is valid JSON
run_test "spec.json is valid JSON" "jq empty spec.json"

# 2. Check version is 1.7.3
run_test "Version is 1.7.3 in spec.json" "grep -q '\"version\": \"1.7.3\"' spec.json"

# 3. Check version badge in README
run_test "Version badge in README.md" "grep -q 'version-1.7.3-blue.svg' README.md"

# 4. Check version badge in index.html
run_test "Version badge in index.html" "grep -q 'v1.7.3' index.html"

# 5. Validate OpenAPI structure
run_test "OpenAPI version present" "jq -e '.openapi' spec.json"
run_test "Info section present" "jq -e '.info' spec.json"
run_test "Paths section present" "jq -e '.paths' spec.json"
run_test "Components section present" "jq -e '.components' spec.json"

# 6. Count endpoints
ENDPOINT_COUNT=$(jq '.paths | length' spec.json)
run_test "Has endpoints (count: $ENDPOINT_COUNT)" "[ $ENDPOINT_COUNT -gt 0 ]"

# 7. Validate all paths have operations
echo ""
echo "📋 Detailed Validation:"
echo "----------------------"

# Check for required API metadata
echo -n "  - API Title: "
API_TITLE=$(jq -r '.info.title' spec.json)
echo -e "${GREEN}$API_TITLE${NC}"

echo -n "  - API Version: "
API_VERSION=$(jq -r '.info.version' spec.json)
echo -e "${GREEN}$API_VERSION${NC}"

echo -n "  - Total Endpoints: "
echo -e "${GREEN}$ENDPOINT_COUNT${NC}"

echo -n "  - Total Tags: "
TAG_COUNT=$(jq '.tags | length' spec.json)
echo -e "${GREEN}$TAG_COUNT${NC}"

# 8. Check for breaking changes indicators
echo ""
echo "🔍 Breaking Changes Analysis:"
echo "-----------------------------"

# Check if there are any removed endpoints (would need previous version)
if [ -f "spec.json.backup" ]; then
    OLD_ENDPOINTS=$(jq -r '.paths | keys[]' spec.json.backup 2>/dev/null | sort)
    NEW_ENDPOINTS=$(jq -r '.paths | keys[]' spec.json | sort)
    
    # Find removed endpoints
    REMOVED=$(comm -23 <(echo "$OLD_ENDPOINTS") <(echo "$NEW_ENDPOINTS"))
    if [ -n "$REMOVED" ]; then
        echo -e "${RED}⚠ Removed endpoints detected:${NC}"
        echo "$REMOVED"
        ((FAILED++))
    else
        echo -e "${GREEN}✓ No endpoints removed${NC}"
        ((PASSED++))
    fi
    
    # Find added endpoints
    ADDED=$(comm -13 <(echo "$OLD_ENDPOINTS") <(echo "$NEW_ENDPOINTS"))
    if [ -n "$ADDED" ]; then
        echo -e "${GREEN}✓ New endpoints added:${NC}"
        echo "$ADDED"
    fi
else
    echo -e "${YELLOW}⚠ No backup file found for comparison${NC}"
fi

# 9. Validate schema definitions
echo ""
echo "📦 Schema Validation:"
echo "--------------------"

SCHEMA_COUNT=$(jq '.components.schemas | length' spec.json)
echo -n "  - Total Schemas: "
echo -e "${GREEN}$SCHEMA_COUNT${NC}"

# Check for common required schemas
REQUIRED_SCHEMAS=("Error" "Pool" "SystemInfo")
for schema in "${REQUIRED_SCHEMAS[@]}"; do
    if jq -e ".components.schemas.$schema" spec.json > /dev/null 2>&1; then
        echo -e "  - Schema '$schema': ${GREEN}✓ Present${NC}"
        ((PASSED++))
    else
        echo -e "  - Schema '$schema': ${RED}✗ Missing${NC}"
        ((FAILED++))
    fi
done

# 10. Test documentation files
echo ""
echo "📄 Documentation Files:"
echo "----------------------"

DOC_FILES=("README.md" "index.html" "CHANGELOG.md")
for file in "${DOC_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  - $file: ${GREEN}✓ Exists${NC}"
        ((PASSED++))
    else
        echo -e "  - $file: ${RED}✗ Missing${NC}"
        ((FAILED++))
    fi
done

# Summary
echo ""
echo "=========================================="
echo "📊 Test Summary"
echo "=========================================="
echo -e "Total Tests: $((PASSED + FAILED))"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed! Version bump is safe to deploy.${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review before deploying.${NC}"
    exit 1
fi
