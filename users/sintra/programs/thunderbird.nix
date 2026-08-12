{ config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;

    # Profile key = directory name under ~/.thunderbird. Using the existing
    # profile dir verbatim preserves mail data, accounts, and folders.
    profiles."wvfssd86.default" = {
      isDefault = true;

      settings = {
        # Built-in dark ("night") theme
        "extensions.activeThemeID" = "thunderbird-compact-dark@mozilla.org";
      };
    };
  };
}
