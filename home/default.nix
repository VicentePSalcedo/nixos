{ pkgs, ... }:
{

  imports = [
    #./hyprland
    ./polybar
    ./nvim

    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./gtk.nix
    ./picom.nix
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
    nerd-fonts.fira-code
    firefox
    gimp
    gnucash
    hunspell
    hunspellDicts.en_US
    just #just Just
    libreoffice
    neofetch
    playerctl #used to bind media keys
    pywal
    rhythmbox
    signal-desktop
    syncthing
    thunderbird
    yt-dlp #youtube audio downloads
  ];


  services = {
    syncthing.enable = true;
    redshift = {
      enable = true;
      latitude = 30.19;
      longitude = -81.39;
      tray = true;
    };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable= true;

}
