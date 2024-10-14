{ config, pkgs, lib, inputs, callPackages, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../base.nix
      ./minecraft.nix
      ./i3
    ];

  # Bootloader.
#  boot.loader.systemd-boot.enable = true;
#  boot.loader.efi.canTouchEfiVariables = true;
  virtualisation.docker.enable = true;
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
  networking.hostName = "ghost"; # Define your hostname.

  services.printing.enable = true;
  services.xserver.enable = true;
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = ["nvidia"];
  };

  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs; [
  ];

  security.rtkit.enable = true;
  security.polkit.enable = true;

  hardware = {
    # enable if you need xboxcontroller to work
    # xpadneo.enable = true;
    graphics = {
        enable = true;
        # dont need this line if you dont want steam
        enable32Bit = true;
    };
    nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  system.stateVersion = "23.11";

}
