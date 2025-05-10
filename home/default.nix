{ pkgs, ... }:
{
  imports = [
    ./polybar

    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./gtk.nix
    ./helix.nix
    ./picom.nix
    ./rofi.nix
  ];

  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    # home sweet home
    cmus
    du-dust
    dunst
    fastfetchMinimal
    feh
    just
    librewolf
    obsidian
    networkmanagerapplet
    nerd-fonts.fira-code
    nnn
    playerctl
    pywal16 # setting wallpaper and a matching color scheme
    rhythmbox
    signal-desktop-bin
    thunderbird
    vesktop
    xfce.thunar # file explorer
    xfce.tumbler

    # dev tools
    direnv
    google-chrome
    postman
    vscodium

    # software for clients
    cifs-utils
    nfs-utils
    rustdesk
    samba
  ];

  services = {
    syncthing.enable = true;
    # lmao, doxing myself in the name of eye safety
    # redshift = {
    #   enable = true;
    #   latitude = 30.19;
    #   longitude = -81.39;
    #   tray = true;
    # };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}
