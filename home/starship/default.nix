{ pkgs, ... }:
{
  home.packages = [
    pkgs.starship
  ];
  xdg.configFile."config.toml".source = ./config.toml;
}
