{ config, pkgs, lib, ... }:

{
  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/home/sintra/.config/sops/age/keys.txt";
    secrets = {
      "hermes-env" = {
        format = "yaml";
      };
      "artoriastechlab-email-password" = {
        owner = config.users.users.sintra.name;
        format = "yaml";
      };
      "personal-email-password" = {
        owner = config.users.users.sintra.name;
        format = "yaml";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
