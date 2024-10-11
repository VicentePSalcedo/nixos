
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
    bottom #btm to view resource usage
    discord
    du-dust #dust to view file usage
    dunst #handles notifications
    fira-code-nerdfont
    firefox
    flameshot #screen shot app
    hunspell
    hunspellDicts.en_US
    just #just Just
    libreoffice
    minecraft
    neofetch
    obsidian #note taking app
    playerctl #used to bind media keys
    prismlauncher
    pywal #generates colorscheme based off of wallpaper
    rhythmbox #music player
    slack
    syncthing
    xfce.thunar
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
