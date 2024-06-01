{ config, pkgs, inputs, callPackages, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../base.nix
      ../i3
    ];

  # Bootloader.
#  boot.loader.systemd-boot.enable = true;
#  boot.loader.efi.canTouchEfiVariables = true;
  virtualisation.docker.enable = true;
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
  networking.hostName = "ghost"; # Define your hostname.
  services.xserver.enable = true;
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = ["nvidia"];
  };
  environment.systemPackages = with pkgs; [
    gparted
  ];
  services.printing.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
 nixpkgs.config.allowBroken = true;
  sound.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  hardware = {
    xpadneo.enable = true;
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
  # Enable automatic login for the user.
  system.stateVersion = "23.11";
}
