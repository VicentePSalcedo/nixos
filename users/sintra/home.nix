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
    ./programs/beets.nix
    ./programs/direnv.nix
    ./programs/eza.nix
    ./programs/fastfetch.nix
    ./programs/zen.nix
    ./programs/fuzzel.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/gtk.nix
    ./programs/helix.nix
    ./programs/hermes.nix
    ./programs/hyprland
    ./programs/nushell.nix
    ./programs/starship.nix
    ./programs/waybar
    ./programs/yazi.nix
    ./programs/zoxide.nix
  ];

  # Packages to install for the user's environment
  home.packages = with pkgs; [
    aerc         # Terminal email client
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    beets        # Music library organizer
    bottom       # Beautiful process viewer (btm)
    dust         # Beautiful disk usage utility (du)
    gh           # GitHub CLI
    google-chrome
    grim         # Screenshot utility
    just         # Command runner
    lazygit      # Simple terminal UI for git
    mako         # Lightweight notification daemon
    mangohud     # Vulkan/OpenGL performance overlay
    mpv          # Versatile media player
    musikcube    # Terminal-based music player, library, and streaming server
    networkmanager_dmenu # Control NetworkManager via wofi
    podman-tui   # Terminal UI for Podman
    prismlauncher # Advanced Minecraft launcher
    protonup-qt  # Easy GE-Proton installer manager
    pulsemixer   # TUI for PulseAudio/PipeWire
    rustdesk     # Open-source remote desktop alternative
    (callPackage ./programs/rust-analyzer-mcp.nix {})
    rqbit        # Bittorrent client in Rust
    signal-desktop # Private, simple, and secure messenger
    spotify      # Music streaming desktop client
    slurp        # Region selector for screenshots
    swaybg       # Wallpaper utility
    typst        # Modern typesetting system
    unzip
    uv           # Fast Python package installer and runner
    (callPackage ./programs/verso.nix {})
    vesktop      # Wayland-friendly Discord client with Vencord
    wl-clipboard # Wayland clipboard manager
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
