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
    ./programs/yazi.nix
  ];

  # Packages to install for the user's environment
  home.packages = with pkgs; [
    wofi         # Wayland application launcher
    mako         # Lightweight notification daemon
    swaybg       # Wallpaper utility
    grim         # Screenshot utility
    slurp        # Region selector for screenshots
    wl-clipboard # Wayland clipboard manager
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
  ];
}
