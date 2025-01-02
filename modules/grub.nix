{
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      default = "saved";
      splashImage = "/etc/nixos/wallpaper/kafka.png";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 50;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
}
