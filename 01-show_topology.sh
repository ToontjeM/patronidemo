#!/bin/sh

source env.sh

printf "$H --- Current topology --- $N"
docker exec -it p1 patronictl -c /etc/patroni/patroni.yml topology