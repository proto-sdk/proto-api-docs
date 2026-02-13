# Proto API Documentation Changelog
## [1.7.5] - 2026-02-13

### Changed
- Fixed inconsistent spacing in compound words
- Changed "hash rate" → "hashrate" (3 occurrences in API descriptions)
- Changed "hash board" → "hashboard" (1 occurrence in API descriptions)
- Improved documentation consistency across all endpoints
- Version bump: 1.7.4 → 1.7.5
- Automatically synchronized with btc-mining/miner-firmware


All notable changes to the Proto API documentation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.4] - 2026-02-05

### Added
- **Mining Tuning Endpoint**: New endpoint for hashboard optimization algorithms
  - `PUT /api/v1/mining/tuning`: Configure hashboard-level performance tuning
  - Supports three optimization algorithms:
    - `None`: No optimization (default)
    - `VoltageImbalanceCompensation`: Compensates for voltage imbalances across ASICs
    - `Fuzzing`: Experimental performance testing algorithm
  - Useful for performance optimization and hardware testing
- **New Schemas**:
  - `MiningTuning`: Enum for tuning algorithm selection
  - `MiningTuningConfig`: Configuration object for tuning settings

### Changed
- **API Version**: Bumped to 1.7.4
- Updated API specification from miner-firmware upstream

### Technical Notes
- Maintains OpenAPI 3.0.3 compatibility
- No breaking changes to existing endpoints
- All updates are additive and backward compatible
- Requires Bearer authentication
- Automatically synchronized with btc-mining/miner-firmware

## [1.7.3] - 2026-02-04

### Added
- **ASIC Voltage Monitoring**: New `voltage_mv` field in AsicStats schema
  - Exposes per-ASIC voltage values in millivolts (mV)
  - Available in hashboard endpoints:
    - `GET /api/v1/hashboards/{sn}`: Returns voltage_mv for all ASICs on the hashboard
    - `GET /api/v1/hashboards/{sn}/{asic_index}`: Returns voltage_mv for individual ASIC
  - Useful for debugging voltage-related issues and monitoring ASIC health
  - Field format matches existing hashboard-level voltage_mv format for consistency

### Changed
- **API Version**: Bumped to 1.7.3
- Updated API specification from miner-firmware upstream (PR #3059)

### Technical Notes
- Maintains OpenAPI 3.0.3 compatibility
- No breaking changes to existing endpoints
- All updates are additive and backward compatible
- Voltage values are reported in millivolts for precision
- Automatically synchronized with btc-mining/miner-firmware

## [1.7.2] - 2026-01-30

### Added
- **Pool Name Support**: New `name` field for user-defined pool display names
  - Added `name` field to Pool schema (optional string)
  - Added `name` field to PoolConfig_inner schema
  - Allows users to assign custom display names to mining pools
  - Backward compatible with existing pool configurations
  - Available in pool configuration and status endpoints

### Changed
- **Cooling Mode Enum**: Updated CoolingMode enum values to REST-friendly format
  - Changed from RPC-style naming (COOLING_MODE_*) to REST-friendly values
  - New enum values: "Unknown", "Off", "Auto", "Manual"
  - Added "Unknown" variant to CoolingConfig.mode for better error handling
  - Improves consistency with REST API conventions
  - Fixes frontend type generation issues
- **API Version**: Bumped to 1.7.2
- Updated API specification from miner-firmware upstream (PRs #3002, #3012)

### Technical Notes
- Maintains OpenAPI 3.0.3 compatibility
- No breaking changes to existing endpoints
- All updates are additive and backward compatible
- Pool name field is optional and does not affect existing configurations
- Cooling mode enum changes improve API usability and frontend integration
- Automatically synchronized with btc-mining/miner-firmware

## [1.7.1] - 2024-11-26

### Added
- **PSU Firmware Management**: New endpoints for managing PSU firmware updates
  - `GET /api/v1/power-supplies`: Returns PSU information including firmware update status and available firmware updates
  - `POST /api/v1/power-supplies/update`: Schedules PSU firmware updates to run on next reboot with optional force parameter
- **New Schemas**: 
  - `PowerSuppliesResponse`: Combined PSU info and firmware update status
  - `PsuUpdateStatus`: Firmware update status tracking
  - `PsuUpdateResultStatus`: Enum for update status values (scheduled, success, timeout, failed, unknown)
  - `AvailablePsuFirmware`: Information about available firmware files with SHA-256 verification

### Changed
- **API Version**: Bumped to 1.7.1

### Technical Notes
- Maintains OpenAPI 3.0.3 compatibility
- No breaking changes to existing endpoints
- All updates are additive and backward compatible
- PSU firmware updates run automatically on next reboot for system stability
- Firmware verification via SHA-256 hashing ensures update integrity

### Security
- PSU firmware update endpoint requires Bearer authentication
- Force parameter allows bypassing version checks when needed (authenticated only)




## [1.7.0] - 2025-11-20

### Added
- **New Endpoint Groups**: System Tag, Telemetry (real-time metrics)
- **Enhanced Tag Descriptions**: All 18 endpoint groups now have comprehensive descriptions
- **Comprehensive API Documentation**: Updated all tag descriptions for better clarity

### Changed
- **API Version**: Bumped to 1.7.0
- **Tag Organization**: Enhanced descriptions for Mining, System, Network, Errors, Pools, Cooling, Authentication, Hashboards, Hashrate, Temperature, Power, Efficiency, System Information, Hardware, PSUs, Time Series, Telemetry, and System Tag groups

### Technical Notes
- Maintains OpenAPI 3.0.3 compatibility
- No breaking changes to existing endpoints
- All updates are additive and backward compatible



## [1.6.0] - 2025-10-30

### Added
- **Proto API Assistant**: Interactive chatbot widget for instant API documentation queries
  - Search endpoints by keyword, tag, or path
  - View full operation details with examples
  - Explore schema definitions
  - Generate cURL commands with authentication headers
  - Client-side only, no backend required
  - Mobile-responsive with orange accent theme
- **API Specification Enhancements**:
  - Expanded API spec with updated endpoints and schemas
  - Comprehensive 18-tag organization system with detailed descriptions
  - Improved API documentation organization and navigation
  - Enhanced Swagger UI tag grouping for better user experience
- **Pools Enhancements**:
  - Added hashrate field to Pool schema with HashrateWindow items (duration_minutes, hashrate_ths)
  - Protocol enum labels changed to "Stratum V1" and "Stratum V2" (spaced) for display consistency
- **Telemetry Enhancements**:
  - Added support for psu level via level=psu
  - Clarified level semantics (miner, hashboard, asic implicitly includes hashboard, psu)
- **Time Series Enhancements**:
  - Added PSU level configuration and response shape

### Changed
- **API Version**: Bumped to 1.6.0 in spec.json and UI header
- **Hardware Endpoint**: Updated `/api/v1/hardware` GET endpoint with improved tag support
  - Tagged with: Hardware, PSUs, Hashboards
  - Improves discoverability across related hardware component categories
- **Temperature Unit**: Normalized to "°C" in MetricUnit enum for consistency
- **Contact Email**: Updated from mining.support@block.xyz to mining@block.xyz

### Fixed
- **Tags Cleanup**: Removed unused 'Fans' tag from API specification
  - 'Fans' tag had no associated endpoints (0 endpoints)
  - Fan functionality is available through `/api/v1/cooling` endpoint (tagged as 'Cooling')
  - Reduced tag count to 18 active tags for cleaner documentation

### Technical Notes
- No breaking changes to API functionality
- All endpoints, schemas, and responses remain unchanged
- Swagger UI now displays only tags with active endpoints
- Validated: spec.json is valid OpenAPI 3.0.3
- Updates improve documentation clarity, navigation, and compatibility with SwaggerHub's auto-mocking service
- Maintains backward compatibility with existing functionality

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
