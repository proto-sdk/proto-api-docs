# Proto API v1.7.2 Release Announcement

**Release Date**: December 17, 2024  
**Status**: ✅ Live in Production  
**Type**: Documentation Enhancement  

---

## 📋 What Changed

### 1. Enhanced Tag Descriptions
Updated all 19 API endpoint tag descriptions for improved clarity and consistency.

### 2. Fans Endpoint Correction
Added "Fans" tag to `GET /api/v1/hardware` to align with MDK API structure.

---

## 🎯 Key Points

### ✅ No Action Required
- **Zero breaking changes** - fully backward compatible
- **Documentation only** - no API behavior changes
- **No code updates needed** - existing integrations work unchanged
- **No testing required** - API responses unchanged

### ✅ Improvements
- **Better documentation clarity** - clearer endpoint descriptions
- **Improved discoverability** - fans info properly categorized
- **MDK API alignment** - consistent documentation structure

---

## 📊 Technical Details

| Aspect | Details |
|--------|---------|
| **Version** | 1.7.2 |
| **OpenAPI** | 3.0.3 (maintained) |
| **Breaking Changes** | None |
| **Backward Compatibility** | 100% |
| **Deployment** | GitHub Pages (automatic) |
| **Downtime** | Zero |

---

## 🔗 Resources

- **API Docs**: https://proto-sdk.github.io/proto-api-docs/
- **Fans Section**: https://proto-sdk.github.io/proto-api-docs/#/Fans
- **Repository**: https://github.com/proto-sdk/proto-api-docs
- **Support**: mining.support@block.xyz

---

## 📝 Fans Endpoint Details

**Endpoint**: `GET /api/v1/hardware`  
**Returns**: Complete hardware info including `fans-info` array

**FanInfo Structure**:
```json
{
  "id": 0,
  "name": "Fan 1",
  "min_rpm": 1000,
  "max_rpm": 5000
}
```

---

## ✨ Summary

This is a **passive documentation improvement** that:
- Enhances developer experience with clearer descriptions
- Aligns our docs with MDK API structure
- Requires **no action** from API consumers or development teams

Questions? Contact mining.support@block.xyz

---

**Version**: 1.7.2 | **Status**: ✅ Production | **Updated**: Dec 17, 2024
