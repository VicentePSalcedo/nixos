{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network
  networking.hostName = "nixos";
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
    extraGroups = [ "networkmanager" "wheel" "hermes"];
  };

  # System-level Hyprland wrapper (Required for PAM and systemd services)
  programs.hyprland.enable = true;

  # Home Manager Module Integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.sintra = import ./users/sintra/home.nix;
  };

  # Nix Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # System Packages (Git/Helix moved to Home Manager)
  environment.systemPackages = with pkgs; [
    sops
    helix
    age
  ];

  # System Services & Integrations
  services.hermes-agent = {
    enable = true;
    settings.model.default = "gemini-flash-latest";
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/sintra/.config/sops/age/keys.txt";
    secrets."hermes-env" = { format = "yaml"; };
  };

  system.stateVersion = "26.05";
}
