#!/usr/bin/env python3
"""
Update the /api/v1/hardware endpoint to include the Fans tag
This allows the endpoint to appear under the Fans section in the API docs
"""

import json
import sys
from pathlib import Path

def update_fans_endpoint():
    """Add Fans tag to /api/v1/hardware endpoint"""
    
    spec_path = Path(__file__).parent / 'spec.json'
    
    # Read current spec
    print(f"Reading spec from: {spec_path}")
    with open(spec_path, 'r') as f:
        spec = json.load(f)
    
    # Create backup
    backup_path = spec_path.with_suffix('.json.backup.fans-update')
    print(f"Creating backup at: {backup_path}")
    with open(backup_path, 'w') as f:
        json.dump(spec, f, indent=2)
    
    # Check if /api/v1/hardware exists
    if '/api/v1/hardware' not in spec['paths']:
        print("❌ Error: /api/v1/hardware endpoint not found")
        return False
    
    # Get the endpoint
    hardware_endpoint = spec['paths']['/api/v1/hardware']
    
    # Update GET method tags
    if 'get' in hardware_endpoint:
        current_tags = hardware_endpoint['get'].get('tags', [])
        print(f"\nCurrent tags for GET /api/v1/hardware: {current_tags}")
        
        # Add Fans tag if not already present
        if 'Fans' not in current_tags:
            # Add Fans tag while keeping existing tags
            hardware_endpoint['get']['tags'] = current_tags + ['Fans']
            print(f"Updated tags: {hardware_endpoint['get']['tags']}")
        else:
            print("Fans tag already present")
    
    # Write updated spec
    print(f"\nWriting updated spec to: {spec_path}")
    with open(spec_path, 'w') as f:
        json.dump(spec, f, indent=2)
    
    print("\n✅ Successfully updated /api/v1/hardware endpoint")
    print(f"   - Added 'Fans' tag to GET /api/v1/hardware")
    print(f"   - Tags now: {hardware_endpoint['get']['tags']}")
    print(f"   - Backup saved to: {backup_path.name}")
    
    return True

if __name__ == '__main__':
    try:
        success = update_fans_endpoint()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"\n❌ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
