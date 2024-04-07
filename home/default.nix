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
    discord
    du-dust
    dunst
    fira-code-nerdfont
    gcc_multi
    google-chrome
    just
    libgcc
    libgccjit
    mictray
    neofetch
    nodejs_21
    pywal
    obsidian
    ripgrep
    rustup
    slack
  ];
  home.stateVersion = "23.11";
  programs.home-manager.enable= true;
}
