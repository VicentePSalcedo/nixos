{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # LSPs scoped to helix's PATH only (bundled languages.toml wires them per-language)
    # marksman: markdown LSP (wikilinks, backlinks, headings)
    # nil: nix LSP - identifiers, builtins, flake schema, NixOS options (from flake's nixpkgs input)
    # nixd: nix LSP - nixpkgs package-name completion via <nixpkgs> (resolves via nix.nixPath in system/nix-settings.nix)
    extraPackages = [ pkgs.marksman pkgs.nil pkgs.nixd ];
    settings = {
      theme = "tokyonight_storm_transparent";
      editor = {
        soft-wrap.enable = true;
        gutters = [ "diagnostics" "spacer" "diff" ];
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
