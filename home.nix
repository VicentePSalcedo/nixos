{ config, pkgs, ... }:

{
  imports = [
    ./home
  ];
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";

  home.packages = with pkgs; [
    fira-code-nerdfont
    firefox
    htop
    just
    mictray
    neofetch
    neovim
    obsidian
  ];
  xdg.configFile.nvim = {
      source = ./home/nvim/.config;
      recursive = true;
  };
  home.stateVersion = "23.11";

  programs.home-manager.enable= true;
}
