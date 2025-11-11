#!/bin/bash

# This script updates the pubspec.yaml file to ensure rive_native
# is set as a path dependency (../rive_native)

PUBSPEC="pubspec.yaml"
RIVE_NATIVE_PATH="../rive_native"

if ! [ -f "$PUBSPEC" ]; then
  echo "pubspec.yaml not found!"
  exit 1
fi

# Replace the rive_native dependency with a path-based dependency
# This handles both inline format (rive_native: 0.0.16) and existing path format
sed -i.bak '
  /^[[:space:]]*rive_native:/ {
    # Print the rive_native: line
    c\
  rive_native:\
    path: '"$RIVE_NATIVE_PATH"'
    # If the next line is a path: line, delete it
    n
    /^[[:space:]]*path:/d
  }
' "$PUBSPEC"

rm -f "${PUBSPEC}.bak"

echo "Updated rive_native dependency to path: $RIVE_NATIVE_PATH in pubspec.yaml"
