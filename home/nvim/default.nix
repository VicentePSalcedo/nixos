{ config, pkgs, lib, ... }:
{
  environment.pathsToLink = [ "/libexec" ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = lib.fileContents /home/sintra/nixos-config/home/nvim/config/init.lua;
  };
}
