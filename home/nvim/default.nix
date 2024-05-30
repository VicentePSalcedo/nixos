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
        fzf
        lazygit
        tree-sitter
        xclip
        ripgrep
      ];
    };
}
