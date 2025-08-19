{ pkgs, ... }:
{
  imports = [
    ./fastfetch
    ./nu
    ./starship
    ./waybar

    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./gtk.nix
    ./helix.nix
    ./hyprland # configs
    ./rofi.nix
  ];

  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    # home sweet home
    firefox
    gimp
    libreoffice
    mako
    obsidian
    protonvpn-gui
    rhythmbox
    signal-desktop-bin
    thunderbird
    vesktop
    vlc

    # cli
    chromedriver
    github-cli
    grimblast
    nchat
    nmap
    playerctl
    pywal16
    ueberzugpp
    unzip
    vim
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
    nodejs_24
    postman
    vscodium

    # software for client work
    cifs-utils
    nfs-utils
    samba

    # fonts
    nerd-fonts.fira-code
  ];

  home.sessionPath = [
    "$HOME/.npm-global"
  ];

  services.syncthing.enable = true;

  programs.yazi.enableNushellIntegration = true;

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
