
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../home/alacritty
    ../home/bash
    ../home/gtk
    ../home/nvim
    ../home/polybar
    ../home/picom
    ../home/rofi
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    anki-bin
    amberol
    bottom #btm to view resource usage
    discord-canary
    discord-screenaudio
    du-dust #dust to view file usage
    dunst #handles notifications
    fdupes
    fira-code-nerdfont
    firefox
    flameshot #screen shot app
    google-chrome
    github-desktop
    hunspell
    hunspellDicts.en_US
    just #just Just
    libreoffice
    minecraft
    neofetch
    obsidian #note taking app
    playerctl #used to bind media keys
    pywal #generates colorscheme based off of wallpaper
    r2modman
    rofi #application menu
    rhythmbox #music player
    slack
    syncthing
    xfce.thunar
    thunderbird
    tmux
    yt-dlp #youtube audio downloads
    # support both 32- and 64-bit applications
    wineWowPackages.stable
    winetricks
  ];
  services = {
    syncthing.enable = true;
    redshift = {
        enable = true;
        longitude = -82.114749;
        latitude = 29.558167;
    };
  };
  home.stateVersion = "23.11";
  programs.direnv.enable = true;
  programs.home-manager.enable= true;
}
