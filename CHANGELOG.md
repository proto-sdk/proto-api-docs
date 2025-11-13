# Proto API Documentation Changelog

All notable changes to the Proto API documentation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).



## [1.6.2] - 2025-11-13

### Fixed
- **Tags Cleanup**: Removed unused 'Fans' tag from API specification
  - 'Fans' tag had no associated endpoints (0 endpoints)
  - Fan functionality is available through `/api/v1/cooling` endpoint (tagged as 'Cooling')
  - Reduced tag count from 19 to 18 active tags
  - Improves API documentation accuracy and cleanliness
  - All existing endpoints and functionality remain unchanged

### Technical Notes
- No breaking changes to API functionality
- Swagger UI now displays only tags with active endpoints
- Validated: spec.json is valid OpenAPI 3.0.3
- Backup created: spec.json.backup.20251113_094915

## [1.6.1] - 2025-11-04

### Changed
- **Tags Structure**: Updated API specification with comprehensive 19-tag organization system
  - Added detailed descriptions for all endpoint groups
  - Improved API documentation organization and navigation
  - Enhanced Swagger UI tag grouping for better user experience
- **Hardware Endpoint**: Updated `/api/v1/hardware` GET endpoint with multi-tag support
  - Now tagged with: Hardware, PSUs, Hashboards
  - Improves discoverability across related hardware component categories
  - Maintains backward compatibility with existing functionality

### Technical Notes
- No breaking changes to API functionality
- All endpoints, schemas, and responses remain unchanged
- Update improves documentation clarity and navigation only
- Backup created: spec.json.backup.20251104_074912

## [1.6.0] - 2025-10-30

### Added
- **Proto API Assistant**: Interactive chatbot widget for instant API documentation queries
  - Search endpoints by keyword, tag, or path
  - View full operation details with examples
  - Explore schema definitions
  - Generate cURL commands with authentication headers
  - Client-side only, no backend required
  - Mobile-responsive with orange accent theme
- Expanded API spec under Tags and below with updated endpoints and schemas (Pools, Authentication, System, Mining, Hashboards, Hashrate, Temperature, Power, Efficiency, Cooling, Network, Errors, System Tag, Telemetry, Time Series, Hardware, PSUs, Fans)
- Pools: Added hashrate field to Pool schema with HashrateWindow items (duration_minutes, hashrate_ths)
- Pools: Protocol enum labels changed to "Stratum V1" and "Stratum V2" (spaced) for display consistency
- Telemetry: Added support for psu level via level=psu and clarified level semantics (miner, hashboard, asic implicitly includes hashboard, psu)
- Time Series: Added PSU level configuration and response shape

### Changed
- Bumped API version to 1.6.0 in spec.json and UI header
- Normalized temperature unit to "°C" in MetricUnit enum for consistency
- Updated contact email from mining.support@block.xyz to mining@block.xyz


### Technical Notes
- This change only affects the mock server URL version number
- API specification version remains at 1.5.0
- All endpoints, schemas, and functionality remain unchanged
- Change improves compatibility with SwaggerHub's auto-mocking service

## [1.5.0] - 2024-10-10

### Added
- Complete API specification with 43 endpoints across 19 endpoint groups
- Comprehensive schema definitions (95+ schemas)
- System Tag endpoints for device tagging and identification
- Telemetry endpoints for metrics collection
- Time Series data endpoints for historical data access
- Block logo favicon for brand identity
- Dark theme UI with orange accent colors
- Mobile-responsive design improvements
- Try It Out functionality for all endpoints
- Bearer token authentication support

### Changed
- Updated from "Mining Development Kit API" to "Proto API" branding
- Migrated from OpenAPI 3.1.1 to 3.0.3 for better Swagger UI compatibility
- Upgraded Swagger UI from v4.5.0 to v5.10.5
- Improved virtual server path configuration
- Enhanced dark theme styling for better readability
- Optimized schema rendering without white border lines

### Endpoint Groups
Complete endpoint coverage including:
- **Authentication** - API key and token management
- **Cooling** - Fan and cooling system control
- **Efficiency** - Performance metrics and optimization
- **Errors** - Error reporting and diagnostics
- **Fans** - Individual fan control and monitoring
- **Hardware** - Hardware information and status
- **Hashboards** - Hashboard management and monitoring
- **Hashrate** - Mining performance metrics
- **Mining** - Mining operations control
- **Network** - Network configuration and status
- **PSUs** - Power supply unit monitoring (including temperature data)
- **Pools** - Mining pool configuration
- **Power** - Power consumption and management
- **System** - System-level operations
- **System Information** - Device information and status
- **System Tag** - Device identification and tagging
- **Telemetry** - Metrics and data collection
- **Temperature** - Temperature monitoring across all components
- **Time Series** - Historical data access and analysis

### Technical Details
- **OpenAPI Version**: 3.0.3
- **Swagger UI Version**: 5.10.5
- **API Version**: 1.5.0
- **Deployment**: GitHub Pages
- **URL**: https://proto-sdk.github.io/proto-api-docs/

### Security
- Bearer token authentication
- Secure HTTPS deployment
- API key management endpoints

### Fixed
- Schema rendering issues with white border lines
- Mobile viewport responsiveness
- Swagger UI compatibility issues with OpenAPI 3.1.1
- Model expansion depth for better schema visibility

### Infrastructure
- GitHub Pages deployment with custom domain support
- Automated CI/CD pipeline ready
- Version control with comprehensive backup strategy

---

## Version History Notes

This changelog begins with version 1.5.0 as the baseline. This version represents a major milestone in the Proto API documentation, providing comprehensive coverage of all mining device control and monitoring capabilities.

For technical support or questions about the API, please contact: mining@block.xyz
