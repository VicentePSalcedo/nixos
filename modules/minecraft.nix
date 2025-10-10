{
  pkgs,
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
        package = pkgs.fabricServers.fabric-1_20_1;
        # package = pkgs.minecraftServers.vanilla-1_20_1;
        serverProperties = {
          gamemode = "survival";
          difficulty = "hard";
        };

        symlinks = {
          "config" = /home/sintra/BMC4/config;
          "modernfix" = /home/sintra/BMC4/modernfix;
          "mods" = /home/sintra/BMC4/mods;
          "server.properties" = /home/sintra/BMC4/server.properties;
          "start.sh" = /home/sintra/BMC4/start.sh;
          "variables.txt" = /home/sintra/BMC4/variables.txt;
        };

        jvmOpts = "-Xms2048M -Xmx5120M -XX:+UseG1GC";
        enableReload = true;
      };
    };

  };
}
