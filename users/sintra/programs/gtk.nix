{ config, pkgs, ... }:

let
  theme = (import ../theme.nix).theme;
in
{
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
  };

  # Set dark preference for GTK applications
  gtk = {
    enable = true;
    theme = {
      name = "TokyoNight-Storm";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "TokyoNight-Storm";
      package = pkgs.tokyonight-gtk-theme;
    };
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Set dark preference in dconf (used by GNOME, GTK, and some flatpaks)
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "TokyoNight-Storm";
      icon-theme = "TokyoNight-Storm";
    };
  };

  # Qt Configuration to match GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
