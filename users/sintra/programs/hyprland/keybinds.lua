-- Keybindings
local mainMod = "ALT"

-- Terminal and launcher
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("footclient"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("/home/sintra/nixos/users/sintra/programs/hyprland/toggle-wallpaper.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("networkmanager_dmenu"))
hl.bind(mainMod .. " + X", hl.dsp.window.close())
-- Logout: lock screen (hyprlock). True exit: `hyprctl dispatch exit` in a terminal
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit"))

-- Dwindle pseudo split = shrink window as if already split, next window fills the other half
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.layout("pseudo"))

-- Volume control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("/home/sintra/nixos/users/sintra/programs/hyprland/toggle-mic.sh"))

-- Mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move focus with mainMod + Vim keys (h, j, k, l)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Global trigger for Rhythmbox "add to last playlist" (in-app key is Ctrl+L)
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("busctl --user call org.gnome.Rhythmbox3 /org/rhythmbox/AddToLastPlaylist org.rhythmbox.AddToLastPlaylist AddToLast"))

-- Swap/move windows with mainMod + SHIFT + Vim keys (h, j, k, l)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [q w e r t y u i o p]
-- Move active window to a workspace with mainMod + SHIFT + [q w e r t y u i o p]
local wsKeys = { "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" }
for i, key in ipairs(wsKeys) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Brightness control
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

-- Laptop lid switch control (Turn off eDP-1 when lid is closed, turn on when opened)
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("/home/sintra/nixos/users/sintra/programs/hyprland/handle-lid.sh close"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("/home/sintra/nixos/users/sintra/programs/hyprland/handle-lid.sh open"), { locked = true })
