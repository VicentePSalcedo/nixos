{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      pull.rebase = true;
    };
    userName = "Vicente Salcedo";
    userEmail = "vicentepsalcedo@gmail.com";
  };
}
