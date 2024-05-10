{ config, pkgs, inputs, callPackages, ... }:
{
  imports = [
      ../i3
      ./hardware-configuration.nix
      ../base.nix
    ];
  services.xserver = {
    windowManager.i3 = {
      configFile = ./config;
    };
  };
  networking.hostName = "wraith";
  security.polkit.enable = true;
  hardware = {
    pulseaudio = {
      enable = true; 
      support32Bit = true;
    };
    opengl = {
        enable = true;
        driSupport = true;
        # dont need this line if you dont want steam
        driSupport32Bit = true;
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
  sound.enable = true;
  services.dbus.enable = true;
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = ["nvidia"];
  };
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 50;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
  boot.initrd.luks.devices."luks-0a9a3d2f-b3e9-4eda-b18f-68a5e806d347".device = "/dev/disk/by-uuid/0a9a3d2f-b3e9-4eda-b18f-68a5e806d347";
}
