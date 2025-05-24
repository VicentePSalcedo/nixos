{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    # ../modules/i3
    ../modules/kde
    ../modules/hyprland
    # ../modules/gnome

    ../modules/autorandr.nix
    ../modules/auto-upgrade.nix
    ../modules/bluetooth.nix
    ../modules/direnv.nix
    ../modules/grub.nix
    ../modules/nix-experimental.nix
    # ../modules/nvidia.nix
    ../modules/us-locale.nix
    ../modules/wire-guard.nix

    ../modules/tmux.nix
    ../modules/steam.nix
  ];

  # Pretty sure this labels the encrypted disk. Don't f*** with this until you find out.
  boot.initrd.luks.devices."luks-321cf864-183e-4548-836b-9d8a6ad38559".device =
    "/dev/disk/by-uuid/321cf864-183e-4548-836b-9d8a6ad38559";

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

  nixpkgs.config.allowUnfree = true;

  # no idea what this does
  security.rtkit.enable = true;

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
    wget
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];

  # This enables the password prompt for git commits that are signed with PGP
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This facilitates the use of binaries by introducing a shim layer so they
  # can find the libraries they are looking for from FHS compliant system
  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [
  #     # glib
  #     # glibc
  #   ];
  # };

  services.printing.enable = true;

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
