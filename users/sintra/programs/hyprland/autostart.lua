-- Autostart applications
hl.on("hyprland.start", function()
    hl.exec_cmd("foot --server")
    hl.exec_cmd("swaybg -i /home/sintra/nixos/wallpapers/tokyonight.png -m fill")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("/home/sintra/nixos/users/sintra/programs/hyprland/handle-resume.sh")

    -- Workspace-pinned apps (placement enforced by window rules in rules.lua)
    hl.exec_cmd("vesktop --start-minimized")
    hl.exec_cmd("signal-desktop --start-in-tray")
    hl.exec_cmd("thunderbird")
    hl.exec_cmd("cozy")
end)
