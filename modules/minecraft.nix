{ pkgs, lib, inputs, ... }: {
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
  };
}
