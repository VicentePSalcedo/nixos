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
    amberol
    cmus
    rhythmbox

    # cli
    evhz
    gemini-cli-bin
    geminicommit
    github-cli
    grimblast # Screenshot tool
    htop
    nchat # Terminal-based chat with support for Telegram and WhatsApp
    nmap
    playerctl
    pywal16
    ueberzugpp # Allows to draw images on terminals using X11/Wayland
    unzip
    vim # ICE
    yt-dlp

    # because rust
    bat # better cat
    # bacon
    bottom # better htop
    # cargo-info
    du-dust
    eza
    feh
    fd
    gitui
    just
    # mprocs
    ripgrep
    rqbit
    # rusty-man
    speedtest-rs
    # wiki-tui
    # wl-clipboard-rs
    yazi
    zoxide

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

  # extra directories to add to the PATH
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
