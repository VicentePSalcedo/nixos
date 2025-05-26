{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules
    ../modules/autorandr.nix
    ../modules/bluetooth.nix
    ../modules/grub.nix
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

  # no idea what this does
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
    rustdesk
    ventoy-full
    wget
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];

  services = {
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
    printing.enable = true;
    openssh.enable = true;
  };

  system.stateVersion = "24.05";
}
