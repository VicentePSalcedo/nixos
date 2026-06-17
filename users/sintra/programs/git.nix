{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      pull.rebase = true;
    };
    # Add your default config if desired, e.g.:
    # userName = "Sintra";
    # userEmail = "sintra@example.com";
  };
}
