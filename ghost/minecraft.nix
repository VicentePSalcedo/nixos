{ pkgs, lib, …}: {
    services.minecraft = {
        enable = true;
        eula = true;
#       declarative = true;

        package = pkgs.minecraft-server;
        dataDir = "home/sintra/minecraftServer";

#        serverProperties = {
#            serve-port = 1984;
#            gamemode = “survival”;
#             difficulty = “hard”;
#             simulation-distance = 10;
#             level-seed = “4”;
#        };

#        whitelist = {
#            vimjoyer = “3f96da12-a55c-4871-8e26-09256adac319”;
#        };

#        jvmOpts = “-Xms4092M -Xmx4092M -XX:+UseG1GC”;
    };
}
