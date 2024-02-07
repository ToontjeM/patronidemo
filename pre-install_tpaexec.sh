#!/bin/sh

export EDB_SUBSCRIPTION_TOKEN=$(cat /vagrant/.edbtoken)

if [[ -z "${EDB_SUBSCRIPTION_TOKEN}" ]]; then
    echo "Please set credentails variable"
else
    curl -1sLf "https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/enterprise/setup.rpm.sh" | sudo -E bash
#    sudo dnf install -y libselinux-python3
    sudo dnf install -y tpaexec
    sudo  /opt/EDB/TPA/bin/tpaexec setup --use-2q-ansible

    cat >> $HOME/.bash_profile <<EOF
export PATH=$PATH:/opt/EDB/TPA/bin/
EOF
    source ~/.bash_profile
    tpaexec selftest
fi