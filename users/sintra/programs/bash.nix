{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    profileExtra = ''
      # If logging in on tty1 and not already in a graphical session, autostart Hyprland
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}
