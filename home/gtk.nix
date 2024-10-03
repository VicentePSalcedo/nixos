{ pkgs, ... }:
{
  gtk = {
    enable = true;
      font.name = "FiraCodeNerdFont";
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
  };
}
