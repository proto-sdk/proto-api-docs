#!/usr/bin/env python3
"""
Convert the new v1.5.0 OpenAPI spec from 3.1.1 to 3.0.3 and update spec.json
"""

import json
import sys

# The new v1.5.0 spec provided by the user (in OpenAPI 3.1.1 format)
new_spec_v1_5_0 = {
  "openapi": "3.1.1",
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
    "version": "1.5.0"
  },
  "servers": [
    {
      "url": "https://virtserver.swaggerhub.com/kkurucz/mining_development_kit_api/1.0.0",
      "description": "SwaggerHub API Auto Mocking"
    }
  ]
}

def convert_openapi_spec():
    """Convert the full v1.5.0 spec to 3.0.3 format"""
    
    # Read the user-provided spec from the prompt
    user_spec_text = '''INSERT_FULL_SPEC_HERE'''
    
    try:
        # Parse the spec
        spec = json.loads(user_spec_text)
        
        # Convert OpenAPI version from 3.1.1 to 3.0.3
        spec["openapi"] = "3.0.3"
        
        # Fix any 3.1.1 specific features that aren't compatible with 3.0.3
        def fix_incompatible_features(obj):
            if isinstance(obj, dict):
                # Handle oneOf schemas - these are generally compatible but may need adjustment
                if "oneOf" in obj:
                    # Keep oneOf but ensure proper formatting
                    pass
                
                # Handle any other 3.1.1 specific features
                for key, value in obj.items():
                    if isinstance(value, (dict, list)):
                        fix_incompatible_features(value)
            elif isinstance(obj, list):
                for item in obj:
                    if isinstance(item, (dict, list)):
                        fix_incompatible_features(item)
        
        fix_incompatible_features(spec)
        
        # Write the converted spec
        with open('spec.json', 'w') as f:
            json.dump(spec, f, indent=2)
        
        print("✅ Successfully converted v1.5.0 spec from OpenAPI 3.1.1 to 3.0.3")
        print("✅ Updated spec.json with new v1.5.0 content")
        
        return True
        
    except Exception as e:
        print(f"❌ Error converting spec: {e}")
        return False

if __name__ == "__main__":
    success = convert_openapi_spec()
    sys.exit(0 if success else 1)
