{ pkgs, ... }:
{
  imports = [
    ./fastfetch
    ./hyprland
    ./nu
    ./polybar
    ./starship
    ./waybar

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

    # cli
    codex
    dunst
    playerctl
    pywal16
    ueberzugpp
    unzip
    yt-dlp

    # because rust
    bat
    bacon
    bottom
    cargo-info
    du-dust
    eza
    feh
    fd
    gitui
    just
    mprocs
    ripgrep
    rmpc # music player
    rqbit
    rusty-man
    speedtest-rs
    wiki-tui
    wl-clipboard-rs
    yazi
    zoxide

    # dev tools for colaboration
    chromium
    firefox-bin
    google-cloud-sdk
    google-chrome
    meld
    postman
    vscodium

    # software for client work
    cifs-utils
    nfs-utils
    rustdesk # rusty
    samba

    # fonts
    nerd-fonts.fira-code
  ];

  services = {
    syncthing.enable = true;
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
