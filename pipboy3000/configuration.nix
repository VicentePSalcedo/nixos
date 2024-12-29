{
  imports =
    [
      ./hardware-configuration.nix

      ../modules/i3
      ../modules/tmux

      ../modules/bluetooth.nix
      ../modules/cachix.nix
      ../modules/nix-experimental.nix
      ../modules/sintra.nix
      ../modules/us-locale.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device = "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";
  networking.hostName = "pipboy3000"; # Define your hostname.

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
