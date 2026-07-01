{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
    ../../system/nvidia.nix
  ];

  networking.hostName = "phantom";
}
