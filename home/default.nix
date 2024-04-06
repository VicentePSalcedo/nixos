{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./nvim
    ./alacritty.nix 
    ./bash.nix 
    ./git.nix
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";

  home.packages = with pkgs; [
    discord
    fira-code-nerdfont
    firefox
    gcc_multi
    htop
    just
    libgcc
    libgccjit
    mictray
    neofetch
    obsidian
    google-chrome
  ];

  home.stateVersion = "23.11";

  programs.home-manager.enable= true;
}
