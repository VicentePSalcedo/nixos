
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./base.nix
    ./picom
  ];
  home.packages = with pkgs; [
    firefox
  ];
}
