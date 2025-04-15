#!/bin/bash

# printf colors
export N=$(tput sgr0)
export R=$(tput setaf 1)
export G=$(tput setaf 2)

# Token
if [ -f "$HOME/tokens/.edb_subscription_token" ]; then   # Running on local machine
  export EDB_SUBSCRIPTION_TOKEN=$(cat "$HOME/tokens/.edb_subscription_token")
else  # Running in a VM
  export EDB_SUBSCRIPTION_TOKEN=$(cat "/tokens/.edb_subscription_token")
fi

# Environment variables
export EDBVERSION=17
export EDBCONFIGDIR=/var/lib/edb/as17