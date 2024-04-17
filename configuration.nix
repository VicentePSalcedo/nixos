{ config, pkgs, inputs, callPackages, ... }:
{
  imports = [
      ./i3
      ./hardware-configuration.nix
      ./modules
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
  networking.hostName = "wraith"; # Define your hostname.
  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    dconf
    git
    npth
    htop
    lshw
    lsof
    pavucontrol
    vim
    unzip
    wget
  ];
  environment.variables.EDITOR = "vim";
  programs.gnupg.agent = {
    enable = true;
  };
# IMPORTANT FOR OBSIDIAN (my preferred not Markdown viewer unfortunately)
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" "libgcrypt-1.8.10" ];
  security.polkit.enable = true;
# hardware settings for wraith
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  hardware = {
    pulseaudio = {
      enable = true; 
      support32Bit = true;
    };
  };
  sound.enable = true;
  # services to enable
  services.openssh.enable = true;
  services.dbus.enable = true;
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    videoDrivers = ["nvidia"];
  };
###############################################################################################################
# good defaults if you live on the east coast
  networking.networkmanager.enable = true;
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
