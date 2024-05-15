
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../home/alacritty
    ../home/bash
    ../home/nvim
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    bottom #btm to view resource usage
    discord
    du-dust #dust to view file usage
    dunst #handles notifications
    fira-code-nerdfont
    firefox
    flameshot #screen shot app
    google-chrome
    just #just Just
    neofetch
    playerctl #used to bind media keys
    pywal #generates colorscheme based off of wallpaper
    obsidian #note taking app
    r2modman
    rofi #application menu
    rhythmbox #music player
    rustup #favorite programing language
    slack
    syncthing
    thunderbird
    tmux
    yt-dlp #youtube audio downloads
  ];
  services = {
    redshift = {
        enable = true;
        longitude = -81.5;
        latitude = 28.5;
    };
    syncthing.enable = true;
  };
  home.stateVersion = "23.11";
  programs.home-manager.enable= true;
}
