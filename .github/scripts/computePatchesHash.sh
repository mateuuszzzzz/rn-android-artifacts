#!/bin/bash

set -e

if [ -d "patches" ]; then
  HASH=$(find patches -type f -exec sha256sum {} + | sort | sha256sum | awk '{print $1}')
  echo "$HASH"
else
  echo ""
fi
