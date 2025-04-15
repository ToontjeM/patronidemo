#!/bin/bash

. ./config/config.sh

printf "${G}*** Provisioning new VM's ***${N}\n"
vagrant up --provision e1
vagrant up --provision e2
vagrant up --provision e3

vagrant ssh e1 -c "sudo bash /scripts/start-etcd.sh" &
vagrant ssh e2 -c "sudo bash /scripts/start-etcd.sh" &
vagrant ssh e3 -c "sudo bash /scripts/start-etcd.sh" &
wait

vagrant ssh e1 -c "sudo systemctl status --no-pager etcd-e1.service"
vagrant ssh e2 -c "sudo systemctl status --no-pager etcd-e2.service"
vagrant ssh e3 -c "sudo systemctl status --no-pager etcd-e3.service"

vagrant ssh e1 -c "ETCDCTL_API=3 /usr/local/bin/etcdctl --endpoints 192.168.56.21:2379,192.168.56.22:2379,192.168.56.23:2379 endpoint health"

#vagrant up --provision p1
#vagrant up --provision p2
#vagrant up --provision p3
#
#vagrant up --provision h1
#vagrant up --provision h2
