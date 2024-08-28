#!/bin/bash

# List all connections
echo "Listing all connections:"
nmcli connection show

# Display active connections
echo "Active device:"
active_device=$(nmcli -t -f device connection show --active)
echo $active_device

echo "Connection type:"
connection_type=$(nmcli -t -f type connection show --active)
echo $connection_type

if ! nmcli con up "$active_device" >/dev/null 2>&1; then
    nmcli connection delete type "$connection_type" con-name "$active_device" >/dev/null 2>&1
    nmcli connection add type "$connection_type" con-name "$active_device" >/dev/null 2>&1
    nmcli con up "$active_device" >/dev/null 2>&1
else
    nmcli con up "$active_device" >/dev/null 2>&1
fi

NETNAME=$(nmcli -t -f NAME c show --active | head -n 1)
echo "Network name: $NETNAME"

nmcli connection modify "$NETNAME" ipv4.dns "1.1.1.1 1.0.0.1"
nmcli connection modify "$NETNAME" ipv6.dns "2606:4700:4700::1111 2606:4700:4700::1001"

nmcli networking off
nmcli networking on
nmcli con up "$active_device" >/dev/null 2>&1

echo "DNS has been changed to Cloudflare's DNS."
