#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

EXPECTED_HOSTNAME="$1"

if [ "$(hostname)" != "$EXPECTED_HOSTNAME" ]; then
    echo "This script must be run on $EXPECTED_HOSTNAME. Exiting."
    exit 1
fi