{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/nvidia.nix
    ../modules
    ../modules/steam.nix
    ../modules/display-managers/lightdm.nix
    ../modules/hyprland
    # ../modules/minecraft.nix
  ];

  services.getty.autologinUser = "sintra";

  nixpkgs.config.allowUnfree = true;

  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "audio"
    ];
  };

  nix.settings.trusted-users = [
    "root"
    "sintra"
  ];

  environment.systemPackages = with pkgs; [
    gparted
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "ghost"; # Define your hostname.

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

  system.stateVersion = "25.05"; # Did you read the comment?
}
