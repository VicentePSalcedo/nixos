{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
    };
    bashrcExtra = ''
      rustup completions bash > ~/.local/share/bash-completion/completions/rustup
    '';
  };
}
