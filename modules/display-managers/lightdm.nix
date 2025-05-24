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
