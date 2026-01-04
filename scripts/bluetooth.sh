#!/bin/bash

# 1. Get current status
IS_BLOCKED=$(rfkill list bluetooth | grep "yes")

if [ -z "$IS_BLOCKED" ]; then
    # Currently ON -> Turn OFF (and save for reboot)
    bluetoothctl power off
    sleep 0.5
    rfkill block bluetooth
    notify-send "Bluetooth" "Hardware Disabled & Saved" -i bluetooth-disabled
else
    # Currently OFF -> Turn ON (and save for reboot)
    rfkill unblock bluetooth
    # Wait for kernel to register the hardware before powering on
    sleep 1.5 
    bluetoothctl power on
    notify-send "Bluetooth" "Hardware Enabled & Saved" -i bluetooth
fi
