{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./alacritty 
    ./bash 
    ./nvim
    ./picom
    ./rofi
    ./git
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    cargo-make
    discord
    du-dust
    dunst
    fira-code-nerdfont
    firefox
    gnucash
    google-chrome
    just
    mictray
    neofetch
    nnn
    pywal
    obsidian
    ripgrep
    rustup
    slack
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
