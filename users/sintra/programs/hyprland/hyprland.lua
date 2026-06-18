-- Hyprland Lua Config — Tokyo Night Storm
-- Per-workspace layouts: ws1 = master, ws2-10 = dwindle

local mainMod = "ALT"

-- Monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Autostart
hl.exec_once("swaybg -i /home/sintra/nixos/wallpapers/tokyonight.png -m fill")
hl.exec_once("waybar")
hl.exec_once("mako")

-- General
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(7aa2f7ee)", "rgba(bb9af7ee)"}, angle = 45 },
            inactive_border = "rgba(414868aa)",
        },
    },
})

-- Layout configs
hl.config({ master = { mfact = 0.55 } })
hl.config({ dwindle = { preserve_split = true } })

-- Decoration
hl.config({
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 8,
            passes = 2,
        },
        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = 0xee151522,
            color_inactive = 0x99101014,
        },
    },
})

-- Custom curves
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

-- Animations
hl.anim({
    { event = "windows",    duration = 7, curve = "myBezier" },
    { event = "windowsOut", duration = 7, curve = "default", style = "popin 80%" },
    { event = "border",     duration = 10, curve = "default" },
    { event = "borderangle",duration = 8,  curve = "default" },
    { event = "fade",       duration = 7,  curve = "default" },
    { event = "workspaces", duration = 6,  curve = "default" },
})

-- Input
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Layer rules (blur for fuzzel)
hl.layer_rule({ match = { namespace = "fuzzel" }, blur = true, ignore_alpha = 0.5 })

-- Steam window rules
hl.window_rule({ match = { class = "^steam$" }, workspace = 5 })

hl.window_rule({
    name = "fix-steam-client-floating",
    match = { class = "steam", initial_title = "Steam", float = true },
    float = false,
    maximize = true,
})

hl.window_rule({
    name = "float-steam-utilities",
    match = {
        class = "steam",
        title = "^(Sign in to Steam|Steam Login|Friends List|Chat|Settings|Steam Guard|Screenshot Uploader|Product Activation|Steam - News|Steam - Self Updater|WebHelper|Steam Guard - Computer Authorization Required)$",
    },
    float = true,
    center = true,
})

hl.window_rule({ match = { class = "^steam_app_%d+$" }, fullscreen = true, no_blur = true })
hl.window_rule({ match = { class = "^steam$", float = true }, center = true })

-- Per-workspace layouts: ws1 = master, ws2-10 = dwindle
hl.workspace_rule({ workspace = "1", layout = "master" })
hl.workspace_rule({ workspace = "2", layout = "dwindle" })
hl.workspace_rule({ workspace = "3", layout = "dwindle" })
hl.workspace_rule({ workspace = "4", layout = "dwindle" })
hl.workspace_rule({ workspace = "5", layout = "dwindle" })
hl.workspace_rule({ workspace = "6", layout = "dwindle" })
hl.workspace_rule({ workspace = "7", layout = "dwindle" })
hl.workspace_rule({ workspace = "8", layout = "dwindle" })
hl.workspace_rule({ workspace = "9", layout = "dwindle" })
hl.workspace_rule({ workspace = "10", layout = "dwindle" })

-- Keybinds
hl.bind(mainMod + " + Return", hl.exec("ghostty"))
hl.bind(mainMod + " + N",     hl.exec("networkmanager_dmenu"))
hl.bind(mainMod + " + X",     hl.dsp.killactive())
hl.bind(mainMod + " + M",     hl.dsp.exit())
hl.bind(mainMod + " + E",     hl.exec("dolphin"))
hl.bind(mainMod + " + V",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod + " + semicolon", hl.exec("fuzzel"))
hl.bind(mainMod + " + F",     hl.dsp.fullscreen(0))
hl.bind(mainMod + " + S",     hl.dsp.layout("togglesplit"))

-- Move/resize with mouse
hl.bind(mainMod + " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod + " + mouse:273", hl.dsp.window.resize(),  { mouse = true })

-- Focus with Vim keys
hl.bind(mainMod + " + H", hl.dsp.movefocus("l"))
hl.bind(mainMod + " + L", hl.dsp.movefocus("r"))
hl.bind(mainMod + " + K", hl.dsp.movefocus("u"))
hl.bind(mainMod + " + J", hl.dsp.movefocus("d"))

-- Focus with arrow keys
hl.bind(mainMod + " + left",  hl.dsp.movefocus("l"))
hl.bind(mainMod + " + right", hl.dsp.movefocus("r"))
hl.bind(mainMod + " + up",    hl.dsp.movefocus("u"))
hl.bind(mainMod + " + down",  hl.dsp.movefocus("d"))

-- Move windows with SHIFT + Vim
hl.bind(mainMod + " + Shift + H", hl.dsp.window.move("l"))
hl.bind(mainMod + " + Shift + L", hl.dsp.window.move("r"))
hl.bind(mainMod + " + Shift + K", hl.dsp.window.move("u"))
hl.bind(mainMod + " + Shift + J", hl.dsp.window.move("d"))

-- Switch workspaces (per-workspace layout auto-applied via workspace rules)
hl.bind(mainMod + " + Q",     hl.dsp.workspace(1))
hl.bind(mainMod + " + W",     hl.dsp.workspace(2))
hl.bind(mainMod + " + E",     hl.dsp.workspace(3))
hl.bind(mainMod + " + R",     hl.dsp.workspace(4))
hl.bind(mainMod + " + T",     hl.dsp.workspace(5))
hl.bind(mainMod + " + Y",     hl.dsp.workspace(6))
hl.bind(mainMod + " + U",     hl.dsp.workspace(7))
hl.bind(mainMod + " + I",     hl.dsp.workspace(8))
hl.bind(mainMod + " + O",     hl.dsp.workspace(9))
hl.bind(mainMod + " + P",     hl.dsp.workspace(10))

-- Move window to workspace
hl.bind(mainMod + " + Shift + Q", hl.dsp.window.movetoworkspace(1))
hl.bind(mainMod + " + Shift + W", hl.dsp.window.movetoworkspace(2))
hl.bind(mainMod + " + Shift + E", hl.dsp.window.movetoworkspace(3))
hl.bind(mainMod + " + Shift + R", hl.dsp.window.movetoworkspace(4))
hl.bind(mainMod + " + Shift + T", hl.dsp.window.movetoworkspace(5))
hl.bind(mainMod + " + Shift + Y", hl.dsp.window.movetoworkspace(6))
hl.bind(mainMod + " + Shift + U", hl.dsp.window.movetoworkspace(7))
hl.bind(mainMod + " + Shift + I", hl.dsp.window.movetoworkspace(8))
hl.bind(mainMod + " + Shift + O", hl.dsp.window.movetoworkspace(9))
hl.bind(mainMod + " + Shift + P", hl.dsp.window.movetoworkspace(10))

-- Audio switching
hl.bind(mainMod + " + Ctrl + S", hl.exec("wpctl set-default 54"))
hl.bind(mainMod + " + Ctrl + H", hl.exec("wpctl set-default 53"))

-- Volume control
hl.bind("XF86AudioRaiseVolume", hl.exec("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),            { repeating = true })
hl.bind("XF86AudioMute",        hl.exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Brightness control
hl.bind("XF86MonBrightnessUp",   hl.exec("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.exec("brightnessctl set 5%-"))
