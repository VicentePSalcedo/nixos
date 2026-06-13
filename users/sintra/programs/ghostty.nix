{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 11;
      background-opacity = 0.40;
      background-blur = false;
      background = "#000000";
      theme = "TokyoNight Storm";
      command = "${pkgs.nushell}/bin/nu"; # Launch Nushell by default
    };
  };
}
