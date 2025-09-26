# Force GitHub Pages Default Domain Only

This repository is configured to ONLY serve content from:
https://proto-sdk.github.io/proto-api-docs/

Custom domains are explicitly disabled and prevented.

## Changes Made:
- Removed all CNAME files
- Added JavaScript redirect to force canonical URL
- Added meta tags to prevent caching of custom domains
- Updated _config.yml to disable custom domain usage
- Added .nojekyll configuration

## Verification:
- proto.rig.dev domain does not exist (NXDOMAIN)
- All traffic is forced to GitHub Pages default domain
- No custom domain redirects are possible

Last updated: Fri Sep 26 14:24:21 PDT 2025
