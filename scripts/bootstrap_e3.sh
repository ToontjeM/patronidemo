#!/bin/bash

. /config/config.sh

printf "${R}*** Running Bootstrap_e3.sh ***${N}\n"

printf "${R}*** Installing etcd ***${N}\n"
ETCD_VER=v3.3.8

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/coreos/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/test-etcd && mkdir -p /tmp/test-etcd

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/test-etcd --strip-components=1

sudo cp /tmp/test-etcd/etcd* /usr/local/bin
sudo cp /config/etcd-e3.service /etc/systemd/system/etcd-e3.service

/usr/local/bin/etcd --version
ETCDCTL_API=3 /usr/local/bin/etcdctl version

printf "${G}*** Starting etcd on e1 ***${N}\n"
sudo systemctl daemon-reload
sudo systemctl enable etcd-e3.service

