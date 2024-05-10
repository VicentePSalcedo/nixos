{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./base.nix
    ./gtk
    ./polybar
  ];
  home.packages = with pkgs; [
    google-chrome
    slack
  ];
}
