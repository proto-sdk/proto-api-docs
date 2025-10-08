import json
import sys

# Read the original spec to preserve structure
try:
    with open('spec.json.old', 'r') as f:
        original_spec = json.load(f)
    print("Loaded original spec successfully")
except Exception as e:
    print(f"Error loading original spec: {e}")
    sys.exit(1)

# Update the key fields to match the new version
original_spec["openapi"] = "3.1.1"
original_spec["info"]["title"] = "Mining Development Kit API"
original_spec["info"]["version"] = "1.4.1"

# Update the server URL
original_spec["servers"][0]["url"] = "https://virtserver.swaggerhub.com/mining_development_kit_api/1.4.1"

# Add the new tags that weren't in the original
new_tags = [
    {
      "name": "Telemetry",
      "description": "The telemetry endpoint provides current (real-time) values for all metrics available in the timeseries endpoint, with support for brief and extended detail levels."
    },
    {
      "name": "System Tag",
      "description": "The system tag endpoint group provides a simple way to set and retrieve a custom tag for the mining device."
    }
]

# Check if these tags already exist, if not add them
existing_tag_names = [tag["name"] for tag in original_spec.get("tags", [])]
for new_tag in new_tags:
    if new_tag["name"] not in existing_tag_names:
        original_spec["tags"].append(new_tag)
        print(f"Added new tag: {new_tag['name']}")

# Write the updated spec
try:
    with open('spec.json', 'w') as f:
        json.dump(original_spec, f, indent=2)
    print("Updated spec.json successfully!")
    print("Key changes made:")
    print("- Updated OpenAPI version to 3.1.1")
    print("- Updated title to 'Mining Development Kit API'")
    print("- Updated version to 1.4.1")
    print("- Updated server URL to 1.4.1")
    print("- Added Telemetry and System Tag endpoint groups")
except Exception as e:
    print(f"Error writing updated spec: {e}")
    sys.exit(1)

