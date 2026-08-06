-- Window rules (Steam-focused)

-- Prevent the main Steam client from starting as a floating window
hl.window_rule({
    name  = "fix-steam-client-floating",
    match = {
        class         = "steam",
        initial_title = "Steam",
        float         = true,
    },
    float    = false,
    maximize = true,
})

-- Automatically float and center annoying Steam sub-menus, lists, and popups
hl.window_rule({
    name  = "float-steam-utilities",
    match = {
        class = "steam",
        title = "^(Sign in to Steam|Steam Login|Friends List|Chat|Settings|Steam Guard|Screenshot Uploader|Product Activation|Steam - News|Steam - Self Updater|WebHelper|Steam Guard - Computer Authorization Required)$",
    },
    float  = true,
    center = true,
})

-- Ensure Steam games (steam_app_*) run in full-screen with no compositor blur
hl.window_rule({
    name       = "steam-apps-fullscreen",
    match      = { class = "^steam_app_\\d+$" },
    fullscreen = true,
})
hl.window_rule({
    name    = "steam-apps-no-blur",
    match   = { class = "^steam_app_\\d+$" },
    no_blur = true,
})

-- Fallback: Force all floating Steam windows to center on screen
hl.window_rule({
    name  = "center-floating-steam",
    match = {
        class = "^steam$",
        float = true,
    },
    center = true,
})
