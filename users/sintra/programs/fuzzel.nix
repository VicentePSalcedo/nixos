{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=14";
        dpi-aware = "no";
        prompt = "❯  ";
        icon-theme = "TokyoNight-Storm";
        fields = "filename,name,generic";
        lines = 10;
        width = 50;
        tabs = 4;
        horizontal-pad = 12;
        vertical-pad = 8;
        inner-pad = 8;
        image-size-ratio = 0.5;
      };

      colors = {
        background = "1a1b26ff";
        text = "c0caf5ff";
        match = "f7768eff";
        selection = "7aa2f7ff";
        selection-text = "1a1b26ff";
        selection-match = "f7768eff";
        border = "7aa2f7ff";
      };

      border = {
        width = 2;
        radius = 10;
      };
    };
  };
}
