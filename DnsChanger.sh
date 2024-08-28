#!/bin/bash
#

active_device=$(sudo nmcli -t -f device connection show --active)

connection_type=$(sudo nmcli -t -f type connection show --active)


if ! sudo nmcli con up "$active_device" >/dev/null 2>&1; then

	sudo nmcli connection delete type "$connection_type" con-name "$active_device" >/dev/null 2>&1

	sudo nmcli connection add type "$connection_type" con-name "$active_device" >/dev/null 2>&1

	sudo nmcli con up "$active_device" >/dev/null 2>&1
else
	sudo nmcli con up "$active_device" >/dev/null 2>&1
fi

NETNAME=$(sudo nmcli -t -f NAME c show --active | head -n 1)

sudo nmcli connection modify "$NETNAME" ipv4.dns "1.1.1.1 1.0.0.1"
sudo nmcli connection modify "$NETNAME" ipv6.dns "2606:4700:4700::1111 2606:4700:4700::1001"

sudo nmcli networking off
sudo nmcli networking on
sudo nmcli con up "$active_device" >/dev/null 2>&1

echo "DNS has been changed to Cloudflare's DNS."
