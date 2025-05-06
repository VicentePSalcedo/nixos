{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../modules/autorandr
    ../modules/i3
    ../modules/bluetooth.nix
    ../modules/grub.nix
    ../modules/nix-experimental.nix
    # ../modules/nvidia.nix
    # ../modules/steam.nix
    ../modules/tmux.nix
    ../modules/us-locale.nix
    # ../modules/wire-guard.nix
  ];

  # Pretty sure this labels the encrypted disk. Don't f*** with this until you find out.
  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device =
    "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";

  networking.hostName = "wraith"; # Define your hostname.

  networking.networkmanager.enable = true;

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

  # Fine fine, I'll admit, nix isn't the best for everything. For the rest, docker is the move.
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    bottom
    curl
    dconf
    docker-compose
    lshw
    lsof
    npth
    pavucontrol
    pulseaudio
    unzip
    wget
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.printing.enable = true;

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
