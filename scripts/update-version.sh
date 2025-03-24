#!/bin/bash

PROPERTIES_FILE="node_modules/react-native/ReactAndroid/gradle.properties"

# Get RN version from package.json
CURRENT_VERSION=$(jq -r '.dependencies["react-native"]' package.json)
if [ $? -ne 0 ]; then
    echo "Error: Failed to read react-native version from package.json"
    exit 1
fi

# Compute hash of all patches for given RN version
HASH=$(find patches -type f -name "react-native+${CURRENT_VERSION}*.patch" -exec sha256sum {} + | sort | sha256sum | awk '{print $1}')

if [ -f "mappings.json" ]; then
    MAPPED_VERSION=$(jq -r --arg hash "$HASH" '.[$hash] // empty' mappings.json)
    if [ ! -z "$MAPPED_VERSION" ]; then
        echo "Found mapped version: $CURRENT_VERSION for hash: $HASH"
        CURRENT_VERSION="$MAPPED_VERSION"
    fi
fi

# Check if file exists
if [ ! -f "$PROPERTIES_FILE" ]; then
    echo "Error: $PROPERTIES_FILE does not exist"
    exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/VERSION_NAME=.*/VERSION_NAME=$CURRENT_VERSION/" "$PROPERTIES_FILE"
else
    sed -i "s/VERSION_NAME=.*/VERSION_NAME=$CURRENT_VERSION/" "$PROPERTIES_FILE"
fi

if [ $? -eq 0 ]; then
    echo "Successfully updated version to $CURRENT_VERSION"
else
    echo "Error: Failed to update version"
    exit 1
fi
