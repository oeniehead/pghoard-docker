#!/usr/bin/env sh

set -e

if [ -n "$TESTING" ]; then
    echo "Not running backup when testing"
    exit 0
fi

cat /pghoard.json.template | sed "s/\"password\": \"replica\"/\"password\": \"${REPLICA_PASSWORD}\"/" | sed "s/\"user\": \"replica\"/\"user\": \"${REPLICA_USER}\"/" > /pghoard.json
pghoard --config /pghoard.json