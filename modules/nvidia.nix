{ config, ... }:
{
  hardware = {
    # enable if you need xboxcontroller to work
    # xpadneo.enable = true;
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };
}
