#!/usr/bin/env bash
# Handle laptop lid switch events under Hyprland
# logind is configured to ignore lid close on external power (HandleLidSwitchExternalPower=ignore)
# so this script is the sole handler — no race with logind.

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
        # Small delay to let the kernel/DRM settled after lid switch detection,
        # preventing a race where the first hyprctl monitor disable doesn't take.
        sleep 0.3
        hyprctl keyword monitor "eDP-1, disable" || sleep 0.3 && hyprctl keyword monitor "eDP-1, disable"
    else
        # No external monitor — suspend instead of blanking the screen,
        # since logind won't do it for us on external power.
        systemctl suspend
    fi
elif [[ "$action" == "open" ]]; then
    # Always re-enable internal display when opening the lid
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
fi
