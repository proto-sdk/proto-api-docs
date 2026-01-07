# Proto API Version Rollback Guide
## Emergency Rollback Procedures for Version 1.7.3

**Last Updated:** 2026-01-07  
**Current Version:** 1.7.3  
**Previous Version:** 1.7.2  
**Rollback Complexity:** 🟢 LOW (No breaking changes)

---

## Quick Rollback (Emergency)

If you need to rollback immediately:

```bash
# 1. Navigate to repo
cd proto-api-docs

# 2. Revert to previous commit
git revert HEAD --no-edit

# 3. Push the revert
git push origin main

# 4. Verify rollback
curl -s https://proto-sdk.github.io/proto-api-docs/spec.json | jq -r '.info.version'
# Should show: 1.7.2
```

**Time to Complete:** ~2 minutes  
**Downtime Required:** None  
**Client Impact:** None (backward compatible)

---

## Detailed Rollback Procedures

### Method 1: Git Revert (Recommended)

**Use When:** You want to preserve history and create a new commit that undoes changes.

```bash
# Step 1: Check current status
git log --oneline -5
# Note the commit hash for version 1.7.3

# Step 2: Revert the version bump commit
git revert <commit-hash> --no-edit

# Step 3: Verify changes locally
git diff HEAD~1 HEAD

# Step 4: Test locally
python3 -m http.server 8888 &
curl http://localhost:8888/spec.json | jq -r '.info.version'
# Should show: 1.7.2

# Step 5: Push to production
git push origin main

# Step 6: Verify deployment
sleep 30  # Wait for GitHub Pages to update
curl -s https://proto-sdk.github.io/proto-api-docs/spec.json | jq -r '.info.version'
```

**Advantages:**
- ✅ Preserves full history
- ✅ Creates audit trail
- ✅ Can be reverted again if needed
- ✅ No force push required

**Disadvantages:**
- ⚠️ Creates additional commit

---

### Method 2: Git Reset (Clean History)

**Use When:** You want to completely remove the version bump from history.

⚠️ **WARNING:** This requires force push and should only be used if no one else has pulled the changes.

```bash
# Step 1: Backup current state
git branch backup-v1.7.3

# Step 2: Reset to previous commit
git reset --hard HEAD~1

# Step 3: Verify you're on 1.7.2
git log --oneline -3
cat spec.json | grep '"version"'

# Step 4: Force push (⚠️ DANGEROUS)
git push origin main --force

# Step 5: Notify team
# Send message: "Rolled back to v1.7.2 via force push"
```

**Advantages:**
- ✅ Clean history
- ✅ Removes version bump entirely

**Disadvantages:**
- ❌ Requires force push
- ❌ Can cause issues for other developers
- ❌ Loses commit history
- ❌ Not recommended for production

---

### Method 3: Manual File Restore

**Use When:** You only want to rollback specific files without changing git history.

```bash
# Step 1: Restore files from previous commit
git checkout HEAD~1 -- spec.json
git checkout HEAD~1 -- README.md
git checkout HEAD~1 -- index.html

# Step 2: Verify changes
git diff --staged

# Step 3: Commit the rollback
git commit -m "rollback: revert API version to 1.7.2

Reason: [Specify reason here]
Previous version: 1.7.3
Restored version: 1.7.2
Rollback date: $(date)"

# Step 4: Push changes
git push origin main
```

**Advantages:**
- ✅ Selective file rollback
- ✅ Preserves other changes
- ✅ No force push needed

**Disadvantages:**
- ⚠️ Manual process
- ⚠️ Must specify all files

---

### Method 4: Using Backup Files

**Use When:** Git history is corrupted or you need immediate file-level restore.

```bash
# Step 1: List available backups
ls -la spec.json.backup*

# Step 2: Identify the correct backup
# For version 1.7.2, use the most recent backup before today
BACKUP_FILE="spec.json.backup.20260107_141132"

# Step 3: Restore from backup
cp "$BACKUP_FILE" spec.json

# Step 4: Update documentation
sed -i '' 's/1.7.3/1.7.2/g' README.md
sed -i '' 's/v1.7.3/v1.7.2/g' index.html

# Step 5: Verify changes
grep '"version"' spec.json
grep 'version-' README.md
grep 'v1.7' index.html

# Step 6: Commit and push
git add spec.json README.md index.html
git commit -m "rollback: restore API version 1.7.2 from backup"
git push origin main
```

**Advantages:**
- ✅ Works even if git history is problematic
- ✅ Fast recovery
- ✅ File-level control

**Disadvantages:**
- ⚠️ Requires backup files to exist
- ⚠️ Manual documentation updates needed

---

## Rollback Verification Checklist

After performing any rollback, verify the following:

### 1. Version Numbers
```bash
# Check spec.json
jq -r '.info.version' spec.json
# Expected: 1.7.2

# Check README.md
grep -o 'version-[0-9.]*' README.md
# Expected: version-1.7.2

# Check index.html
grep -o 'v1\.[0-9.]*' index.html
# Expected: v1.7.2
```

### 2. API Endpoints
```bash
# Count endpoints
jq '.paths | length' spec.json
# Expected: 43 (not 45)

# Verify removed endpoints are gone
jq '.paths | keys[]' spec.json | grep -c "power-supplies"
# Expected: 0
```

### 3. Documentation
- [ ] README.md shows version 1.7.2
- [ ] index.html shows v1.7.2
- [ ] CHANGELOG.md updated with rollback entry
- [ ] GitHub Pages deployed successfully

### 4. Automated Tests
```bash
# Run test suite
./test_version_bump.sh

# Should show version 1.7.2 in all tests
```

### 5. Live Deployment
```bash
# Check live site
curl -s https://proto-sdk.github.io/proto-api-docs/spec.json | jq -r '.info.version'
# Expected: 1.7.2

# Check GitHub Pages status
gh api repos/proto-sdk/proto-api-docs/pages
```

---

## Post-Rollback Actions

### 1. Update CHANGELOG.md

Add rollback entry:

```markdown
## [1.7.2] - 2026-01-07 (Rolled Back)

### Rollback
- Reverted version 1.7.3 due to [reason]
- Removed power supply endpoints
- Restored to stable version 1.7.2

### Reason for Rollback
[Detailed explanation of why rollback was necessary]
```

### 2. Notify Stakeholders

Send notification via Slack:

```bash
# Manual Slack notification (if webhook available)
curl -X POST "$SLACK_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "🔄 Proto API Rolled Back",
    "blocks": [
      {
        "type": "header",
        "text": {
          "type": "plain_text",
          "text": "⚠️ API Version Rollback Completed"
        }
      },
      {
        "type": "section",
        "fields": [
          {
            "type": "mrkdwn",
            "text": "*From Version:*\n1.7.3"
          },
          {
            "type": "mrkdwn",
            "text": "*To Version:*\n1.7.2"
          },
          {
            "type": "mrkdwn",
            "text": "*Rollback Time:*\n'"$(date)"'"
          },
          {
            "type": "mrkdwn",
            "text": "*Impact:*\nNone - backward compatible"
          }
        ]
      }
    ]
  }'
```

### 3. Document Incident

Create incident report:

```markdown
# Incident Report: API Version Rollback

**Date:** 2026-01-07
**Version Rolled Back:** 1.7.3
**Restored Version:** 1.7.2
**Duration:** [X minutes]
**Impact:** None (backward compatible)

## Root Cause
[Describe why rollback was needed]

## Timeline
- [Time]: Version 1.7.3 deployed
- [Time]: Issue discovered
- [Time]: Rollback initiated
- [Time]: Rollback completed
- [Time]: Verification completed

## Lessons Learned
[What we learned from this incident]

## Action Items
- [ ] [Preventive measures]
- [ ] [Process improvements]
```

---

## Rollback Testing

Before performing a rollback in production, test in staging:

```bash
# 1. Create test branch
git checkout -b test-rollback-v1.7.2

# 2. Perform rollback
git revert HEAD --no-edit

# 3. Test locally
python3 -m http.server 9000 &
curl http://localhost:9000/spec.json | jq -r '.info.version'

# 4. Run test suite
./test_version_bump.sh

# 5. If successful, apply to main
git checkout main
git merge test-rollback-v1.7.2
git push origin main
```

---

## Emergency Contacts

If rollback fails or you need assistance:

- **Primary:** API Team Lead
- **Secondary:** DevOps Team
- **Emergency:** On-call Engineer
- **Slack Channel:** #proto-api-alerts
- **Email:** mining-api-team@block.xyz

---

## Rollback Decision Matrix

| Scenario | Recommended Method | Urgency | Risk |
|----------|-------------------|---------|------|
| Critical bug in production | Method 1 (Git Revert) | HIGH | LOW |
| Performance degradation | Method 1 (Git Revert) | HIGH | LOW |
| Client compatibility issue | Method 1 (Git Revert) | MEDIUM | LOW |
| Documentation error only | Method 3 (Manual) | LOW | LOW |
| Testing/validation failure | Method 1 (Git Revert) | MEDIUM | LOW |
| Accidental deployment | Method 2 (Git Reset) | HIGH | MEDIUM |

---

## Automated Rollback Script

Save this as `rollback.sh` for quick rollbacks:

```bash
#!/bin/bash
# Quick rollback script for Proto API

set -e

echo "🔄 Proto API Rollback Script"
echo "=============================="
echo ""

# Confirm rollback
read -p "Are you sure you want to rollback to v1.7.2? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Rollback cancelled."
    exit 0
fi

echo "📝 Creating backup branch..."
git branch backup-before-rollback-$(date +%Y%m%d_%H%M%S)

echo "⏪ Reverting to previous version..."
git revert HEAD --no-edit

echo "🧪 Running tests..."
./test_version_bump.sh

echo "🚀 Pushing changes..."
git push origin main

echo ""
echo "✅ Rollback complete!"
echo "📊 Verify at: https://proto-sdk.github.io/proto-api-docs/"
echo ""
echo "Next steps:"
echo "1. Update CHANGELOG.md"
echo "2. Notify team in Slack"
echo "3. Document incident"
```

Make it executable:
```bash
chmod +x rollback.sh
```

---

## Prevention Strategies

To avoid needing rollbacks in the future:

1. **Enhanced Testing**
   - Add integration tests
   - Implement contract testing
   - Use API compatibility validators

2. **Staging Environment**
   - Deploy to staging first
   - Run full test suite
   - Get approval before production

3. **Gradual Rollout**
   - Use feature flags
   - Implement canary deployments
   - Monitor metrics closely

4. **Automated Validation**
   - Pre-commit hooks
   - CI/CD pipeline checks
   - Automated breaking change detection

---

**Document Version:** 1.0  
**Last Reviewed:** 2026-01-07  
**Next Review:** 2026-02-07  
**Owner:** Proto API Team
