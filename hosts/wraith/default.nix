{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/common.nix
    ];

  networking.hostName = "wraith";

  # Laptop specific configurations
  hardware.bluetooth.enable = true; # often useful for laptops

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
