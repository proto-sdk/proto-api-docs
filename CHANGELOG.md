# Proto API Documentation Changelog

All notable changes to the Proto API documentation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

For technical support or questions about the API, please contact: mining.support@block.xyz
