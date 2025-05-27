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
      hypr-wal() {
          wal -n -i "$@"
          hyprctl hyprpaper reload , "$@"
      }
      fastfetch
      eval -- "$(/etc/profiles/per-user/sintra/bin/starship init bash --print-full-init)"

    '';
  };
}
