{ pkgs, ... }:
{
  services = {
    # displayManager = {
    #   defaultSession = "none+i3";
    #   autoLogin = {
    #     enable = true;
    #     user = "sintra";
    #   };
    # };
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      desktopManager = {
        xterm.enable = false;
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = ../../wallpaper/1920x1080.png;
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
        extraPackages = with pkgs; [
          rofi
        ];
      };
    };
  };
}
