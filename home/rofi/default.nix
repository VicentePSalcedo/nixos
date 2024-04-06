{ pkgs, config, inputs, ...}:
{
  programs.rofi = {
    enable = true;
    font = "FiraCodeNerdFont";
  };
  home.file.".config/rofi/config.rasi" = {
      source = ./config.rasi;
  };
}
