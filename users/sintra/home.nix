{ config, pkgs, inputs, ... }:

{
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.stateVersion = "26.05";

  # Add user binary directories to PATH
  home.sessionPath = [
    "$HOME/bin"
  ];

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
    ./programs/foot.nix
    ./programs/git.nix
    ./programs/gtk.nix
    ./programs/gnucash.nix
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
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    bottom       # Beautiful process viewer (btm)
    dust         # Beautiful disk usage utility (du)
    gh           # GitHub CLI
    just         # Command runner
    lazygit      # Simple terminal UI for git
    podman-tui   # Terminal UI for Podman
    rqbit        # Bittorrent client in Rust
    speedtest-rs # CLI internet speedtest tool in Rust
    typst        # Modern typesetting system
    unzip
    uv           # Fast Python package installer and runner

    beets        # Music library organizer
    musikcube    # Terminal-based music player, library, and streaming server
    mpv          # Versatile media player
    vlc          # Cross-platform media player and streaming server
    spotify      # Music streaming desktop client

    gnucash      # Free software for double entry accounting
    google-chrome

    mangohud     # Vulkan/OpenGL performance overlay
    prismlauncher # Advanced Minecraft launcher
    protonup-qt  # Easy GE-Proton installer manager

    signal-desktop # Private, simple, and secure messenger
    vesktop      # Wayland-friendly Discord client with Vencord
    slack

    grim         # Screenshot utility
    mako         # Lightweight notification daemon
    networkmanager_dmenu # Control NetworkManager via wofi
    pulsemixer   # TUI for PulseAudio/PipeWire
    slurp        # Region selector for screenshots
    swaybg       # Wallpaper utility
    wl-clipboard # Wayland clipboard manager

    (callPackage ./programs/rust-analyzer-mcp.nix {})
    (callPackage ./programs/verso.nix {})
    thunderbird
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

  # Import nixos justfile so just commands can be run from the home directory
  home.file.".justfile".text = ''
    import 'nixos/justfile'
  '';

  xdg.configFile."networkmanager-dmenu/config.ini".text = pkgs.lib.generators.toINI {} {
    dmenu = {
      dmenu_command = "fuzzel --dmenu";
      active_chars = "==";
    };
    editor = {
      terminal = "footclient";
      gui_if_use_terminal = "true";
    };
  };
}
