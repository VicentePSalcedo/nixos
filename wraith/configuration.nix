{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules
    ../modules/wire-guard.nix
  ];

  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device =
    "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";
  networking.hostName = "wraith"; # Define your hostname.

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    bottom
    docker-compose
    pavucontrol
    pulseaudio
    unzip
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
