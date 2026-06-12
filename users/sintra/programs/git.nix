{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    # Add your default config if desired, e.g.:
    # userName = "Sintra";
    # userEmail = "sintra@example.com";
  };
}
