{ pkgs, ... }:
{
  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin = {
      enable = true;
      user = "sintra";
    };
  };
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
