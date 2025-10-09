{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      zey-server = {
        enable = true;
        package = pkgs.minecraftServers.vanilla-1_20_1;

        serverProperties = {
          gamemode = "survival";
          difficulty = "hard";
        };

        whitelist = { };

        symlinks = {
          "config" = /home/sintra/BMC4/config;
          "mods" = /home/sintra/BMC4/mods;
          "modernfix" = /home/sintra/BMC4/modernfix;
          "server.properties" = /home/sintra/BMC4/server.properties;
          "start.sh" = /home/sintra/BMC4/start.sh;
        };

        jvmOpts = "-Xms2048M -Xmx4092M -XX:+UseG1GC";
      };
    };

  };
}
