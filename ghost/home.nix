
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../home/alacritty
    ../home/bash
    ../home/nvim
    ../home/polybar
    ../home/picom
    ../home/rofi
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    anki
    bottom #btm to view resource usage
    discord-canary
    du-dust #dust to view file usage
    dunst #handles notifications
    ferium
    fira-code-nerdfont
    firefox
    flameshot #screen shot app
    google-chrome
    heroic
    just #just Just
    lutris
    minecraft
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
    # support both 32- and 64-bit applications
    wineWowPackages.stable
    winetricks
  ];
  services = {
    syncthing.enable = true;
  };
  home.stateVersion = "23.11";
  programs.home-manager.enable= true;
}
