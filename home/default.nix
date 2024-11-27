{ pkgs, ... }:
{

  imports = [
    ./hyprland
    ./nvim

    ./alacritty.nix
    ./bash.nix
    ./rofi.nix
  ];

  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    anki-bin
    bottom #btm to view resource usage
    direnv
    du-dust #dust to view file usage
    dunst #handles notifications
    kdePackages.elisa
    fira-code-nerdfont
    firefox
    hunspell
    hunspellDicts.en_US
    just #just Just
    libreoffice
    neofetch
    obsidian #note taking app
    playerctl #used to bind media keys
    pywal
    syncthing
    vesktop
    yt-dlp #youtube audio downloads
  ];


  services = {
    syncthing.enable = true;
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable= true;

}
