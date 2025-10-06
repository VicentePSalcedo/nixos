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
    ./hyprland
    ./rofi.nix
  ];

  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.packages = with pkgs; [
    # home sweet home
    android-studio
    firefox
    gimp
    libreoffice
    mako
    obsidian
    protonvpn-gui
    signal-desktop-bin
    thunderbird # Email Client
    vesktop # Wayland friendly discord
    vlc

    # music players
    # amberol
    cmus
    # rhythmbox

    # cli tools
    evhz # Show mouse refresh rate under linux + evdev
    gemini-cli-bin
    grimblast # Screenshot tool
    nchat # Terminal-based chat with support for Telegram and WhatsApp
    ncdu # god-tier terminal utility for identifing large user files and deleting them
    nmap
    playerctl
    pywal16
    # ueberzugpp # Allows to draw images on terminals using X11/Wayland
    unzip
    vim # ICE
    yt-dlp

    # because rust
    # bacon
    bottom # better htop
    # cargo-info
    feh
    fd
    gitui
    # mprocs
    ripgrep
    rqbit
    # rusty-man
    speedtest-rs
    # wiki-tui
    # wl-clipboard-rs

    # # dev tools for colaboration
    # chromium
    dbeaver-bin
    # firefox-bin
    # google-cloud-sdk
    google-chrome
    # nodejs_24
    # postman
    # vscodium

    # software for client work
    cifs-utils
    nfs-utils
    samba

    # font(s)
    nerd-fonts.fira-code
  ];

  home.file.".justfile" = {
    source = ../justfile;
  };

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  programs.yazi.enableNushellIntegration = true;

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
