{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../home/alacritty
    ../home/bash
    ../home/gtk
    ../home/nvim
    ../home/rofi
    ../home/polybar
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    du-dust #dust to view file usage
    dunst #handles notifications
    fira-code-nerdfont
    flameshot #screen shot app
    google-chrome
    just #just Just
    neofetch
    playerctl #used to bind media keys
    pywal #generates colorscheme based off of wallpaper
    obsidian #note taking app
    rofi #application menu
    rhythmbox #music player
    slack
    syncthing
    tmux
    yt-dlp #youtube audio downloads
  ];
  services = {
    redshift = {
      enable = true;
      longitude = -82.5;
      latitude = 27.5;
    };
  };
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
