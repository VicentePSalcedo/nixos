#!/usr/bin/env bash
# Handle laptop lid switch events under Hyprland
# logind is configured to ignore lid close entirely (HandleLidSwitch=ignore,
# HandleLidSwitchExternalPower=ignore) so this script is the sole handler — no race with logind.
# Lid close suspends on battery and AC, unless an external monitor is connected
# (clamshell mode: internal display off, machine keeps running).

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
        # Small delay to let the kernel/DRM settle after lid switch detection,
        # preventing a race where the first hyprctl monitor disable doesn't take.
        sleep 0.3
        hyprctl keyword monitor "eDP-1, disable" || sleep 0.3 && hyprctl keyword monitor "eDP-1, disable"
    else
        # No external monitor — suspend (on both battery and AC, since logind ignores lid events)
        systemctl suspend
    fi
elif [[ "$action" == "open" ]]; then
    # Always re-enable internal display when opening the lid
    hyprctl keyword monitor "eDP-1, preferred, 0x0, 1"
fi
