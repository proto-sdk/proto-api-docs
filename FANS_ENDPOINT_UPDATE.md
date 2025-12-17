# Fans Endpoint Update

## Summary
Updated the `/api/v1/hardware` endpoint to include the "Fans" tag, making fan information accessible under the Fans section of the API documentation.

## Changes Made

### 1. Endpoint Update
**Endpoint**: `GET /api/v1/hardware`

**Before**:
- Tags: `["Hardware"]`

**After**:
- Tags: `["Hardware", "Fans"]`

### 2. Why This Change?
The `/api/v1/hardware` endpoint returns comprehensive hardware information including:
- Hashboards information
- PSUs information  
- **Fans information** (`fans-info` array)
- Control board information

By adding the "Fans" tag, this endpoint now appears in both:
- Hardware section (for complete hardware overview)
- Fans section (for users specifically looking for fan information)

### 3. Schema Structure

The endpoint returns `HardwareInfo` which includes:

```json
{
  "hardware-info": {
    "hashboards-info": [...],
    "psus-info": [...],
    "fans-info": [
      {
        "id": 0,
        "name": "CPU Cooler",
        "min_rpm": 1000,
        "max_rpm": 1000
      }
    ],
    "cb-info": {...}
  }
}
```

### 4. FanInfo Schema

Each fan object in the `fans-info` array contains:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier starting from 0 |
| `name` | string | Name of the cooling device |
| `min_rpm` | integer | Minimum RPM of the cooling device |
| `max_rpm` | integer | Maximum RPM of the cooling device |

## Impact

### User Experience
✅ Users can now find fan information in two places:
1. Under "Hardware" for complete hardware overview
2. Under "Fans" for focused fan information

### API Functionality
✅ No breaking changes - endpoint behavior unchanged
✅ No schema changes - existing structure maintained
✅ Backward compatible - existing clients unaffected

### Documentation
✅ Fans section now shows the correct endpoint
✅ Aligns with MDK API documentation structure
✅ Improves discoverability of fan information

## Verification

### Endpoint Check
```bash
curl -X GET "http://{miner_ip}/api/v1/hardware" \
  -H "accept: application/json"
```

### Response Structure
The response includes `fans-info` array with fan details.

## Related Endpoints

### Fan Information
- `GET /api/v1/hardware` - Get all hardware info including fans

### Fan Control
- `GET /api/v1/cooling` - Get cooling status and fan speeds
- `PUT /api/v1/cooling` - Set fan mode and speed

## Files Modified

1. `spec.json` - Added "Fans" tag to `/api/v1/hardware` endpoint
2. `update_fans_endpoint.py` - Update script (for reference)
3. `FANS_ENDPOINT_UPDATE.md` - This documentation

## Backup

- `spec.json.backup.fans-update` - Full backup before changes

## Compatibility

- ✅ OpenAPI 3.0.3 maintained
- ✅ No breaking changes
- ✅ All existing endpoints unchanged
- ✅ All schemas unchanged (except tag addition)
- ✅ UI compatibility maintained

---

**Update Date**: December 17, 2024  
**Update Type**: Documentation Enhancement  
**Breaking Changes**: None
