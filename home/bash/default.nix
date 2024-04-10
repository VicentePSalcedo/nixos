{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
    };
    bashrcExtra = ''
      (cat ~/.cache/wal/sequences &)
      neofetch
    '';
  };
}
