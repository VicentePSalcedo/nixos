{
  imports = [
    ./display-managers/lightdm.nix
    ./hyprland
    ./auto-upgrade.nix
    ./direnv.nix
    ./grub.nix
    ./nix-experimental.nix
    ./steam.nix
    ./us-locale.nix
  ];
  nixpkgs.config.allowUnfree = true;
}
