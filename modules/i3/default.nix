{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      lightdm = {
        enable = true;
        autoLogin.timeout = 0;
        background = ../../wallpaper/power.jpg;
        greeters.slick = {
          enable = true;
          font.name = "FiraCodeNerdFont";
        };
      };
    };
    windowManager.i3 = {
      configFile = ./config;
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
