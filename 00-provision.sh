#!/bin/bash

source ./env.sh
printf "$H --- Installing nodes --- $N\n"
vagrant up
printf "$H --- Installing TPA on console --- $N\n"
cp $HOME/.edbtoken .
vagrant ssh console -c /vagrant/pre-install_tpaexec.sh
printf "$H --- Building cluster in TPA --- $N\n"
vagrant ssh console -c "cd /vagrant && tpaexec configure patroni --architecture M1 --postgresql 15 --enable-patroni --enable-haproxy --platform bare"
cp infra.yml patroni/config.yml
printf "$H --- Provisioning nodes --- $N\n"
vagrant ssh console -c "cd /vagrant && tpaexec provision patroni"
printf "$H --- Deploying software --- $N\n"
vagrant ssh console -c "cd /vagrant && tpaexec deploy patroni -vvv"