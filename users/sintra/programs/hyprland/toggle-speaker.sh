#!/usr/bin/env bash
# Toggle internal speaker on/off
# When toggling ON: unmute speaker, set to 50%, make it the default sink
# When toggling OFF: mute speaker, set volume to 0%, switch default to Bluetooth

SPEAKER_NAME="Ryzen HD Audio Controller Speaker"
BT_NAME="JLab JBuds Lux ANC"

# Get sink IDs from wpctl status, only matching within the Sinks section
wpctl_output=$(wpctl status 2>/dev/null)

SPEAKER_ID=$(echo "$wpctl_output" | awk -v name="$SPEAKER_NAME" '
  /├─ Sinks:/ { in_sinks=1 }
  /├─ Sources:/ { in_sinks=0 }
  in_sinks && match($0, /[[:space:]]+([0-9]+)\./, m) { id = m[1] }
  in_sinks && $0 ~ name && id != "" { print id; exit }
')

BT_ID=$(echo "$wpctl_output" | awk -v name="$BT_NAME" '
  /├─ Sinks:/ { in_sinks=1 }
  /├─ Sources:/ { in_sinks=0 }
  in_sinks && match($0, /[[:space:]]+([0-9]+)\./, m) { id = m[1] }
  in_sinks && $0 ~ name && id != "" { print id; exit }
')

if [ -z "$SPEAKER_ID" ]; then
  notify-send "Audio Toggle" "Internal speaker not found" -u low 2>/dev/null
  exit 1
fi

# Check current mute state of speaker
vol_output=$(wpctl get-volume "$SPEAKER_ID" 2>/dev/null)

if echo "$vol_output" | grep -q "MUTED"; then
  # Speaker is muted → enable it
  wpctl set-mute "$SPEAKER_ID" 0
  wpctl set-volume "$SPEAKER_ID" 50%
  wpctl set-default "$SPEAKER_ID"
  notify-send "🔊 Speaker" "Internal speaker enabled" -u low -t 2000 2>/dev/null
else
  # Speaker is active → disable it, switch to Bluetooth
  wpctl set-mute "$SPEAKER_ID" 1
  wpctl set-volume "$SPEAKER_ID" 0%
  if [ -n "$BT_ID" ]; then
    wpctl set-default "$BT_ID"
    notify-send "🎧 Bluetooth" "Switched to Bluetooth audio" -u low -t 2000 2>/dev/null
  else
    notify-send "🔇 Speaker" "Internal speaker muted" -u low -t 2000 2>/dev/null
  fi
fi
