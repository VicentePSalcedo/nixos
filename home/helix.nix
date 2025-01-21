{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    themes = {
      tokyonight = {
        "ui.background" = { };
      };
    };
    languages = {
      language-server.nixd = {
        command = "nixd";
      };
      language = [{
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }];
    };
  };
}
