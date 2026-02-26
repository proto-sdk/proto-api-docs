#!/bin/bash
# Script to test the fix for the Proto API Monitor
# Usage: ./test_fix.sh [github_token]

set -e

echo "🔧 Proto API Monitor Fix Tester"
echo "=============================="

# Check if GitHub token was provided
if [ -z "$1" ]; then
  echo "⚠️  No GitHub token provided. Using environment variable GITHUB_TOKEN if available."
  GITHUB_TOKEN="${GITHUB_TOKEN}"
else
  GITHUB_TOKEN="$1"
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "❌ Error: GitHub token required to access private repository"
  echo "Usage: ./test_fix.sh [github_token]"
  echo "Or set GITHUB_TOKEN environment variable"
  exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "📁 Using temporary directory: $TEMP_DIR"

# Define potential locations to check
LOCATIONS=(
  "main/crates/miner-api-server/docs/MDK-API.json"
  "master/crates/miner-api-server/docs/MDK-API.json"
  "develop/crates/miner-api-server/docs/MDK-API.json"
  "main/crates/miner-api-server/docs/MDK-API.json.v1.7.7"
  "main/crates/miner-api-server/MDK-API.json"
  "main/docs/MDK-API.json"
)

FOUND=false
FOUND_LOCATION=""
FOUND_VERSION=""

for LOCATION in "${LOCATIONS[@]}"; do
  echo "🔍 Trying: https://raw.githubusercontent.com/btc-mining/miner-firmware/${LOCATION}"
  
  # Download from the current location
  curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://raw.githubusercontent.com/btc-mining/miner-firmware/${LOCATION}" \
    -o "$TEMP_DIR/test-spec.json"
  
  # Check if we got a valid JSON file with a version field
  if jq -e '.info.version' "$TEMP_DIR/test-spec.json" > /dev/null 2>&1; then
    VERSION=$(jq -r '.info.version' "$TEMP_DIR/test-spec.json")
    FOUND=true
    FOUND_LOCATION="${LOCATION}"
    FOUND_VERSION="${VERSION}"
    echo "✅ Found valid API spec at: ${LOCATION}"
    echo "📊 Version: ${VERSION}"
    break
  else
    echo "❌ No valid API spec at: ${LOCATION}"
  fi
done

if [ "$FOUND" = false ]; then
  echo "❌ Could not find valid API spec in any of the checked locations"
  exit 1
fi

# Compare with current version
CURRENT_VERSION=$(jq -r '.info.version' ../spec.json)
echo ""
echo "📊 Current version in spec.json: $CURRENT_VERSION"
echo "📊 Found version in $FOUND_LOCATION: $FOUND_VERSION"

if [ "$FOUND_VERSION" != "$CURRENT_VERSION" ]; then
  echo "✅ Version change detected: $CURRENT_VERSION → $FOUND_VERSION"
  echo "🔧 The fix should work correctly!"
else
  echo "ℹ️  No version change detected. Both versions are $CURRENT_VERSION."
  echo "⚠️  Either the fix isn't needed or we haven't found the correct location."
fi

# Clean up
echo ""
echo "🧹 Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "✅ Test complete"
