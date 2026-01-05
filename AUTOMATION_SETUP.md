# Proto API Automation Setup Guide

This document explains how to complete the setup for automated Proto API monitoring and documentation updates.

## Overview

The automation system will:
1. ✅ Monitor the miner-firmware repository daily for API version changes
2. ✅ Send Slack notifications when new versions are detected
3. ✅ Automatically update the proto-api-docs site with new API specs
4. ✅ Update the CHANGELOG.md file
5. ✅ Post updates to #proto-documentation Slack channel

## Setup Steps

### 1. Add GitHub Secrets

You need to add two Slack webhook URLs as GitHub secrets:

#### Go to Repository Settings:
1. Navigate to: https://github.com/proto-sdk/proto-api-docs/settings/secrets/actions
2. Click "New repository secret"

#### Add Secret #1: SLACK_WEBHOOK_URL
- **Name:** `SLACK_WEBHOOK_URL`
- **Value:** Your Proto API Monitor webhook URL (the one you tested with curl)
- **Purpose:** Sends initial notification when version change is detected (to your channel)

#### Add Secret #2: SLACK_WEBHOOK_DOCS_CHANNEL
- **Name:** `SLACK_WEBHOOK_DOCS_CHANNEL`
- **Value:** You need to create a webhook for #proto-documentation channel
- **Purpose:** Sends completion notification to the team channel

**To create the #proto-documentation webhook:**
1. Go to: https://api.slack.com/apps
2. Select your Proto API Monitor app (or the app you're using)
3. Click "Incoming Webhooks"
4. Click "Add New Webhook to Workspace"
5. Select `#proto-documentation` channel
6. Copy the webhook URL
7. Add it as the `SLACK_WEBHOOK_DOCS_CHANNEL` secret

### 2. Workflow Schedule

The workflow runs:
- **Automatically:** Every day at 9:00 AM UTC (1:00 AM PST / 4:00 AM EST)
- **Manually:** You can trigger it anytime from the Actions tab

### 3. Test the Workflow

After adding the secrets, test the workflow:

1. Go to: https://github.com/proto-sdk/proto-api-docs/actions
2. Click on "Monitor and Update Proto API"
3. Click "Run workflow" dropdown
4. Click "Run workflow" button
5. Watch it run in real-time

## What Happens When a Version Changes

### Step 1: Detection (Daily Check)
```
🔍 Checking miner-firmware repo...
📊 Current version: 1.7.2
📊 Upstream version: 1.8.0
✅ Version changed detected!
```

### Step 2: Slack Notification (Your Channel)
You'll receive a Slack message:
```
🔔 New Proto API Version Detected!

Current Version: 1.7.2
New Version: 1.8.0

🤖 Starting automatic documentation update...
```

### Step 3: Automatic Updates
The bot will:
- ✅ Download the new API spec from miner-firmware
- ✅ Update spec.json (keeping "Proto Mining API" title)
- ✅ Create a backup of the old spec
- ✅ Update CHANGELOG.md with version info
- ✅ Commit and push changes
- ✅ Wait for GitHub Pages to deploy

### Step 4: Completion Notification (#proto-documentation)
Team receives a message:
```
✅ Proto Mining API Documentation Updated!

Version: 1.7.2 → 1.8.0
Status: ✅ Live

The Proto Mining API documentation has been automatically updated...

[View API Docs] [View Changelog] [View Commit]
```

## Monitoring Source

The automation monitors:
- **Repository:** https://github.com/btc-mining/miner-firmware
- **File:** `crates/miner-api-server/docs/MDK-API.json`
- **Checks:** Line 13 for version number in the `info.version` field

## Manual Trigger

You can manually trigger the workflow anytime:

```bash
# Using GitHub CLI (if installed)
gh workflow run monitor-and-update-api.yml

# Or via the GitHub web interface:
# 1. Go to Actions tab
# 2. Select "Monitor and Update Proto API"
# 3. Click "Run workflow"
```

## Files Modified by Automation

When a version change is detected:
- ✅ `spec.json` - Updated with new API specification
- ✅ `CHANGELOG.md` - New entry added at the top
- ✅ `spec.json.backup.YYYYMMDD_HHMMSS` - Backup of previous version

## Troubleshooting

### Workflow doesn't run
- Check that GitHub Actions are enabled for the repo
- Verify the secrets are added correctly
- Check the Actions tab for error messages

### No Slack notifications
- Verify webhook URLs are correct in GitHub secrets
- Test webhooks manually with curl
- Check webhook hasn't been revoked in Slack

### Documentation doesn't update
- Check GitHub Pages is enabled
- Verify the workflow completed successfully
- GitHub Pages can take 1-2 minutes to deploy

## Security Notes

- ✅ Webhook URLs are stored as GitHub secrets (encrypted)
- ✅ Only authorized GitHub Actions can access them
- ✅ Commits are signed by "Proto API Bot"
- ✅ All changes are tracked in git history

## Questions?

Contact: mining@block.xyz or @hmoses in Slack
