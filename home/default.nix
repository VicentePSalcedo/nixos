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
    anki-bin # flash card app
    direnv # cause "nix develope" is to much to type everytime
    du-dust # dust to view file usage
    dunst # handles notifications
    feh # most basic bitch image viewer I could find (hope you like keyboard navigation)
    gimp
    google-chrome
    just # just Just, (yeah I'm lazy)
    librewolf # becuase you deserve a pain in the a** in the name of internet privacy and security
    neofetch
    networkmanagerapplet # the wifi bars in polybar are thanks to this guy
    nerd-fonts.fira-code # favorite font that support ligatures
    nnn
    obsidian
    playerctl # used to bind media keys
    postman
    pywal # setting wallpaper and a matching color scheme
    signal-desktop-bin
    thunderbird
    vscodium
    xfce.thunar # file explorer
    xfce.tumbler # used for thumbnail images inside thunar, might need to change settings inside thunar itself

    #software for clients is below this line
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
