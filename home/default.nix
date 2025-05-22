{ pkgs, ... }:
{
  imports = [
    ./fastfetch
    ./hyprland
    ./nu
    ./polybar
    ./starship

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
    gimp
    librewolf
    obsidian
    signal-desktop-bin
    thunderbird
    vesktop
    xfce.thunar
    xfce.tumbler

    # cli
    bat
    bacon
    bottom
    cargo-info
    cmus
    du-dust
    dunst
    eza
    feh
    gitui
    just
    mprocs
    playerctl
    pywal16
    ripgrep
    rmpc
    speedtest-rs
    unzip
    wiki-tui
    wl-clipboard-rs
    yt-dlp

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
