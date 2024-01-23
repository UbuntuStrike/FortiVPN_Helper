#!/bin/bash

echo "Try to connect to the VPN now"
x=99
while [ $x -ne 0 ]
do
  echo "Waiting for VPN connection..."
  sleep 1
  connection=$(nmcli connection show | grep -oP '^vpn\S*')
  x=$?
done

echo "VPN connection $connection was created! Waiting for 'device-reapply'..."
x=99
while [ $x -ne 0 ]
do
  nmcli -f GENERAL.STATE con show $connection 2> /dev/null
  x=${PIPESTATUS[0]}
  sleep 1
  echo "Still waiting..."
done

echo "Device is unmanaged. Setting it to 'up' again..."
nmcli con up $connection 2> /dev/null
echo "Done."
