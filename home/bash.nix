{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
    };
    bashrcExtra = ''
      eval "$(direnv hook bash)"
      (cat ~/.cache/wal/sequences &)
      export GPG_TTY=$(tty)
      wal-hypr() {
          wal -n -i "$@"
          hyprctl hyprpaper preload "$@"
          hyprctl hyprpaper wallpaper eDP-1, "$@"
      }
      fastfetch
    '';
  };
}
