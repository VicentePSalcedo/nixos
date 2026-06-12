{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 11;
      background-opacity = 0.0;
      background-blur = true;
      theme = "TokyoNight Storm";
      command = "${pkgs.nushell}/bin/nu"; # Launch Nushell by default
    };
  };
}
