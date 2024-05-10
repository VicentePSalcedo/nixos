
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./base.nix
    ./gtk
    ./picom
    ./polybar
  ];
  home.packages = with pkgs; [
    firefox
    discord
    bottom #btm to view resource usage
    gnucash
    rustup #favorite programing language
    signal-desktop
  ];
}
