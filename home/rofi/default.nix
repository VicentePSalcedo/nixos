{ pkgs, config, inputs, ...}:
{
  home.file.".config/rofi/config.rasi" = {
      text = ''@import "~/.cache/wal/colors-rofi-dark"'';
  };
}
