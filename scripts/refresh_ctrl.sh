#!/usr/bin/env bash

# --- CONFIGURATION ---
MONITOR="eDP-2"
RESOLUTION="2560x1600"
SCALE="1.333333"
POSITION="0x0"
# ---------------------

STATE_FILE="/tmp/hypr_refresh_state"

while true; do
    # Check power status
    IS_PLUGGED=$(cat /sys/class/power_supply/AC*/online 2>/dev/null)
    
    # Fallback default to 1 (Plugged) if sensor not found
    if [ -z "$IS_PLUGGED" ]; then IS_PLUGGED=1; fi

    # Load previous state
    if [ -f "$STATE_FILE" ]; then
        LAST_STATE=$(cat "$STATE_FILE")
    else
        LAST_STATE="-1"
    fi

    if [ "$IS_PLUGGED" != "$LAST_STATE" ]; then
        if [ "$IS_PLUGGED" -eq 1 ]; then
            # --- PLUGGED IN: 120Hz ---
            hyprctl keyword monitor "$MONITOR, $RESOLUTION@120, $POSITION, $SCALE"
            
            # Notification: High Performance
            notify-send \
                -u low \
                -i "video-display" \
                -h string:x-canonical-private-synchronous:refresh-mode \
                "AC Power Connected" "Display maximized to 120Hz"
        else
            # --- BATTERY: 60Hz ---
            hyprctl keyword monitor "$MONITOR, $RESOLUTION@60, $POSITION, $SCALE"
            
            # Notification: Battery Saver
            notify-send \
                -u low \
                -i "battery-low" \
                -h string:x-canonical-private-synchronous:refresh-mode \
                "On Battery" "Display reduced to 60Hz to save power"
        fi
        echo "$IS_PLUGGED" > "$STATE_FILE"
    fi
    sleep 5
done
