{
  services = {
    displayManager = {
      defaultSession = "hyprland";
      autoLogin = {
        user = "sintra";
        enable = true;
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
          background = ../../wallpaper/1920x1080.png;
          greeters.slick = {
            enable = true;
            font.name = "FiraCodeNerdFont";
          };
        };
      };
    };
  };
}
