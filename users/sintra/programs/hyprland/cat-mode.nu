#!/usr/bin/env nu
# Cat Mode: toggle the laptop's internal input devices (keyboard, touchpad,
# trackpoint, touchscreen) on/off, leaving external devices untouched so the
# cat can walk across the laptop in peace.
#
# Bound to ALT + C in keybinds.lua. Requires Hyprland 0.56+ (Lua config):
# the classic `hyprctl keyword device[...]:enabled` no longer works with the
# Lua parser; per-device config is applied via `hl.device` through eval.

let STATE_FILE = ($env.XDG_RUNTIME_DIR? | default "/tmp") + "/cat-mode"

# Internal input devices on wraith (see `hyprctl devices`).
# External devices (Ferris Sweep, Logitech G305) are intentionally absent.
const INTERNAL_DEVICES = [
    "at-translated-set-2-keyboard"
    "etps/2-elantech-touchpad"
    "etps/2-elantech-trackpoint"
    "raydium-corporation-raydium-touch-system"
]

def set-devices [enabled: int] {
    for dev in $INTERNAL_DEVICES {
        let cmd = (["hl.device({ name = '" $dev "', enabled = " $enabled " })"] | str join)
        ^hyprctl eval $cmd | ignore
    }
}

def notify [msg: string] {
    if (which notify-send | is-not-empty) {
        ^notify-send -u normal "Cat Mode" $msg
    }
}

let current = if ($STATE_FILE | path exists) {
    (open $STATE_FILE | str trim)
} else {
    "on"
}

if $current == "on" {
    set-devices 0
    "off" | save -f $STATE_FILE
    notify "Internal input disabled - cat may walk freely"
} else {
    set-devices 1
    "on" | save -f $STATE_FILE
    notify "Internal input enabled"
}
