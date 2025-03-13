#!/bin/bash

# Read react-native version from package.json
REACT_NATIVE_VERSION=$(jq -r '.dependencies["react-native"]' package.json)

# Create a temporary directory for the react-native repo
TEMP_REACT_NATIVE_DIR=$(mktemp -d ./tmp-react-native-repo)

echo "Cloning react-native (v$REACT_NATIVE_VERSION) to $TEMP_REACT_NATIVE_DIR"
git clone --branch "v$REACT_NATIVE_VERSION" --single-branch --depth 1 https://github.com/facebook/react-native.git $TEMP_REACT_NATIVE_DIR

# Use our patched ReactAndroid from node_modules
cp -r ./node_modules/react-native/ReactAndroid $TEMP_REACT_NATIVE_DIR/packages/react-native/

cd $TEMP_REACT_NATIVE_DIR

# Install dependencies
yarn install --non-interactive

# Build and publish to maven repository
./gradlew build
./gradlew publishAllToMavenTempLocal

# Remove a temporary directory
rm -rf $TEMP_REACT_NATIVE_DIR
