{ config, ... }:
{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/EFI";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
    };
  };
}
