{
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      default = "saved";
      splashImage = "/etc/nixos/wallpaper/wp7513283-autumn-anime-scenery-wallpapers.png";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 50;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
}
