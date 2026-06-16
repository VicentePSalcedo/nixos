{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
  ];

  networking.hostName = "phantom";
}
