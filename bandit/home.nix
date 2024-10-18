{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../home/alacritty
    ../home/nvim
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    fira-code-nerdfont
    jetbrains.idea-community
    just #just Just
    libreoffice
    neofetch
    obsidian #note taking app
    syncthing
    tmux
    yt-dlp #youtube audio downloads
  ];
  programs.direnv.enable = true;
  services = {
    syncthing.enable = true;
    redshift = {
        enable = true;
        longitude = -82.114749;
        latitude = 29.558167;
    };
  };
  home.stateVersion = "23.11";
  programs.home-manager.enable= true;
}
