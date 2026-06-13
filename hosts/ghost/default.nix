{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/gaming.nix
    ../../system/hermes.nix
    ../../system/sops.nix
    ../../system/bluetooth.nix
    ../../system/direnv.nix
    ../../system/docker.nix
    ../../system/gnupg.nix
    ../../system/nix-settings.nix
    ../../system/power.nix
    ../../system/printing.nix
    ../../system/tmux.nix
    ../../system/nvidia.nix
  ];

  services.getty.autologinUser = "sintra";

  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "wheel" "hermes" ];
  };

  environment.systemPackages = with pkgs; [
    gparted
    jdk
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "ghost";
  networking.networkmanager.enable = true;

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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  system.stateVersion = "25.05";
}
