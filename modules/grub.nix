{ lib, ... }:
{
  boot.loader = {
    grub = {
      enable = true;
      device = lib.mkDefault "nodev";
      default = "saved";
      splashImage = "/etc/nixos/wallpaper/1920x1080.png";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 50;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
}
