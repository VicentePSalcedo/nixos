{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      lightdm = {
        enable = true;
        autoLogin.timeout = 3;
        background = ./wallpaper.jpg;
        greeters.slick = {
          enable = true;
          font.name = "FiraCodeNerdFont";
        };
      };
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      configFile = ./config;
    };
  };
}
