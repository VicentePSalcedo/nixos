{ config, pkgs, lib, inputs, callPackages, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/cachix.nix
      ../modules/hyprland
      #../modules/i3
      ../modules/nix-experimental.nix
      ../modules/nvidia.nix
      ../modules/tmux
    ];

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
  };

  programs.gnupg.agent = {
    enable = true;
  };

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
