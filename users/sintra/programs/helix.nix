{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "tokyonight_storm";
      editor = {
        soft-wrap.enable = true;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    NPM_CONFIG_CACHE = "${config.home.homeDirectory}/.cache/npm";
  };
}
