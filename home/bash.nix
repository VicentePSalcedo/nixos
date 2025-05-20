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
      eval -- "$(/etc/profiles/per-user/sintra/bin/starship init bash --print-full-init)"
      unset CLOUDSDK_CONFIG_ROOT
      unset GOOGLE_APPLICATION_CREDENTIALS
    '';
  };
}
