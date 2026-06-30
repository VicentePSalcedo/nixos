{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        dpi-aware = "no";
        prompt = "❯  ";
        icon-theme = "TokyoNight-Storm";
        fields = "filename,name,generic";
        lines = 10;
        width = 40;
        tabs = 4;
        horizontal-pad = 12;
        vertical-pad = 8;
        inner-pad = 8;
        image-size-ratio = 0.5;
      };

      colors = {
        background = "1a1b26e6";
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

  # Hide common CLI apps from launcher (since desktop environments respect NoDisplay=true)
  xdg.desktopEntries = {
    "com.mitchellh.ghostty" = {
      name = "Ghostty";
      noDisplay = true;
    };
    Helix = {
      name = "Helix";
      noDisplay = true;
    };
    "nixos-manual" = {
      name = "NixOS Manual";
      noDisplay = true;
    };
    neovim = {
      name = "Neovim";
      noDisplay = true;
    };
    btop = {
      name = "Btop";
      noDisplay = true;
    };
    htop = {
      name = "Htop";
      noDisplay = true;
    };
    yazi = {
      name = "Yazi";
      noDisplay = true;
    };
    ranger = {
      name = "Ranger";
      noDisplay = true;
    };
  };
}
