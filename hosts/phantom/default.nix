{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/gaming.nix
    ../../system/hermes.nix
    ../../system/sops.nix
    ../../system/direnv.nix
    ../../system/docker.nix
    ../../system/gnupg.nix
    ../../system/nix-settings.nix
    ../../system/power.nix
    ../../system/printing.nix
    ../../system/tmux.nix
  ];

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network
  networking.hostName = "phantom";
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User Account (Must stay here for PAM/shadow definitions)
  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "wheel" "hermes" ];
  };

  # System-level Hyprland wrapper (Required for PAM and systemd services)
  programs.hyprland.enable = true;

  # Home Manager Module Integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.sintra = import ../../users/sintra/home.nix;
  };



  # System Packages (Git/Helix moved to Home Manager)
  environment.systemPackages = with pkgs; [
    sops
    helix
    age
  ];

  # Hardware Acceleration for AMD GPU (Polaris RX 580)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "26.05";
}
