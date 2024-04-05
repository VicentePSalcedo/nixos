{ config, pkgs, ... }:

{
  imports = [
    ./home
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";

  home.packages = with pkgs; [
    htop
    fira-code-nerdfont
    neofetch
    firefox
    just
    obsidian
  ];
  home.stateVersion = "23.11";

  programs.home-manager.enable= true;
}
