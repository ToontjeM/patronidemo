#!/bin/bash

. /config/config.sh

printf "${R}*** Running Bootstrap_general.sh ***${N}\n"
systemctl stop firewalld.service
systemctl disable firewalld.service
sudo dnf remove firewalld
sed -i 's/%wheel/#%wheel/g' /etc/sudoers
sed -i 's/# #%wheel/%wheel/g' /etc/sudoers
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config


printf "${R}*** Configuring repo with token ${EDB_SUBSCRIPTION_TOKEN} ***${N}\n"
curl -1sLf "https://downloads.enterprisedb.com/${EDB_SUBSCRIPTION_TOKEN}/enterprise/setup.rpm.sh" | sudo -E bash

printf "${R}*** Running updates ***${N}\n"
dnf update && dnf -y upgrade

printf ""