{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./base.nix
  ];
  home.packages = with pkgs; [
    google-chrome
    slack
  ];
}
