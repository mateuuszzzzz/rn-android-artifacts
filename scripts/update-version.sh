#!/bin/bash

PROPERTIES_FILE="node_modules/react-native/ReactAndroid/gradle.properties"

# Get version from environment variable or fallback version from package.json (used for builds from source)
if [ -n "$RN_VERSION" ]; then
    CURRENT_VERSION="$RN_VERSION"
else
    CURRENT_VERSION=$(jq -r '.dependencies["react-native"]' package.json)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to read version from package.json"
        exit 1
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