{
  imports = [
    ./display-managers/lightdm.nix
    ./hyprland
    ./auto-upgrade.nix
    ./direnv.nix
    ./nix-experimental.nix
    ./steam.nix
    ./us-locale.nix
  ];
  nixpkgs.config.allowUnfree = true;
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
}
