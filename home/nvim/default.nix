{ config, pkgs, inputs, ... }:
{
  programs.neovim =
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        fd
        fzf
        gcc_multi
        lazygit
        lua-language-server
        nodejs_20
        nodePackages.typescript-language-server
        ripgrep
        rust-analyzer
        tree-sitter
        xclip
      ];
    };
}
