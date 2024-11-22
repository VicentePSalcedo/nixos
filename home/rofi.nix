{ pkgs, ...}:
{
  home.packages = with pkgs; [
    rofi-wayland #application menu for i3
  ];
  home.file.".config/rofi/config.rasi" = {
      text = ''@import "~/.cache/wal/colors-rofi-dark"'';
  };
}
