{ config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      # Point at the existing profile so mail data, accounts, and folders are preserved
      path = "wvfssd86.default";

      settings = {
        # Built-in dark ("night") theme
        "extensions.activeThemeID" = "thunderbird-compact-dark@mozilla.org";
      };
    };
  };
}
