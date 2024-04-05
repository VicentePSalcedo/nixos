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
  xdg.configFile.nvim = {
      source = ./home/nvim/.config;
      recursive = true;
  };
  home.stateVersion = "23.11";

  programs.home-manager.enable= true;
}
