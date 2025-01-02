{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      fd
      fzf
      gcc_multi
      ripgrep
      tree-sitter
      xclip
      # language servers commonly used outside of my repos
      jdk
      lua-language-server
      nixd
    ];
    defaultEditor = true;
  };
  programs.lazygit.enable = true;
  xdg.configFile."nvim".source = ./config;
}
