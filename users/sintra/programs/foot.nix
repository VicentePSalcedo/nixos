{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = false; # We run the server directly inside Hyprland autostart (Pattern A)
    settings = {
      main = {
        term = "foot";
        font = "JetBrainsMono Nerd Font:size=11";
        shell = "${pkgs.nushell}/bin/nu";
      };
      scrollback = {
        lines = 10000;
      };
      "colors-dark" = {
        alpha = 0.10;
        background = "1a1b26"; # TokyoNight Storm background (dark blueish gray)
        foreground = "c0caf5"; # TokyoNight Storm foreground

        ## TokyoNight Storm Palette for Foot
        regular0 = "1d202f"; # black
        regular1 = "f7768e"; # red
        regular2 = "9ece6a"; # green
        regular3 = "e0af68"; # yellow
        regular4 = "7aa2f7"; # blue
        regular5 = "bb9af7"; # magenta
        regular6 = "7dcfff"; # cyan
        regular7 = "a9b1d6"; # white

        bright0 = "414868"; # bright black
        bright1 = "f7768e"; # bright red
        bright2 = "9ece6a"; # bright green
        bright3 = "e0af68"; # bright yellow
        bright4 = "7aa2f7"; # bright blue
        bright5 = "bb9af7"; # bright magenta
        bright6 = "7dcfff"; # bright cyan
        bright7 = "c0caf5"; # bright white
      };
    };
  };
}
