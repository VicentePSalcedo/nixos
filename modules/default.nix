{ pkgs, ... }:
{
  imports = [
    ./autorandr
    ./i3

    ./tmux.nix
    ./bluetooth.nix
    ./grub.nix
    # ./nvidia.nix # only enable this if you have an nvidia gpu
    ./nix-experimental.nix
    ./steam.nix
    ./us-locale.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

}
