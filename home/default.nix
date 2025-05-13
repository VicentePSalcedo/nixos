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
    amberol
    du-dust
    dunst
    fastfetchMinimal
    feh
    just
    librewolf
    obsidian
    meld
    nerd-fonts.fira-code
    nnn
    playerctl
    pywal16 # setting wallpaper and a matching color scheme
    signal-desktop-bin
    thunderbird
    vesktop
    xfce.thunar # file explorer
    xfce.tumbler
    yt-dlp

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
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
