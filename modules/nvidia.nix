{ config, pkgs, lib, inputs, callPackages, ... }:
{
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
  services.xserver = {
      videoDrivers = ["nvidia"];
  };
}
