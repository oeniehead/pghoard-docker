#!/usr/bin/env sh

set -e

if [ -n "$TESTING" ]; then
    echo "Not running backup when testing"
    exit 0
fi

export POSTGRES_REPLICA_PASSWORD=`cat $POSTGRES_REPLICA_PASSWORD_FILE`

cat /pghoard.json.template | envsubst > /pghoard.json

pghoard --config /pghoard.json