#!/bin/sh
set -x  # Debug mode

echo "=== Copilot Server Startup Wrapper ==="
echo "Node version: $(node --version)"
echo "Copilot version attempt..."
copilot --version 2>&1 || echo "Version check failed"

echo ""
echo "Environment check:"
echo "- GH_TOKEN length: ${#GH_TOKEN}"
echo "- NODE_ENV: ${NODE_ENV}"
echo ""

echo "Starting Copilot server on port 4321..."
exec copilot --server --port 4321
