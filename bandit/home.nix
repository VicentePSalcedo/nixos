{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../home/alacritty
    ../home/gtk
    ../home/bash
    ../home/nvim
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    discord
    fira-code-nerdfont
    google-chrome
    jetbrains.idea-community
    just #just Just
    libreoffice
    obsidian #note taking app
    pywal
    rhythmbox
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
