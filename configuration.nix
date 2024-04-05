{ config, pkgs, inputs, callPackages, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./i3
      ./home
      ./hardware-configuration.nix
      ./modules/nvidia.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-0a9a3d2f-b3e9-4eda-b18f-68a5e806d347".device = "/dev/disk/by-uuid/0a9a3d2f-b3e9-4eda-b18f-68a5e806d347";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    videoDrivers = ["nvidia"];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [];
  };
  services.getty.autologinUser = "sintra";

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ## The Section I edit the most
  ################################################################################################################
  environment.systemPackages = with pkgs; [ 
    git 
    wget 
    curl 
    libgcc
    lshw 
    lsof
    pulseaudio
    neovim
    pavucontrol
  ];

  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  security.polkit.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["sintra"];
      substituters = [
        "https//cache.nixos.org"
      ];
    };
  };
  # run scripts on shell login
  environment.loginShellInit = ''
  '';

  environment.variables.EDITOR = "neovim";

  hardware = {
    pulseaudio = {
      enable = true; 
      support32Bit = true;
    };
  };
  sound.enable = true;
  ###############################################################################################################

  # services to enable
  services.openssh.enable = true;
  services.dbus.enable = true;
  
  system.stateVersion = "23.11"; 
}
