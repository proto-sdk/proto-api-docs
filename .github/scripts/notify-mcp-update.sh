#!/bin/bash
# Script to notify MCP servers about API updates

set -e

API_VERSION="$1"
CHANGELOG_ENTRY="$2"

if [ -z "$API_VERSION" ]; then
  echo "❌ Error: API_VERSION required"
  exit 1
fi

echo "📡 Notifying MCP servers of Proto API v${API_VERSION} update..."

# Create MCP notification payload
cat > /tmp/mcp_notification.json << JSONEOF
{
  "event": "api_updated",
  "api_version": "${API_VERSION}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "spec_url": "https://proto-sdk.github.io/proto-api-docs/spec.json",
  "changelog_url": "https://proto-sdk.github.io/proto-api-docs/CHANGELOG.md",
  "docs_url": "https://proto-sdk.github.io/proto-api-docs/",
  "changes_summary": $(echo "$CHANGELOG_ENTRY" | head -20 | jq -Rs .)
}
JSONEOF

echo "✅ MCP notification payload created:"
cat /tmp/mcp_notification.json | jq .

# In the future, this could POST to MCP webhook endpoints
# For now, MCP servers will auto-refresh via their cache TTL

echo ""
echo "📋 MCP Update Instructions:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MCP servers configured with:"
echo "  SPEC_URL=https://proto-sdk.github.io/proto-api-docs/spec.json"
echo ""
echo "Will automatically refresh within their cache TTL (default: 5 minutes)"
echo ""
echo "To force immediate refresh, MCP clients can call the 'refresh' tool"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ MCP notification complete"
