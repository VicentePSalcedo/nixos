{ config, pkgs, inputs, ... }:

{
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Import split-out application configurations
  imports = [
    ./programs/bash.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/helix.nix
    ./programs/hermes.nix
    ./programs/hyprland
    ./programs/librewolf.nix
    ./programs/nushell.nix
    ./programs/waybar
    ./programs/fuzzel.nix
    ./programs/yazi.nix
  ];

  # Packages to install for the user's environment
  home.packages = with pkgs; [
    mako         # Lightweight notification daemon
    swaybg       # Wallpaper utility
    grim         # Screenshot utility
    slurp        # Region selector for screenshots
    wl-clipboard # Wayland clipboard manager
    networkmanager_dmenu # Control NetworkManager via wofi
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    uv           # Fast Python package installer and runner
    
    # CLI Utilities
    gh           # GitHub CLI
    just         # Fast task/command runner
    bottom       # Beautiful process viewer (btm)
    zoxide       # Smart directory navigation (z)
    dust         # Beautiful disk usage utility (du)
    
    # Media & Entertainment
    beets        # Music library organizer
    spotify      # Music streaming desktop client
    vesktop      # Wayland-friendly Discord client with Vencord
    
    # Gaming Optimizations & Utilities
    mangohud     # Vulkan/OpenGL performance overlay
    protonup-qt  # Easy GE-Proton installer manager
  ];

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = fuzzel --dmenu
    active_chars = ==

    [editor]
    terminal = ghostty
    gui_if_use_terminal = true
  '';
}
