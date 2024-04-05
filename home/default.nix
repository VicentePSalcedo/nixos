{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix 
    ./bash.nix 
    ./git.nix
    ./nvim.nix
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
    obsidian
  ];
  home.stateVersion = "23.11";

  programs.home-manager.enable= true;
}
