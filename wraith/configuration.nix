{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../modules/autorandr
    ../modules/i3

    # ../modules/auto-upgrade.nix
    ../modules/bluetooth.nix
    ../modules/direnv.nix
    ../modules/grub.nix
    ../modules/hyprland.nix
    ../modules/nix-experimental.nix
    # ../modules/nvidia.nix
    ../modules/steam.nix
    ../modules/tmux.nix
    ../modules/us-locale.nix
    ../modules/wire-guard.nix
  ];

  # Pretty sure this labels the encrypted disk. Don't f*** with this until you find out.
  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device =
    "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";

  networking.hostName = "wraith";

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

  virtualisation = {
    docker.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    curl
    dconf
    docker-compose
    htop
    lshw
    lsof
    npth
    pavucontrol
    pulseaudio
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
