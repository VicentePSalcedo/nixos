{ pkgs, ... }: {

  imports = [
    ./polybar
    ./nvim

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
    anki-bin
    direnv
    du-dust # dust to view file usage
    dunst # handles notifications
    nerd-fonts.fira-code # favorite font that support ligatures
    flameshot #screen capture tool
    gimp # image editing
    google-chrome # keeping work and business separated
    hunspell 
    hunspellDicts.en_US# spelling support for nvim 
    just # just Just
    librewolf
    neofetch # show off
    networkmanagerapplet #nm-applet in the cli
    playerctl # used to bind media keys
    pywal # setting wallpaper and a matching color scheme
    rhythmbox
    xfce.thunar
    yt-dlp # youtube audio downloads
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
  programs.home-manager.enable = true;

}
