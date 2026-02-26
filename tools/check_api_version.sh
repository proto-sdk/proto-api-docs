#!/bin/bash
# Script to manually check for new API versions
# Usage: ./check_api_version.sh [github_token]

set -e

echo "🔍 Proto API Version Checker"
echo "============================="

# Get current version from spec.json
CURRENT_VERSION=$(jq -r '.info.version' ../spec.json)
echo "📊 Current version in spec.json: $CURRENT_VERSION"

# Check if GitHub token was provided
if [ -z "$1" ]; then
  echo "⚠️  No GitHub token provided. Using environment variable GITHUB_TOKEN if available."
  GITHUB_TOKEN="${GITHUB_TOKEN}"
else
  GITHUB_TOKEN="$1"
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "❌ Error: GitHub token required to access private repository"
  echo "Usage: ./check_api_version.sh [github_token]"
  echo "Or set GITHUB_TOKEN environment variable"
  exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "📁 Using temporary directory: $TEMP_DIR"

# Fetch the latest API spec from miner-firmware
echo "📥 Fetching latest API spec from miner-firmware..."
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  https://raw.githubusercontent.com/btc-mining/miner-firmware/main/crates/miner-api-server/docs/MDK-API.json \
  -o "$TEMP_DIR/upstream-spec.json"

# Check if the curl command was successful
if [ $? -ne 0 ] || [ ! -s "$TEMP_DIR/upstream-spec.json" ]; then
  echo "❌ Failed to fetch API spec. Check your GitHub token and network connection."
  exit 1
fi

# Validate it's valid JSON
if ! jq empty "$TEMP_DIR/upstream-spec.json" 2>/dev/null; then
  echo "❌ Invalid JSON from upstream"
  exit 1
fi

# Extract upstream version
UPSTREAM_VERSION=$(jq -r '.info.version' "$TEMP_DIR/upstream-spec.json")
echo "📊 Upstream version: $UPSTREAM_VERSION"

# Compare versions
if [ "$UPSTREAM_VERSION" != "$CURRENT_VERSION" ]; then
  echo "✅ Version changed: $CURRENT_VERSION → $UPSTREAM_VERSION"
  
  # Additional checks to debug the GitHub Actions workflow
  echo ""
  echo "🔍 Debugging information:"
  echo "-------------------------"
  
  # Check if the version field exists and is properly formatted
  echo "Version field in upstream spec: $(jq '.info.version | type' "$TEMP_DIR/upstream-spec.json")"
  
  # Check for any whitespace or special characters in the version string
  echo "Upstream version (with visible whitespace): '${UPSTREAM_VERSION}'"
  echo "Current version (with visible whitespace): '${CURRENT_VERSION}'"
  
  # Check the exact byte representation of both versions
  echo "Upstream version (hex): $(echo -n "$UPSTREAM_VERSION" | xxd -p)"
  echo "Current version (hex): $(echo -n "$CURRENT_VERSION" | xxd -p)"
  
  # Check if there are any hidden characters or encoding issues
  echo "Upstream version length: ${#UPSTREAM_VERSION}"
  echo "Current version length: ${#CURRENT_VERSION}"
else
  echo "ℹ️  No version change detected. Documentation is up to date."
fi

# Clean up
echo ""
echo "🧹 Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "✅ Version check complete"
