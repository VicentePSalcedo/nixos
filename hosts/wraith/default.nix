{ config, pkgs, inputs, lib, ... }:

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
  ];

  # Bootloader (Grub specific to wraith)
  boot.loader = {
    grub = {
      enable = true;
      device = lib.mkDefault "nodev";
      default = "saved";
      splashImage = "/etc/nixos/wallpapers/1920x1080.png";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 50;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

  # Encrypted Drive (LUKS specific to wraith)
  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device =
    "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";

  # Network
  networking.hostName = "wraith";
  networking.networkmanager.enable = true;

  # Localization
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

  # Extra System Packages for Wraith
  environment.systemPackages = with pkgs; [
    sops
    helix
    age
    lshw
    lsof
    npth
    pavucontrol
    pulseaudio
    rustdesk
    wget
  ];

  system.stateVersion = "24.05";
}
