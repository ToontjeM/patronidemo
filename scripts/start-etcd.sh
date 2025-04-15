#!/bin/bash

PEERS=("192.168.56.21" "192.168.56.22" "192.168.56.23")
SELF_IP=$(hostname -I | awk '{print $2}')

echo "[$(hostname)] Waiting for peers..."
for ip in "${PEERS[@]}"; do
  if [ "$ip" != "$SELF_IP" ]; then
    until ping -c1 $ip >/dev/null 2>&1; do
      echo "Waiting on $ip..."
      sleep 2
    done
  fi
done

echo "[$(hostname)] All peers up. Starting etcd..."
sudo systemctl start etcd-$HOSTNAME
