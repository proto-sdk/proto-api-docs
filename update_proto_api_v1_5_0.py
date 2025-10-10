#!/usr/bin/env python3
"""
Update Proto API Documentation to v1.5.0 with requested changes:
1. Change title at top of page to "Proto API Documentation"
2. Change title at top of spec to "Proto API"
3. Change description to "The Proto API serves as a means to access information from the mining device and make necessary adjustments to its settings."
4. Remove kkurucz from virtual server path without breaking functionality
5. Change auto-mocking server version to 1.5.0
"""

import json
import re

def update_spec_json():
    """Update the OpenAPI specification file"""
    print("Updating spec.json...")
    
    with open('spec.json', 'r') as f:
        spec = json.load(f)
    
    # 1. Change title at top of spec to "Proto API"
    spec['info']['title'] = "Proto API"
    
    # 2. Change description
    spec['info']['description'] = "The Proto API serves as a means to access information from the mining device and make necessary adjustments to its settings."
    
    # 3. Remove kkurucz from virtual server path and update version to 1.5.0
    for server in spec.get('servers', []):
        if 'virtserver.swaggerhub.com' in server.get('url', ''):
            # Remove kkurucz and update version
            server['url'] = "https://virtserver.swaggerhub.com/mining_development_kit_api/1.5.0"
            server['description'] = "SwaggerHub API Auto Mocking"
    
    # Write the updated spec
    with open('spec.json', 'w') as f:
        json.dump(spec, f, indent=2, ensure_ascii=False)
    
    print("✓ Updated spec.json successfully")

def update_index_html():
    """Update the HTML index file"""
    print("Updating index.html...")
    
    with open('index.html', 'r') as f:
        content = f.read()
    
    # 1. Change title at top of page to "Proto API Documentation"
    content = re.sub(
        r'<title>.*?</title>',
        '<title>Proto API Documentation</title>',
        content
    )
    
    # 2. Change the header h1 to "Proto API Documentation"
    content = re.sub(
        r'<h1>.*?</h1>',
        '<h1>Proto API Documentation</h1>',
        content
    )
    
    # Write the updated HTML
    with open('index.html', 'w') as f:
        f.write(content)
    
    print("✓ Updated index.html successfully")

def main():
    """Main function to run all updates"""
    print("Starting Proto API v1.5.0 update...")
    print("=" * 50)
    
    try:
        update_spec_json()
        update_index_html()
        
        print("=" * 50)
        print("✅ All updates completed successfully!")
        print("\nChanges made:")
        print("1. ✓ Changed page title to 'Proto API Documentation'")
        print("2. ✓ Changed spec title to 'Proto API'")
        print("3. ✓ Updated description to Proto API description")
        print("4. ✓ Removed kkurucz from virtual server path")
        print("5. ✓ Updated auto-mocking server version to 1.5.0")
        
    except Exception as e:
        print(f"❌ Error during update: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())
