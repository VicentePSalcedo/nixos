{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/autostart.conf".source = ./autostart.conf;
  xdg.configFile."hypr/rules.conf".source = ./rules.conf;
  xdg.configFile."hypr/keybinds.conf".source = ./keybinds.conf;
  xdg.configFile."hypr/toggle-wallpaper.sh".source = ./toggle-wallpaper.sh;
}
