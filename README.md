# Proto API Documentation

![Version](https://img.shields.io/badge/version-1.7.3-blue.svg)
![API](https://img.shields.io/badge/API-Proto%20Mining-orange.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)

Interactive API documentation for the Proto mining device API. This documentation provides complete information about all available endpoints and allows testing them directly through the browser.

## Features

- **Proto API Assistant**: Interactive chatbot for instant API documentation queries
  - Search endpoints by keyword, tag, or path
  - View operation details with examples
  - Explore schema definitions
  - Generate cURL commands
- Complete API reference with 43 endpoints
- Interactive "Try it now" functionality
- Dark theme optimized for readability
- Mobile responsive design
- Real-time request/response testing

## API Groups

- **Mining Operations**: Control and monitor mining operations
- **System Management**: System-level controls and information
- **Pool Management**: Configure and manage mining pools
- **Performance Monitoring**: Track hashrate, temperature, and power
- **Hardware Management**: Manage hashboards, PSUs, and cooling
- **Authentication**: Secure API access control

## Getting Started

1. Visit the [API Documentation](https://proto-sdk.github.io/proto-api-docs)
2. Click the 💬 button in the bottom-right to open the Proto API Assistant
3. Ask questions like "find pools", "schema Pool", or "curl PUT /api/v1/mining/target"
4. Browse available endpoints by category
5. Click "Try it now" on any endpoint to test it
6. View request/response details in real-time

## Local Development

```bash
# Clone the repository
git clone https://github.com/proto-sdk/proto-api-docs.git

# Navigate to the directory
cd proto-api-docs

# Start a local server
python3 -m http.server 8000

# Visit http://localhost:8000 in your browser
```

## License

MIT License

## Contact

For support or inquiries, contact mining@block.xyz
