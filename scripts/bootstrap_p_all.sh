#!/bin/bash

. /config/config.sh

curl -1sSLf "https://downloads.enterprisedb.com/${EDB_SUBSCRIPTION_TOKEN}/enterprise/setup.rpm.sh" | sudo -E bash
sudo dnf -y install edb-as17-server edb-patroni

export PGPORT=5444
export PGUSER=enterprisedb
export PGGROUP=enterprisedb
export PGDATA="/var/lib/edb/as17/data"
export PGBIN="/usr/edb/as17/bin"
export PGBINNAME="edb-postgres"
export PGSOCKET="/var/run/edb/as17"
export CLUSTER_NAME="cluster-1"
export MY_NAME=$(hostname --short)
export MY_IP=$(hostname -I | awk ' {print $1}')

sudo /usr/edb/as17/bin/edb-as-17-setup initdb
sudo systemctl stop edb-as-17.service
sudo systemctl disable edb-as-17.service

cat <<EOF | sudo tee /etc/udev/rules.d/99-watchdog.rules
KERNEL=="watchdog", OWNER="$PGUSER", GROUP="$PGGROUP"
EOF
sudo sh -c 'echo "softdog" >> /etc/modules-load.d/softdog.conf'
sudo modprobe softdog
sudo chown $PGUSER:$PGGROUP /dev/watchdog

cat <<EOF | sudo tee /etc/patroni.yml
scope: $CLUSTER_NAME
namespace: /db/
name: $MY_NAME

restapi:
  listen: "0.0.0.0:8008"
  connect_address: "$MY_IP:8008"
  authentication:
    username: patroni
    password: patroni

etcd3:
    hosts:
    - e1:2379
    - e2:2379
    - e3:2379

bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
      use_pg_rewind: true
      use_slots: true
      parameters:
        archive_mode: "on"
        archive_command: "/bin/true"

  initdb:
  - encoding: UTF8
  - data-checksums
  - auth-local: peer
  - auth-host: scram-sha-256

  pg_hba:
  - host replication replicator 0.0.0.0/0 scram-sha-256
  - host all all 0.0.0.0/0 scram-sha-256

  # Some additional users which needs to be created after initializing new cluster
  users:
    admin:
      password: admin
      options:
        - createrole
        - createdb

postgresql:
  listen: "0.0.0.0:$PGPORT"
  connect_address: "$MY_IP:$PGPORT"
  data_dir: $PGDATA
  bin_dir: $PGBIN
  bin_name:
    postgres: $PGBINNAME
  pgpass: /tmp/pgpass0
  authentication:
    replication:
      username: replicator
      password: replicator
    superuser:
      username: enterprisedb
      password: enterprisedb
    rewind:
      username: rewind
      password: rewind
  parameters:
    unix_socket_directories: "$PGSOCKET,/tmp"

watchdog:
  mode: required
  device: /dev/watchdog
  safety_margin: 5

tags:
  nofailover: false
  noloadbalance: false
  clonefrom: false
  nosync: false
EOF

cat <<EOF | sudo tee /etc/systemd/system/patroni.service
[Unit]
Description=Runners to orchestrate a high-availability Postgres
After=syslog.target network.target

[Service]
Type=simple
User=$PGUSER
Group=$PGGROUP
EnvironmentFile=-/etc/patroni_env.conf
ExecStart=patroni /etc/patroni.yml
ExecReload=/bin/kill -s HUP \$MAINPID
KillMode=process
TimeoutSec=30
Restart=no

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable patroni
