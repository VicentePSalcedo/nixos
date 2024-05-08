{ config, pkgs, inputs, callPackages, ... }:
{
  imports = [
      ../i3
      ./hardware-configuration.nix
    ];
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["sintra"];
      substituters = [ "https//cache.nixos.org" ];
    };
  };
## The Section I edit the most
################################################################################################################
  networking.hostName = "wraith";
  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    dconf
    firefox
    git
    htop
    lshw
    lsof
    npth
    pavucontrol
    vim
    unzip
    wget
  ];
  programs.gnupg.agent = {
    enable = true;
  };
# IMPORTANT FOR OBSIDIAN
  security.polkit.enable = true;
  hardware = {
    pulseaudio = {
      enable = true; 
      support32Bit = true;
    };
    opengl = {
        enable = true;
        driSupport = true;
        # dont need this line if you dont want steam
        driSupport32Bit = true;
    };
    nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
  sound.enable = true;
  services.openssh.enable = true;
  services.dbus.enable = true;
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = ["nvidia"];
  };
###############################################################################################################
  networking.networkmanager.enable = true;
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 50;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
  boot.initrd.luks.devices."luks-0a9a3d2f-b3e9-4eda-b18f-68a5e806d347".device = "/dev/disk/by-uuid/0a9a3d2f-b3e9-4eda-b18f-68a5e806d347";
  time.timeZone = "America/New_York";
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
# You dont need to touch this, it's just the starting
# version of the system when the config was made.
  system.stateVersion = "23.11"; 
}
