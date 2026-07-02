# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../system/common.nix
    ];

  boot.loader.systemd-boot.enable = lib.mkForce false; 
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false; 
  boot.loader.grub = {
    enable = lib.mkForce true;
    device = "/dev/sda";
    configurationLimit = 6;
  };

  networking.hostName = "spectre"; # Define your hostname.

  system.stateVersion = "26.05"; # Did you read the comment?

}

