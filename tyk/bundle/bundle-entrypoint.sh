#!/bin/bash
# This script serves a helper script to run the Tyk bundler tool to create a production-ready plugin bundle.
set -euo pipefail;
echo "Bundling plugins...";

# Copy custom plugin to bundle directory
cp /opt/tyk-gateway/middleware/example.so /opt/tyk-gateway/bundle/example/example.so;
cp /opt/tyk-gateway/middleware/example2.so /opt/tyk-gateway/bundle/example2/example2.so;
cp /opt/tyk-gateway/middleware/example3.so /opt/tyk-gateway/bundle/example3/example3.so;

# Get current timestamp
DATESTRING=$(date -I)
TIMESTAMP=$(date +%s)

# Run bundler tool in bundle directory
cd /opt/tyk-gateway/bundle/example && /opt/tyk-gateway/tyk bundle build --output "example1_${DATESTRING}_${TIMESTAMP}.zip" -y;
cd /opt/tyk-gateway/bundle/example2 && /opt/tyk-gateway/tyk bundle build --output "example2_${DATESTRING}_${TIMESTAMP}.zip" -y;
cd /opt/tyk-gateway/bundle/example3 && /opt/tyk-gateway/tyk bundle build --output "example3_${DATESTRING}_${TIMESTAMP}.zip" -y;

# Cleanup
rm /opt/tyk-gateway/bundle/example/example.so;
rm /opt/tyk-gateway/bundle/example2/example2.so;
rm /opt/tyk-gateway/bundle/example3/example3.so;

# Exit
echo "Done bundling plugins.";
exit 0;