{ pkgs, ... }:
{
  imports = [
    ./display-managers/lightdm.nix

    # ./gnome
    ./hyprland
    # ./i3
    # kde

    ./auto-upgrade.nix
    ./bluetooth.nix
    ./direnv.nix
    ./nix-experimental.nix
    # ./nvidia.nix
    ./steam.nix
    ./tmux.nix
    ./us-locale.nix
    #./wire-guard.nix
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
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   # glib
    #   # glibc
    # ];
  };
}
