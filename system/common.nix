{ config, pkgs, inputs, ... }:

{
  imports = [
    ./gaming.nix
    ./hermes.nix
    ./sops.nix
    ./direnv.nix
    ./docker.nix
    ./gnupg.nix
    ./nix-settings.nix
    ./security.nix
    ./ssh.nix
    ./tailscale.nix
    ./syncthing.nix
  ];

  # Bootloader configurations
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 6;
  boot.loader.timeout = 7;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network
  networking.networkmanager.enable = true;

  # Time & Locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Hyprland Desktop Environment
  programs.hyprland.enable = true;

  # Home Manager setup
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.sintra = import ../users/sintra/home.nix;
  };

  # System Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" ];
        sansSerif = [ "FiraCode Nerd Font" ];
        serif = [ "FiraCode Nerd Font" ];
      };
    };
  };

  # User Configuration
  users.users."sintra" = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "wheel" "hermes" ];
  };

  # Auto-upgrade system packages via pure Nix
  system.autoUpgrade = {
    enable = true;
    flake = "/home/sintra/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  system.stateVersion = "26.05";
}
