{ pkgs, ... }:
{
  imports = [
    ./fastfetch
    ./nu
    ./polybar
    ./starship
    ./waybar

    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./gtk.nix
    ./helix.nix
    ./hyprland # configs
    ./picom.nix
    ./rofi.nix
  ];

  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    # home sweet home
    amberol
    gimp
    librewolf
    obsidian
    signal-desktop-bin
    thunderbird
    vesktop
    vlc

    # cli
    codex
    dunst
    github-cli
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
    # firefox-bin
    google-cloud-sdk
    google-chrome
    meld
    postman
    vscodium

    # software for client work
    cifs-utils
    nfs-utils
    samba

    # fonts
    nerd-fonts.fira-code
  ];

  programs.keychain = {
    enable = true;
    enableNushellIntegration = true;
    keys = [

    ];
  };
  programs.pay-respects = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.yazi.enableNushellIntegration = true;

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
