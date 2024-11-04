{ config, pkgs, lib, inputs, callPackages, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./i3
    ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["sintra"];
      substituters = [ "https//cache.nixos.org" ];
    };
  };

  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "docker" "wheel" "audio" "libvirtd" ];
  };

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
  networking.networkmanager.enable = true;

  services.openssh.enable = true;
  services.printing.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = ["nvidia"];
  };

  programs.gnupg.agent = {
    enable = true;
  };

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    dconf
    git
    htop
    lshw
    lsof
    npth
    pavucontrol
    vim
    unzip
    wget
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

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { 
    LC_ADDRESS = "en_US.UTF-8"; 
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.stateVersion = "23.11";

}
