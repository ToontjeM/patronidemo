#!/bin/bash

sudo systemctl start patroni
patronictl -c /etc/patroni.yml list