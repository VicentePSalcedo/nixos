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
        # auto-save = {
        #   after-delay.enable = true;
        # };
        soft-wrap = {
          enable = true;
          wrap-at-text-width = true;
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
          language-servers = [ "pyright" ];
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
