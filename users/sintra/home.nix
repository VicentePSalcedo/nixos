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
    ./programs/fastfetch.nix
    ./programs/direnv.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/gtk.nix
    ./programs/helix.nix
    ./programs/hermes.nix
    ./programs/hyprland
    ./programs/librewolf.nix
    ./programs/nushell.nix
    ./programs/starship.nix
    ./programs/waybar
    ./programs/fuzzel.nix
    ./programs/yazi.nix
    ./programs/zoxide.nix
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
    unzip        # Extract zip archives
    rqbit        # Bittorrent client in Rust
    typst        # Modern typesetting system
    
    # CLI Utilities
    gh           # GitHub CLI
    lazygit      # Simple terminal UI for git
    bottom       # Beautiful process viewer (btm)
    dust         # Beautiful disk usage utility (du)
    aerc         # Terminal email client
    pulsemixer   # TUI for PulseAudio/PipeWire
    
    # Media & Entertainment
    beets        # Music library organizer
    spotify      # Music streaming desktop client
    vesktop      # Wayland-friendly Discord client with Vencord
    signal-desktop # Private, simple, and secure messenger
    
    # Gaming Optimizations & Utilities
    mangohud     # Vulkan/OpenGL performance overlay
    protonup-qt  # Easy GE-Proton installer manager
    prismlauncher # Advanced Minecraft launcher

    # Rust Analyzer MCP server for AI coding assistants
    (rustPlatform.buildRustPackage {
      pname = "rust-analyzer-mcp";
      version = "0.2.0";
      src = fetchFromGitHub {
        owner = "zeenix";
        repo = "rust-analyzer-mcp";
        rev = "v0.2.0";
        hash = "sha256-brnzVDPBB3sfM+5wDw74WGqN5ahtuV4OvaGhnQfDqM0=";
      };
      cargoHash = "sha256-7t4bjyCcbxFAO/29re7cjoW1ACieeEaM4+QT5QAwc34=";
      doCheck = false;
      postPatch = ''
        substituteInPlace src/main.rs \
          --replace-fail 'let response = self.handle_request(request).await;' \
                         'if request.id.is_none() { debug!("Ignoring notification: {}", request.method); continue; } let response = self.handle_request(request).await;'
      '';
    })
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
