#!/usr/bin/env python3
import json

# Read the current spec.json
with open('spec.json', 'r') as f:
    spec = json.load(f)

# New tags data
new_tags = [
    {
      "name": "Mining",
      "description": "The mining endpoint group allows for control and configuration of mining functionality."
    },
    {
      "name": "System",
      "description": "The system endpoint group exposes information and actions related to the overall miner system."
    },
    {
      "name": "Network",
      "description": "The network endpoint group provides information on the network configuration of the miner."
    },
    {
      "name": "Errors",
      "description": "The errors endpoint group provides active system errors (severity level errors or warnings) to surface to the UI."
    },
    {
      "name": "Pools",
      "description": "The pools endpoint group allows users to configure the list of pools the miner will connect to."
    },
    {
      "name": "Cooling",
      "description": "The cooling endpoint group provides information and control over the cooling system of the miner."
    },
    {
      "name": "Authentication",
      "description": "The authentication endpoint group contains functions related to changing the password, and other authentication-related actions."
    },
    {
      "name": "Hashboards",
      "description": "The hashboards endpoint group provides information related to the various hashboards or ASICs on those hashboards in the system."
    },
    {
      "name": "Hashrate",
      "description": "The hashrate endpoint group provides historical hashrate information for the entire miner, individual hashboards, or individual ASICs."
    },
    {
      "name": "Temperature",
      "description": "The temperature endpoint group provides historical temperature information for the entire miner, individual hashboards, or individual ASICs."
    },
    {
      "name": "Power",
      "description": "The power endpoint group provides historical power information for the entire miner or individual hashboards."
    },
    {
      "name": "Efficiency",
      "description": "The efficiency endpoint group provides historical efficiency information for the entire miner or individual hashboards."
    },
    {
      "name": "System Information",
      "description": "The system information endpoint group provides status and configuration details about the mining device system."
    },
    {
      "name": "Hardware",
      "description": "The hardware endpoint group provides information about the physical hardware components of the mining device."
    },
    {
      "name": "PSUs",
      "description": "The PSUs endpoint group provides information about the power supply units in the mining device."
    },
    {
      "name": "Fans",
      "description": "The fans endpoint group provides information about the cooling fans in the mining device."
    },
    {
      "name": "Time Series",
      "description": "The time series endpoint provides unified access to historical data for multiple metrics including hashrate, temperature, power, and efficiency in a single request."
    },
    {
      "name": "Telemetry",
      "description": "The telemetry endpoint provides current (real-time) values for all metrics available in the timeseries endpoint, with support for brief and extended detail levels."
    },
    {
      "name": "System Tag",
      "description": "The system tag endpoint group provides a simple way to set and retrieve a custom tag for the mining device."
    }
]

# Update only the tags section
spec['tags'] = new_tags

# Write the updated spec back to spec.json
with open('spec.json', 'w') as f:
    json.dump(spec, f, indent=2)

print("✅ Successfully updated tags in spec.json")
print(f"✅ Updated {len(new_tags)} tag definitions")
