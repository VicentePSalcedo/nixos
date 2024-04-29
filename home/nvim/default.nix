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
        nodejs_20
        fd
        lazygit
        tree-sitter
        xclip
        ripgrep
      ];
  };
}
