{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./nvim
    ./alacritty 
    ./bash 
    ./git
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";

  home.packages = with pkgs; [
    discord
    du-dust
    fira-code-nerdfont
    firefox
    gcc_multi
    google-chrome
    htop
    just
    libgcc
    libgccjit
    mictray
    neofetch
    nodejs_20
    pywal
    obsidian
    rustup
    slack
    xfce.thunar
    xfce.thunar-volman
  ];

  services.picom.enable = true;

  home.stateVersion = "23.11";

  programs.home-manager.enable= true;
}
