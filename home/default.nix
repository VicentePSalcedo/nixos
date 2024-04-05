{ config, pkgs, inputs, callPackages, ... }:
{
  imports = [
    ./alacritty.nix 
    ./bash.nix 
    ./git.nix
    ./nvim.nix
  ];
}
