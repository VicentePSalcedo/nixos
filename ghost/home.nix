
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
    feh
    fira-code-nerdfont
    firefox
    flameshot #screen shot app
    gnucash
    gparted
    just #just Just
    neofetch
    playerctl #used to bind media keys
    pywal #generates colorscheme based off of wallpaper
    obsidian #note taking app
    rofi #application menu
    rhythmbox #music player
    rustup #favorite programing language
    steam
    syncthing
    tmux
    yt-dlp #youtube audio downloads
  ];
  services = {
    redshift = {
        enable = true;
        longitude = -81.5;
        latitude = 28.5;
    };
  };
  home.stateVersion = "23.11";
  programs.home-manager.enable= true;
}
