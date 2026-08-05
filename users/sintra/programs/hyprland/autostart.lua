-- Autostart applications
hl.on("hyprland.start", function()
    hl.exec_cmd("foot --server")
    hl.exec_cmd("swaybg -i /home/sintra/nixos/wallpapers/tokyonight.png -m fill")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("/home/sintra/nixos/users/sintra/programs/hyprland/handle-resume.sh")
    hl.exec_cmd("protonvpn-app")
end)
