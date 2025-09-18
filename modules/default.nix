{ pkgs, ... }:
{
  imports = [
    ./auto-upgrade.nix
    ./direnv.nix
    ./nix-experimental.nix
    ./tmux.nix
  ];
  nixpkgs.config.allowUnfree = true;

  # This enables the password prompt for git commits that are signed with PGP
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

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

  environment.systemPackages = with pkgs; [
    bat # better cat
    curl
    docker-compose
    du-dust
    git
    htop
    just
    yazi
    zoxide
  ];

  virtualisation = {
    docker.enable = true;
  };

  services.openssh.enable = true;
}
