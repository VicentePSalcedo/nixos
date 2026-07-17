{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "tokyonight_storm_transparent";
      editor = {
        soft-wrap.enable = true;
      };
    };
  };

  xdg.configFile."helix/themes/tokyonight_storm_transparent.toml".text = ''
    inherits = "tokyonight_storm"

    "ui.background" = {}
  '';

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    NPM_CONFIG_CACHE = "${config.home.homeDirectory}/.cache/npm";
  };
}
