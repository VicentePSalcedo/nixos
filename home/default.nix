{ pkgs, ... }:
{
  imports = [
    ./nu
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
    feh
    gimp
    librewolf
    obsidian
    signal-desktop-bin
    # thunderbird
    vesktop
    xfce.thunar
    xfce.tumbler

    # cli
    bat
    # cargo-cargo-info
    cmus
    du-dust
    dunst
    eza
    fastfetchMinimal
    playerctl
    pywal16
    ripgrep
    speedtest-rs
    starship
    unzip
    # wiki-tui
    yt-dlp

    # dev tools I like to use
    direnv
    gitui
    just
    mprocs

    # dev tools for colaboration
    google-cloud-sdk
    google-chrome
    meld
    postman
    vscodium

    # software for client work
    cifs-utils
    nfs-utils
    rustdesk
    samba

    # fonts
    nerd-fonts.fira-code
  ];

  services = {
    syncthing.enable = true;
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
