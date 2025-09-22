{
  config,
  pkgs,
  lib,
  ...
}:

let
  hostname = "pi";
in
{

  imports = [
    <nixos-hardware/raspberry-pi/4>
    ../modules
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = hostname;
    # networkmanager.enable = true;
    interfaces.end0.useDHCP = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    git
    helix
    htop
    just
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    }
  };

  users = {
    mutableUsers = false;
    users."sintra" = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$LtzKxSxbUZwijY/ngdSua.$9ZHYWgVeaD8H0S0znvMihu/I/TIJyYH7pQRWUTJhPk8";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxpYE8hou9ToMCoTcGB8RozRHJ8qctcVq83P9/YOUax vicentepsalcedo@gmail.com"
      ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
