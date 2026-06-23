#!/usr/bin/env bash
# Toggle microphone mute/unmute with notification

# Toggle the default source (microphone)
wpctl set-mute @DEFAULT_SOURCE@ toggle

# Check new state and notify
sleep 0.1
vol_output=$(wpctl get-volume @DEFAULT_SOURCE@ 2>/dev/null)

if echo "$vol_output" | grep -q "MUTED"; then
  notify-send "🎤 Mic Muted" "Microphone is now muted" -u low -t 2000 2>/dev/null
else
  notify-send "🎤 Mic Unmuted" "Microphone is now active" -u low -t 2000 2>/dev/null
fi
