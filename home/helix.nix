{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nixd
    ];
    settings = {
      theme = "tokyonight_transparent";
      editor = {
        line-number = "relative";
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
        };
        # soft-wrap = {
        #   enable = true;
        #   wrap-at-text-width = true;
        #   max-indent-retain = 0;
        #   wrap-indicator = "";
        # };
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
          name = "typescript";
          auto-format = true;
          formatter.command = "${pkgs.prettierd}/bin/prettierd";
          language-servers = [ "angular-language-server" ];
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
