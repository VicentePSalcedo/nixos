{ pkgs, lib, ...}:
{
  service.minecraft = {
    enable = true;
    eula = true;
    declarative = true;

    package = pkgs.minecraftServers.vanilla-1-20;

    serverProperties = {
      gamemode = "survival";
      difficulty = "hard";
    };

    whitelist = {
      
    };

    jvmOpts = "-Xms2048M -Xmx4092M -XX:+UseG1GC";
  }
}
