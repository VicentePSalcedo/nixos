{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
    };
    bashrcExtra = ''
      (cat ~/.cache/wal/sequences &)
      export GPG_TTY=$(tty)
    '';
  };
}
