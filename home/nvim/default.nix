{ config, pkgs, inputs, ... }:
{
  programs.neovim = 
  {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        gcc_multi
        nodejs_21
        fd
        lazygit
        tree-sitter
        xclip
      ];
  };
}
