{
  services = {
    displayManager = {
      defaultSession = "hyprland";
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
