{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./alacritty
    ./bash
    ./git
    ./gtk
    ./nvim
    ./picom
    ./polybar
    ./rofi
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    bottom #btm to view resource usage
    discord
    du-dust #dust to view file usage
    dunst #handles notifications
    fira-code-nerdfont
    flameshot #screen shot app
    gnucash
    google-chrome #I wanna get rid of this but I need it for work
    just #just Just
    neofetch
    playerctl #used to bind media keys
    pywal #generates colorscheme based off of wallpaper
    obsidian #note taking app
    rofi #application menu
    rustup #favorite programing language
    rhythmbox #music player
    signal-desktop
    slack
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
