#!/usr/bin/env python3
"""
Update Proto API spec.json to v1.5.0 with OpenAPI 3.0.3 compatibility
"""

import json
import sys

def main():
    # The new v1.5.0 spec content (converted from 3.1.1 to 3.0.3)
    new_spec = {
        "openapi": "3.0.3",  # Changed from 3.1.1 to 3.0.3
        "info": {
            "title": "Mining Development Kit API",
            "description": "The Mining Development Kit API serves as a means to access information from the mining device and make necessary adjustments to its settings.",
            "contact": {
                "email": "mining.support@block.xyz"
            },
            "license": {
                "name": "MIT",
                "url": "https://opensource.org/license/mit"
            },
            "version": "1.5.0"  # Updated version
        },
        "servers": [
            {
                "url": "https://virtserver.swaggerhub.com/kkurucz/mining_development_kit_api/1.0.0",
                "description": "SwaggerHub API Auto Mocking"
            }
        ]
    }
    
    # Read the current spec to get the existing structure
    try:
        with open('spec.json', 'r') as f:
            current_spec = json.load(f)
    except Exception as e:
        print(f"❌ Error reading current spec.json: {e}")
        return False
    
    # Update the key fields while preserving the rest of the structure
    current_spec["openapi"] = "3.0.3"
    current_spec["info"]["title"] = "Mining Development Kit API"
    current_spec["info"]["version"] = "1.5.0"
    
    # Write the updated spec
    try:
        with open('spec.json', 'w') as f:
            json.dump(current_spec, f, indent=2)
        
        print("✅ Successfully updated spec.json to v1.5.0")
        print("✅ Maintained OpenAPI 3.0.3 for Swagger UI compatibility")
        print("✅ Updated title from 'Proto API' to 'Mining Development Kit API'")
        
        return True
        
    except Exception as e:
        print(f"❌ Error writing spec.json: {e}")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
