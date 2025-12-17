# Proto API v1.7.2 - Technical Overview

## Executive Summary

**Version**: 1.7.2  
**Release Date**: December 17, 2024  
**Type**: Documentation Enhancement  
**Breaking Changes**: None  
**Deployment Status**: ✅ Live

---

## What's New in v1.7.2

### 1. Enhanced Tag Descriptions (All 19 Tags)
Updated all API endpoint tag descriptions for improved clarity and consistency across the documentation.

**Impact**: Better developer experience, clearer API organization, improved documentation quality

### 2. Fans Endpoint Correction
Added "Fans" tag to `GET /api/v1/hardware` endpoint to align with MDK API structure.

**Impact**: Fans section now correctly shows hardware endpoint, improved API discoverability

---

## Detailed Changes

### Tag Descriptions Updated

All 19 endpoint group tags received enhanced descriptions:

| Tag | Updated Description |
|-----|-------------------|
| **Mining** | Control and configuration of mining functionality |
| **System** | Information and actions related to the overall miner system |
| **Network** | Network configuration of the miner |
| **Errors** | Active system errors (severity level errors or warnings) |
| **Pools** | Configure the list of pools the miner connects to |
| **Cooling** | Information and control over the cooling system |
| **Authentication** | Password management and authentication-related actions |
| **Hashboards** | Information about hashboards and ASICs |
| **Hashrate** | Historical hashrate information (miner/hashboard/ASIC level) |
| **Temperature** | Historical temperature information (miner/hashboard/ASIC level) |
| **Power** | Historical power information (miner/hashboard level) |
| **Efficiency** | Historical efficiency information (miner/hashboard level) |
| **System Information** | Status and configuration details about the mining device |
| **Hardware** | Physical hardware components of the mining device |
| **PSUs** | Power supply units information |
| **Fans** | Cooling fans information |
| **Time Series** | Unified access to historical data for multiple metrics |
| **Telemetry** | Current (real-time) values for all metrics |
| **System Tag** | Set and retrieve custom tags for the mining device |

### Fans Endpoint Structure

**Endpoint**: `GET /api/v1/hardware`  
**Tags**: `["Hardware", "Fans"]` (Fans tag added)

**Response Structure**:
```json
{
  "hardware-info": {
    "hashboards-info": [...],
    "psus-info": [...],
    "fans-info": [
      {
        "id": 0,
        "name": "Fan 1",
        "min_rpm": 1000,
        "max_rpm": 5000
      }
    ],
    "cb-info": {...}
  }
}
```

**FanInfo Schema**:
- `id` (integer): Unique identifier starting from 0
- `name` (string): Name of the cooling device
- `min_rpm` (integer): Minimum RPM
- `max_rpm` (integer): Maximum RPM

---

## Technical Details

### API Specification
- **OpenAPI Version**: 3.0.3 (maintained)
- **API Version**: 1.7.2
- **Spec Location**: https://proto-sdk.github.io/proto-api-docs/spec.json

### Compatibility
- ✅ **Backward Compatible**: 100%
- ✅ **Breaking Changes**: None
- ✅ **Endpoint Behavior**: Unchanged
- ✅ **Response Schemas**: Unchanged (except tag additions)
- ✅ **Client Impact**: Zero - no code changes required

### Deployment
- **Method**: GitHub Pages (automatic)
- **Downtime**: None
- **Rollback Available**: Yes (backups created)

---

## Impact Assessment

### For API Consumers
- ✅ **No action required** - fully backward compatible
- ✅ **Improved documentation** - clearer endpoint descriptions
- ✅ **Better discoverability** - fans info now properly categorized
- ✅ **No breaking changes** - existing integrations work unchanged

### For Documentation Users
- ✅ **Clearer navigation** - improved tag descriptions
- ✅ **Consistent structure** - aligned with MDK API
- ✅ **Better UX** - fans endpoint now in correct section

### For Development Teams
- ✅ **No code changes needed** - documentation only
- ✅ **No testing required** - API behavior unchanged
- ✅ **No deployment coordination** - clients unaffected

---

## Alignment with MDK API

This release aligns the Proto API documentation structure with the MDK API reference:

**MDK API**: https://supreme-doodle-yw575ew.pages.github.io/mdk/#tag/Fans

**Alignment Points**:
- ✅ Fans tag points to `GET /api/v1/hardware`
- ✅ Hardware response includes `fans-info` array
- ✅ FanInfo schema matches expected structure
- ✅ Consistent documentation organization

---

## Related Endpoints

### Fan Information & Control

| Endpoint | Method | Purpose | Tags |
|----------|--------|---------|------|
| `/api/v1/hardware` | GET | Get all hardware info including fans | Hardware, Fans |
| `/api/v1/cooling` | GET | Get current cooling status and fan speeds | Cooling |
| `/api/v1/cooling` | PUT | Control fan mode and speed | Cooling |

---

## Migration Guide

### For API Consumers
**No migration needed** - this is a documentation-only update.

### For Documentation Maintainers
- ✅ Fans section now shows `GET /api/v1/hardware`
- ✅ Tag descriptions updated across all sections
- ✅ No schema changes to document

---

## Testing & Verification

### Automated Tests
- ✅ JSON schema validation
- ✅ OpenAPI 3.0.3 compliance
- ✅ Tag reference integrity
- ✅ Schema reference validation

### Manual Verification
- ✅ Live site rendering
- ✅ Endpoint discoverability
- ✅ UI functionality
- ✅ Cross-browser compatibility

### Results
- ✅ All tests passed
- ✅ Zero issues detected
- ✅ Documentation renders correctly
- ✅ No breaking changes confirmed

---

## Resources

### Documentation
- **API Docs**: https://proto-sdk.github.io/proto-api-docs/
- **Fans Section**: https://proto-sdk.github.io/proto-api-docs/#/Fans
- **Spec JSON**: https://proto-sdk.github.io/proto-api-docs/spec.json
- **CHANGELOG**: https://github.com/proto-sdk/proto-api-docs/blob/main/CHANGELOG.md

### Repository
- **GitHub**: https://github.com/proto-sdk/proto-api-docs
- **Branch**: main
- **Commits**: 
  - `0beee53` - Tag descriptions update (v1.7.2)
  - `b5a4070` - Fans endpoint correction

### Reference
- **MDK API**: https://supreme-doodle-yw575ew.pages.github.io/mdk/

---

## Key Metrics

| Metric | Value |
|--------|-------|
| Tags Updated | 19 |
| Endpoints Modified | 1 (`/api/v1/hardware`) |
| Breaking Changes | 0 |
| Deployment Time | ~2 minutes |
| Downtime | 0 minutes |
| Backward Compatibility | 100% |

---

## Support & Questions

### Technical Support
- **Email**: mining.support@block.xyz
- **Issues**: https://github.com/proto-sdk/proto-api-docs/issues

### Documentation Questions
- Review the updated tag descriptions in the live docs
- Check the Fans section for hardware endpoint details
- Refer to CHANGELOG.md for version history

---

## Summary for Technical Teams

**TL;DR**:
- ✅ Documentation-only update - no API changes
- ✅ All 19 tag descriptions improved for clarity
- ✅ Fans endpoint now correctly points to `GET /api/v1/hardware`
- ✅ Zero breaking changes - fully backward compatible
- ✅ No action required from API consumers
- ✅ Aligned with MDK API documentation structure

**Action Items**:
- ❌ **None** - this is a passive documentation improvement
- ℹ️ Optional: Review updated docs for improved clarity
- ℹ️ Optional: Update internal documentation references

---

**Version**: 1.7.2  
**Status**: ✅ Production  
**Last Updated**: December 17, 2024
