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
        package = pkgs.minecraftServers.vanilla-1_20;

        serverProperties = {
          gamemode = "survival";
          difficulty = "hard";
        };

        whitelist = { };

        symlinks = {
          "mods" = /home/sintra/BMC4/mods;
        };

        jvmOpts = "-Xms2048M -Xmx4092M -XX:+UseG1GC";
      };
    };

  };
}
