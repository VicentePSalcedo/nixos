-- Hyprland Lua configuration (v0.56+)
-- Replaces the legacy .conf (Hyprlang) format, which is deprecated.

-- ==============================================================================
-- Monitor configuration (Forces scale 1 to prevent huge UI)
-- ==============================================================================
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

-- ==============================================================================
-- Input configuration
-- ==============================================================================
hl.config({
    input = {
        kb_layout     = "us",
        follow_mouse  = 1,
        sensitivity   = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- ==============================================================================
-- General styling
-- ==============================================================================
hl.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 10,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgb(7aa2f7)", "rgb(bb9af7)" }, angle = 45 },
            inactive_border = "rgb(414868)",
        },
        layout = "dwindle",
    },
})

-- ==============================================================================
-- Disable update news dialog
-- ==============================================================================
hl.config({
    ecosystem = {
        no_update_news = true,
    },
})

-- ==============================================================================
-- Dwindle layout configuration
-- ==============================================================================
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- ==============================================================================
-- Visual decoration
-- ==============================================================================
hl.config({
    decoration = {
        rounding         = 10,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled = false,
            size    = 8,
            passes  = 2,
        },
        shadow = {
            enabled        = false,
            range          = 15,
            render_power   = 3,
            color          = "rgba(151522ee)",
            color_inactive = "rgba(10101499)",
        },
    },
})

-- ==============================================================================
-- Animations (disabled for pure performance; re-add hl.curve/hl.animation if
-- you ever enable them)
-- ==============================================================================
hl.config({
    animations = {
        enabled = false,
    },
})

-- ==============================================================================
-- Modular sources
-- ==============================================================================
require("autostart")
require("rules")
require("keybinds")
