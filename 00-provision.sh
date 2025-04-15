#!/bin/bash

. ./config/config.sh

printf "${G}*** Provisioning new VM's ***${N}\n"
vagrant up --provision e1
vagrant up --provision e2
vagrant up --provision e3

printf "${G}*** Starting etcd on all nodes ***${N}\n"
for NODE in 1 2 3; do
    echo "Restarting etcd on $NODE..."
    # to start service
    vagrant ssh e"${NODE}" -c "sudo systemctl daemon-reload"
    vagrant ssh e"${NODE}" -c "sudo systemctl enable etcd-e${NODE}.service"
    vagrant ssh e"${NODE}" -c "sudo systemctl start etcd-e${NODE}.service"
    vagrant ssh e"${NODE}" -c "sudo systemctl status etcd-e${NODE}.service"
done
vagrant ssh e1 -c "ETCDCTL_API=3 /usr/local/bin/etcdctl --endpoints 192.168.56.21:2379,192.168.56.22:2379,192.168.56.23:2379 endpoint health

#vagrant up --provision p1
#vagrant up --provision p2
#vagrant up --provision p3
#
#vagrant up --provision h1
#vagrant up --provision h2
