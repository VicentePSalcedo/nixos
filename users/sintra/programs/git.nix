{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      pull.rebase = true;
    };
    # Add your default config if desired, e.g.:
    # userName = "Sintra";
    # userEmail = "sintra@example.com";
  };
}
