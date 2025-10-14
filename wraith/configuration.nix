{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/bluetooth.nix
    ../modules
    ../modules/display-managers/lightdm.nix
    ../modules/hyprland
  ];

  # services = {
  #   desktopManager.plasma6.enable = true;
  #   logind = {
  #     settings.Login.HandleLidSwitch = "ignore";
  #     settings.Login.HandleLidSwitchDocked = "ignore";
  #   };
  # };

  powerManagement.enable = true;
  services.logind.lidSwitch = "hibernate";
  # Hibernate on power button pressed
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";
  boot.resumeDevice = "";

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

  # no idea what this does
  security.rtkit.enable = true;
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

  # system specific packages I keep here, makes my home modules more portable
  environment.systemPackages = with pkgs; [
    dconf
    lshw
    lsof
    npth
    pavucontrol
    pulseaudio
    rustdesk
    wget
  ];

  services = {
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
    printing.enable = true;
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
