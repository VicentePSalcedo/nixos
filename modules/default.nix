{ config, pkgs, inputs, callPackages, ... }:
{
  imports =
    [
      ./grub.nix
      ./nvidia.nix
    ];
}
