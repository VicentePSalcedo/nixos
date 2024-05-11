{ config, pkgs, inputs, callPackages, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../i3
      ../base.nix
    ];
  networking.hostName = "miata"; # Define your hostname.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  system.stateVersion = "23.11";
}
