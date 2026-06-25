{ config, pkgs, inputs, ... }:

{
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Import split-out application configurations
  imports = [
    ./programs/beets.nix
    ./programs/bash.nix
    ./programs/fastfetch.nix
    ./programs/direnv.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/gtk.nix
    ./programs/helix.nix
    ./programs/hermes.nix
    ./programs/hyprland
    ./programs/firefox.nix
    ./programs/nushell.nix
    ./programs/starship.nix
    ./programs/waybar
    ./programs/fuzzel.nix
    ./programs/yazi.nix
    ./programs/zoxide.nix
    ./programs/eza.nix
  ];

  # Packages to install for the user's environment
  home.packages = with pkgs; [
    mako         # Lightweight notification daemon
    swaybg       # Wallpaper utility
    grim         # Screenshot utility
    slurp        # Region selector for screenshots
    wl-clipboard # Wayland clipboard manager
    networkmanager_dmenu # Control NetworkManager via wofi
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    uv           # Fast Python package installer and runner
    just         # Command runner
    rqbit        # Bittorrent client in Rust
    typst        # Modern typesetting system
    
    # CLI Utilities
    gh           # GitHub CLI
    lazygit      # Simple terminal UI for git
    bottom       # Beautiful process viewer (btm)
    dust         # Beautiful disk usage utility (du)
    aerc         # Terminal email client
    pulsemixer   # TUI for PulseAudio/PipeWire
    unzip
    
    # Media & Entertainment
    beets        # Music library organizer
    mpv          # Versatile media player
    spotify      # Music streaming desktop client
    vesktop      # Wayland-friendly Discord client with Vencord
    signal-desktop # Private, simple, and secure messenger
    musikcube    # Terminal-based music player, library, and streaming server
    
    # Gaming Optimizations & Utilities
    mangohud     # Vulkan/OpenGL performance overlay
    protonup-qt  # Easy GE-Proton installer manager
    prismlauncher # Advanced Minecraft launcher

    # Custom Rust packages cleanly modularized with callPackage
    (callPackage ./programs/rust-analyzer-mcp.nix {})
    (callPackage ./programs/verso.nix {})
  ];

  home.file.".gemini/config/mcp_config.json".text = builtins.toJSON {
    mcpServers = {
      nixos = {
        command = "nix";
        args = [ "run" "github:utensils/mcp-nixos" "--" ];
        env = { PYTHONPATH = ""; };
      };
      github = {
        command = "nix";
        args = [ "shell" "nixpkgs#nodejs" "-c" "npx" "-y" "@modelcontextprotocol/server-github" ];
      };
      context7 = {
        command = "nix";
        args = [ "shell" "nixpkgs#nodejs" "-c" "npx" "-y" "@upstash/context7-mcp@latest" ];
      };
      rust-analyzer = {
        command = "rust-analyzer-mcp";
        args = [];
      };
    };
  };

  xdg.configFile."networkmanager-dmenu/config.ini".text = pkgs.lib.generators.toINI {} {
    dmenu = {
      dmenu_command = "fuzzel --dmenu";
      active_chars = "==";
    };
    editor = {
      terminal = "ghostty";
      gui_if_use_terminal = "true";
    };
  };
}
