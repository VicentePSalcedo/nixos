{ config, pkgs, inputs, ... }:

{
  imports = [
<<<<<<< Updated upstream
=======
    ./gaming.nix
    ./hermes.nix
    ./sops.nix
    ./docker.nix
    ./gnupg.nix
    ./nix-settings.nix
    ./security.nix
    ./ssh.nix
    ./tailscale.nix
    ./syncthing.nix
>>>>>>> Stashed changes
    ./audio.nix
    ./gaming.nix
    ./gnupg.nix
    ./hermes.nix
    ./nix-settings.nix
    ./podman.nix
    ./security.nix
    ./sops.nix
    ./ssh.nix
    ./syncthing.nix
    ./tailscale.nix
    ./cache-sharing.nix
  ];

  
  # Ensure just is installed system-wide on all hosts now and in the future
  environment.systemPackages = [ ];


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
    extraGroups = [ "networkmanager" "wheel" "hermes" "podman" ];
    openssh.authorizedKeys.keys = [
      # wraith
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUtdv2cd/gJrcXgKcuaHOXPdosc0HQE6A5Air0tY4zZ vicentepsalcedo@gmail.com"
      # phantom
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7zd7U9mqaWhJYshlIPkIaK5VrLTYepKglMaIHDoeHf vicentesalcedo@artoriastechlab.com"
    ];
  };

  # Auto-upgrade system packages via pure Nix
  system.autoUpgrade = {
    enable = true;
    flake = "/home/sintra/nixos";
    upgrade = true;
    flags = [
      "--commit-lock-file"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  system.stateVersion = "26.05";
}
