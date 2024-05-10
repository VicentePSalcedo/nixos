{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./alacritty
    ./bash
    ./gtk
    ./nvim
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
    google-chrome
    # gnucash
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
    tmux
    yt-dlp #youtube audio downloads
  ];
  services = {
    redshift = {
        enable = true;
        longitude = -81.5;
        latitude = 28.5;
    };
    services.syncthing.enable = true;
  };
  home.stateVersion = "23.11";
  programs.home-manager.enable= true;
}
