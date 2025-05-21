{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  # nix.settings.experimental-features = [
  #   "nix-command"
  #   "flakes"
  # ];
}
