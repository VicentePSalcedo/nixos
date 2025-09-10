{ pkgs, ... }:
{
  imports = [
    ./hyprland
    ./auto-upgrade.nix
    ./direnv.nix
    ./display-managers/lightdm.nix
    ./nix-experimental.nix
  ];
  nixpkgs.config.allowUnfree = true;

  # This enables the password prompt for git commits that are signed with PGP
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # This facilitates the use of binaries by introducing a shim layer so they
  # can find the libraries they are looking for from FHS compliant system
  # programs.nix-ld = {
  #  enable = true;
  #  libraries = with pkgs; [
  #     glib
  #     glibc
  #   ];
  # };

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

  users.users.guest = {
    isNormalUser = true;
    description = "guest";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
  ];
  virtualisation = {
    docker.enable = true;
  };

  services.openssh.enable = true;
}
