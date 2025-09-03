{
  services = {
    displayManager = {
      defaultSession = "hyprland";
      autoLogin = {
        enable = true;
        user = "sintra";
      };
    };
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = ../../wallpaper/waifu.jpg;
          greeters.slick = {
            enable = true;
            font.name = "FiraCodeNerdFont";
          };
        };
      };
    };
  };
}
