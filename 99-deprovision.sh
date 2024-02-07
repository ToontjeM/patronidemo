#!/bin/bash

source ./env.sh

printf "$H --- De-provisioning nodes --- $N\n"
vagrant destroy --force

printf "$H --- Deleting cluster from TPA --- $N\n"
rm -rf patroni
