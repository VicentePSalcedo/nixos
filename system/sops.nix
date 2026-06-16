{ config, pkgs, lib, ... }:

{
  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/home/sintra/.config/sops/age/keys.txt";
    secrets."hermes-env" = { format = "yaml"; };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
