{ config, ... }:

{
  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/home/sintra/.config/sops/age/keys.txt";
    secrets."hermes-env" = { format = "yaml"; };
  };
}
