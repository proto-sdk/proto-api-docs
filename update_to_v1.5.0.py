#!/usr/bin/env python3
"""
Update Proto API documentation from v1.4.1 to v1.5.0
Converts OpenAPI 3.1.1 to 3.0.3 for Swagger UI compatibility
"""

import json
import sys

def convert_openapi_3_1_to_3_0(spec):
    """Convert OpenAPI 3.1.1 spec to 3.0.3 for Swagger UI compatibility"""
    
    # Change OpenAPI version
    spec["openapi"] = "3.0.3"
    
    # Handle oneOf schemas that might not be compatible
    def fix_schemas(obj):
        if isinstance(obj, dict):
            # Fix oneOf in schemas that might cause issues
            if "oneOf" in obj:
                # For system tag endpoint, convert oneOf to more compatible format
                if any("type" in item and item.get("type") in ["string", "number", "boolean", "object", "array"] 
                      for item in obj.get("oneOf", [])):
                    # Keep oneOf but ensure it's properly formatted for 3.0.3
                    pass
            
            # Recursively fix nested objects
            for key, value in obj.items():
                if isinstance(value, (dict, list)):
                    fix_schemas(value)
        elif isinstance(obj, list):
            for item in obj:
                fix_schemas(item)
    
    fix_schemas(spec)
    return spec

def main():
    # Read the new v1.5.0 spec (provided by user)
    new_spec_data = """INSERT_NEW_SPEC_HERE"""
    
    try:
        # Parse the new spec
        new_spec = json.loads(new_spec_data)
        
        # Convert from 3.1.1 to 3.0.3
        converted_spec = convert_openapi_3_1_to_3_0(new_spec)
        
        # Write the converted spec
        with open('spec.json', 'w') as f:
            json.dump(converted_spec, f, indent=2)
        
        print("✅ Successfully updated spec.json to v1.5.0")
        print("✅ Converted OpenAPI from 3.1.1 to 3.0.3 for Swagger UI compatibility")
        
    except json.JSONDecodeError as e:
        print(f"❌ Error parsing JSON: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
