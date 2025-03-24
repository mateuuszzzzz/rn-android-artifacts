#!/bin/bash

CURRENT_VERSION=$(jq -r '.dependencies["react-native"]' package.json)
if [ $? -ne 0 ]; then
    echo "Error: Failed to read react-native version from package.json"
    exit 1
fi

HASH=$(find patches -type f -name "react-native+${CURRENT_VERSION}*.patch" -exec sha256sum {} + | sort | sha256sum | awk '{print $1}')

if [ -f "mappings.json" ]; then
    MAPPED_VERSION=$(jq -r --arg hash "$HASH" '.[$hash] // empty' mappings.json)
    if [ ! -z "$MAPPED_VERSION" ]; then
        echo true
        exit 0
    fi
fi

echo false
exit 0