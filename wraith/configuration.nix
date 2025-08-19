{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules
  ];

  services = {
    desktopManager.plasma6.enable = true;
    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
    };
  };
  # Pretty sure this labels the encrypted disk. Don't f*** with this until you find out.
  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device =
    "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";
  boot.loader = {
    grub = {
      enable = true;
      device = lib.mkDefault "nodev";
      default = "saved";
      splashImage = "/etc/nixos/wallpaper/1920x1080.png";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 50;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

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

  # system specific packages I keep here, makes my home modules more portable
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

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
