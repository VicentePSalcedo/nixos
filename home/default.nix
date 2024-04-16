{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./alacritty
    ./bash
    ./nvim
    ./picom
    ./polybar
    ./rofi
    ./git
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    amberol
    bottom
    discord
    du-dust
    dunst
    fira-code-nerdfont
    firefox
    flameshot
    gnucash
    google-chrome
    just
    mictray
    neofetch
    pywal
    obsidian
    rofi
    ripgrep
    rustup
    rhythmbox
    slack
    yt-dlp
  ];
  gtk = {
    enable = true;
      font.name = "FiraCodeNerdFont";
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
  };
  home.stateVersion = "23.11";
  programs.home-manager.enable= true;
}
