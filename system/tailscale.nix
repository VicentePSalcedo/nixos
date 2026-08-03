{ config, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
  networking.firewall.checkReversePath = "loose";
}

