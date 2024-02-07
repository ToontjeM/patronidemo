#!/bin/sh

source env.sh

docker exec -it p1 << EOF
psql -c "select inet_server_addr() as CURRENT_NODE from 