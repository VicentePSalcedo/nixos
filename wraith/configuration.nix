{
  imports = [ ./hardware-configuration.nix ../modules ];

  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device =
    "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";
  networking.hostName = "wraith"; # Define your hostname.

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
