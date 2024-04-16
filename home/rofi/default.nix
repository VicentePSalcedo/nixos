{ pkgs, config, inputs, ...}:
{
  home.packages = with pkgs; [
    rofi #application menu for i3
  ];
  home.file.".config/rofi/config.rasi" = {
      text = ''@import "~/.cache/wal/colors-rofi-dark"'';
  };
}
