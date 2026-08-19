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
    ./programs/rhythmbox.nix
    ./programs/gnucash.nix
    ./programs/helix.nix
    ./programs/hermes.nix
    ./programs/hyprland
    ./programs/nushell.nix
    ./programs/starship.nix
    ./programs/thunderbird.nix
    ./programs/waybar
    ./programs/yazi.nix
    ./programs/yt-dlp.nix
    ./programs/zoxide.nix
  ];

  # Packages to install for the user's environment
  home.packages = with pkgs; [
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    bottom
    dust
    gh
    htop
    just
    lazygit
    oci-cli
    openssl
    podman-tui
    speedtest-rs
    typst
    unzip
    uv

    beets
    gnucash
    google-chrome
    mpv
    proton-vpn
    rhythmbox
    signal-desktop
    slack
    vesktop

    grim
    mako
    networkmanager_dmenu
    pulsemixer
    slurp
    swaybg
    wl-clipboard

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
