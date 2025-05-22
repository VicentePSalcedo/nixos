{ pkgs, ... }:
{
  programs.helix = {
    package = pkgs.evil-helix;
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      angular-language-server
      nixd
      prettierd
      pyright
      typescript-language-server
      vscode-langservers-extracted
    ];
    settings = {
      theme = "tokyonight_transparent";
      editor = {
        line-number = "absolute";
        bufferline = "multiple";
        color-modes = true;
        popup-border = "all";
        cursor-shape = {
          normal = "block";
          insert = "block";
          select = "underline";
        };
        auto-save = {
          after-delay.enable = true;
          after-delay.timeout = 3000;
          focus-lost = true;
        };
        text-width = 80;
        soft-wrap = {
          enable = true;
          wrap-at-text-width = true;
          max-indent-retain = 0;
        };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          language-servers = [ "nixd" ];
        }
        {
          name = "python";
          auto-format = true;
          formatter.command = "${pkgs.black}/bin/black";
          language-servers = [ "pyright" ];
        }
        {
          name = "angular";
          language-servers = [ "angular-language-server" ];
          file-types = [
            "typescript"
          ];
          scope = "angular.json";
        }
      ];
    };
    themes = {
      tokyonight_transparent = {
        "inherits" = "tokyonight";
        "ui.background" = { };
      };
    };
  };
}
