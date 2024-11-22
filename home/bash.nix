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
    '';
  };
}
