{ config, pkgs, inputs, callPackages, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../i3
      ../base.nix
    ];
  networking.hostName = "miata"; # Define your hostname.
  environment.systemPackages = with pkgs; [
    google-chrome #I wanna get rid of this but I need it for work
  ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
