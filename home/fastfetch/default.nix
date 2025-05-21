{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
  ];
  xdg.configFile."config.jsonc" = {
    source = ./config.jsonc;
    target = "fastfetch/config.jsonc";
  };
}
