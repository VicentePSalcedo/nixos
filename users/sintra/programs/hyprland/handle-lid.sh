#!/usr/bin/env bash
# Handle laptop lid switch events under Hyprland

action=$1

# Check if an external monitor is connected
external_connected=false
for status_file in /sys/class/drm/card*-*/status; do
    if [[ "$status_file" == *"-eDP-"* ]]; then
        continue
    fi
    if [[ -f "$status_file" ]] && [[ "$(cat "$status_file")" == "connected" ]]; then
        external_connected=true
        break
    fi
done

if [[ "$action" == "close" ]]; then
    if [[ "$external_connected" == "true" ]]; then
        # Disable internal display ONLY if an external monitor is connected
        hyprctl keyword monitor "eDP-1, disable"
    else
        # If no external monitor, let systemd handle suspension (sleep) and do not disable the monitor in Hyprland
        # This prevents the black screen / no-wake issue when resuming from sleep without a dock.
        true
    fi
elif [[ "$action" == "open" ]]; then
    # Always re-enable internal display when opening the lid
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
fi
