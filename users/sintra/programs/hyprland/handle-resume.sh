#!/usr/bin/env bash
# Listen for systemd suspend/resume events via D-Bus and re-enable displays if needed

dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" | \
while read -r line; do
    # When line contains "boolean false", it means the system is resuming from sleep
    if echo "$line" | grep -q "boolean false"; then
        # Wait a moment for the system and graphic drivers to fully wake up and DRM state to settle
        sleep 1
        
        # Check if the laptop lid is physically open
        if grep -q open /proc/acpi/button/lid/*/state; then
            # Re-run the lid open logic to ensure the internal display is re-enabled
            /home/sintra/nixos/users/sintra/programs/hyprland/handle-lid.sh open
        fi
    fi
done
