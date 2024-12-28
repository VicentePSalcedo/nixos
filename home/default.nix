{ pkgs, ... }:
{

  imports = [
    #./hyprland
    ./polybar
    ./nvim

    ./alacritty.nix
    ./bash.nix
    ./gtk.nix
    ./picom.nix
    ./rofi.nix
  ];

  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    bottom #btm to view resource usage
    direnv
    du-dust #dust to view file usage
    dunst #handles notifications
    fira-code-nerdfont
    firefox
    gimp
    godot_4
    hunspell
    hunspellDicts.en_US
    just #just Just
    libreoffice
    neofetch
    nautilus
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
