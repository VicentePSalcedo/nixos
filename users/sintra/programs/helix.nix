{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # marksman: markdown LSP (wikilinks, backlinks, headings) - scoped to helix's PATH only
    extraPackages = [ pkgs.marksman ];
    settings = {
      theme = "tokyonight_storm_transparent";
      editor = {
        soft-wrap.enable = false;
        gutters = [ "diagnostics" "spacer" "diff" ];
        # load .helix/config.toml + .helix/languages.toml in repos without a trust prompt
        workspace-trust.trusted = [ "/home/sintra/Repos/*" ];
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
