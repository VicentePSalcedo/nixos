{ config, pkgs, ... }:

let
  # TokyoNight Storm CSS theme for GnuCash
  # Place in ~/.config/gnucash/gtk-3.0.css
  gncCss = builtins.readFile ./gnucash/gtk-3.0.css;
in
{
  xdg.configFile."gnucash/gtk-3.0.css".text = gncCss;

  # Add a reminder in the user's home directory about the required preference
  home.file.".config/gnucash/README-GNUCASH-DARK.txt".text = ''
    GnuCash Dark Theme - TokyoNight Storm
    ======================================

    The dark theme CSS has been installed to ~/.config/gnucash/gtk-3.0.css.

    For the register colors to take effect, open GnuCash and go to:
      Edit > Preferences > Register
      UNCHECK "Use GnuCash built-in color theme"
    Then restart GnuCash.
  '';
}
