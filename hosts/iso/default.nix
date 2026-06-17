{ pkgs, modulesPath, lib, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Use NetworkManager instead of wpa_supplicant for easier CLI WiFi management
  networking.wireless.enable = lib.mkForce false;
  networking.networkmanager.enable = true;

  # Set hostname
  networking.hostName = "nixos-installer";

  # SSH configuration
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true; # Allow password auth as a fallback
    settings.PermitRootLogin = "yes";
  };

  # SSH Keys for the 'nixos' installer user
  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUtdv2cd/gJrcXgKcuaHOXPdosc0HQE6A5Air0tY4zZ vicentepsalcedo@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7zd7U9mqaWhJYshlIPkIaK5VrLTYepKglMaIHDoeHf vicentesalcedo@artoriastechlab.com"
  ];

  # SSH Keys for root just in case
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUtdv2cd/gJrcXgKcuaHOXPdosc0HQE6A5Air0tY4zZ vicentepsalcedo@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7zd7U9mqaWhJYshlIPkIaK5VrLTYepKglMaIHDoeHf vicentesalcedo@artoriastechlab.com"
  ];

  # Additional packages to make installation and troubleshooting a breeze
  environment.systemPackages = with pkgs; [
    git
    neovim
    just
    age
    sops
    parted
    gptfdisk
    curl
    rsync
  ];

  # Make sure we use the latest kernel for modern hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
