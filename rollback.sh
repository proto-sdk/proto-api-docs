#!/bin/bash
# Quick rollback script for Proto API
# Usage: ./rollback.sh [--force] [--to-commit <hash>]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
FORCE=false
TARGET_COMMIT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE=true
            shift
            ;;
        --to-commit)
            TARGET_COMMIT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--force] [--to-commit <hash>]"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🔄 Proto API Rollback Script${NC}"
echo "=============================="
echo ""

# Get current version
CURRENT_VERSION=$(jq -r '.info.version' spec.json)
echo -e "Current Version: ${YELLOW}$CURRENT_VERSION${NC}"

# Get previous version from git
if [ -z "$TARGET_COMMIT" ]; then
    git show HEAD~1:spec.json > /tmp/prev_spec.json 2>/dev/null || {
        echo -e "${RED}Error: Cannot find previous version${NC}"
        exit 1
    }
    PREVIOUS_VERSION=$(jq -r '.info.version' /tmp/prev_spec.json)
    TARGET_COMMIT="HEAD~1"
else
    git show $TARGET_COMMIT:spec.json > /tmp/prev_spec.json 2>/dev/null || {
        echo -e "${RED}Error: Cannot find commit $TARGET_COMMIT${NC}"
        exit 1
    }
    PREVIOUS_VERSION=$(jq -r '.info.version' /tmp/prev_spec.json)
fi

echo -e "Target Version: ${GREEN}$PREVIOUS_VERSION${NC}"
echo ""

# Confirm rollback
if [ "$FORCE" = false ]; then
    echo -e "${YELLOW}⚠️  WARNING: This will rollback the API version${NC}"
    echo "This action will:"
    echo "  1. Create a backup branch"
    echo "  2. Revert to version $PREVIOUS_VERSION"
    echo "  3. Run validation tests"
    echo "  4. Push changes to remote"
    echo ""
    read -p "Are you sure you want to continue? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo -e "${BLUE}Rollback cancelled.${NC}"
        exit 0
    fi
fi

# Create backup branch
BACKUP_BRANCH="backup-before-rollback-$(date +%Y%m%d_%H%M%S)"
echo ""
echo -e "${BLUE}📝 Creating backup branch: $BACKUP_BRANCH${NC}"
git branch $BACKUP_BRANCH
echo -e "${GREEN}✓ Backup branch created${NC}"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error: You have uncommitted changes. Please commit or stash them first.${NC}"
    exit 1
fi

# Perform rollback
echo ""
echo -e "${BLUE}⏪ Reverting to previous version...${NC}"

if [ "$TARGET_COMMIT" = "HEAD~1" ]; then
    git revert HEAD --no-edit
else
    git revert $TARGET_COMMIT --no-edit
fi

echo -e "${GREEN}✓ Revert commit created${NC}"

# Verify version
NEW_VERSION=$(jq -r '.info.version' spec.json)
if [ "$NEW_VERSION" != "$PREVIOUS_VERSION" ]; then
    echo -e "${RED}Error: Version mismatch after rollback${NC}"
    echo "Expected: $PREVIOUS_VERSION"
    echo "Got: $NEW_VERSION"
    echo ""
    echo "Rolling back the rollback..."
    git reset --hard HEAD~1
    exit 1
fi

echo -e "${GREEN}✓ Version verified: $NEW_VERSION${NC}"

# Run tests if test script exists
if [ -f "test_version_bump.sh" ]; then
    echo ""
    echo -e "${BLUE}🧪 Running validation tests...${NC}"
    if ./test_version_bump.sh; then
        echo -e "${GREEN}✓ All tests passed${NC}"
    else
        echo -e "${RED}✗ Tests failed${NC}"
        echo ""
        echo "Rollback completed but tests failed."
        echo "You may want to investigate before pushing."
        echo ""
        read -p "Do you want to continue with push anyway? (yes/no): " push_confirm
        if [ "$push_confirm" != "yes" ]; then
            echo "Push cancelled. Changes are committed locally."
            echo "To undo: git reset --hard HEAD~1"
            exit 1
        fi
    fi
else
    echo -e "${YELLOW}⚠️  Test script not found, skipping validation${NC}"
fi

# Push changes
echo ""
echo -e "${BLUE}🚀 Pushing changes to remote...${NC}"

if [ "$FORCE" = false ]; then
    read -p "Push to origin/main? (yes/no): " push_confirm
    if [ "$push_confirm" != "yes" ]; then
        echo -e "${BLUE}Push cancelled. Changes are committed locally.${NC}"
        echo "To push later: git push origin main"
        exit 0
    fi
fi

git push origin main
echo -e "${GREEN}✓ Changes pushed successfully${NC}"

# Summary
echo ""
echo -e "${GREEN}=============================="
echo "✅ Rollback Complete!"
echo "==============================${NC}"
echo ""
echo "Summary:"
echo "  • Rolled back from: $CURRENT_VERSION"
echo "  • Restored version: $NEW_VERSION"
echo "  • Backup branch: $BACKUP_BRANCH"
echo "  • Commit: $(git rev-parse --short HEAD)"
echo ""
echo "Next steps:"
echo "  1. Verify deployment: https://proto-sdk.github.io/proto-api-docs/"
echo "  2. Update CHANGELOG.md with rollback entry"
echo "  3. Notify team in Slack (#proto-api-alerts)"
echo "  4. Document incident if necessary"
echo ""
echo "To verify live version:"
echo "  curl -s https://proto-sdk.github.io/proto-api-docs/spec.json | jq -r '.info.version'"
echo ""
echo -e "${BLUE}📊 Monitoring GitHub Pages deployment...${NC}"
echo "Visit: https://github.com/proto-sdk/proto-api-docs/actions"
echo ""

# Cleanup
rm -f /tmp/prev_spec.json
