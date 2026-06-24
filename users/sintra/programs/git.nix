{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      pull.rebase = true;
      user = {
        name = "Vicente Salcedo";
        email = "vicentepsalcedo@gmail.com";
      };
    };
  };
}
