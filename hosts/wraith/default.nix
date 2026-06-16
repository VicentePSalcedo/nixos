{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/gaming.nix
      ../../system/hermes.nix
      ../../system/sops.nix
      ../../system/direnv.nix
      ../../system/docker.nix
      ../../system/gnupg.nix
      ../../system/nix-settings.nix
      ../../system/tmux.nix
      ../../system/ssh.nix
      ../../system/tailscale.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 6;
  boot.loader.timeout = 7;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "wraith";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.hyprland.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.sintra = import ../../users/sintra/home.nix;
  };

  users.users."sintra" = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
