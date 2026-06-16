{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "sintra";
    dataDir = "/home/sintra";
    configDir = "/home/sintra/.config/syncthing";
    openDefaultPorts = true;
  };
}
