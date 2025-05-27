#!/usr/bin/env bash

INTERNAL_MONITOR_NAME="eDP-1"
EXTERNAL_MONITOR_NAME="DP-1"
EXTERNAL_RESOLUTION="1920x1080@120"

configure_monitors() {
    echo "Configuring monitors..."
    CONNECTED_MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

    if echo "$CONNECTED_MONITORS" | grep -q "$EXTERNAL_MONITOR_NAME"; then
        echo "External monitor ($EXTERNAL_MONITOR_NAME) detected. Enabling..."
        hyprctl keyword monitor "$EXTERNAL_MONITOR_NAME,$EXTERNAL_RESOLUTION,0x0,1"
        hyprctl keyword monitor "$INTERNAL_MONITOR_NAME,disable"
        echo "External monitor active, internal disabled."
    else
        echo "External monitor not detected. Enabling internal..."
        hyprctl keyword monitor "$INTERNAL_MONITOR_NAME,1920x1080@60.05,0x0,1"
        echo "Internal monitor active."
    fi
    echo "Monitor configuration complete."
}

configure_monitors

socat - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r event;
do
    echo "Received Hyprland event: $event"
    if [[ "$event" =~ ^monitor(added|removed), ]]; then
        echo "Monitor hotplug event detected. Reconfiguring..."
        configure_monitors
    fi
done
