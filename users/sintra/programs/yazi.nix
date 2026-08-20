{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      opener = {
        edit = [
          { run = "hx %s"; block = true; desc = "Helix"; }
        ];
        pdf = [
          { run = "zen %s"; block = false; desc = "Zen Browser"; }
        ];
        vlc = [
          { run = "vlc %s"; orphan = true; desc = "VLC"; }
        ];
        audio = [
          { run = "rhythmbox %s"; orphan = true; desc = "Rhythmbox"; }
        ];
      };
      open = {
        prepend_rules = [
          { mime = "application/pdf"; use = "pdf"; }
          { mime = "video/*"; use = "vlc"; }
          { mime = "audio/*"; use = "audio"; }
        ];
      };
      plugin = {
        prepend_fetchers = [
          { url = "*";  run = "git"; group = "git"; }
          { url = "*/"; run = "git"; group = "git"; }
        ];
      };
    };

    plugins.git = {
      package = pkgs.yaziPlugins.git;
      setup = true;
    };
  };
}
