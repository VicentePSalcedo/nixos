{ config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;

    # Profile key = directory name under ~/.thunderbird. Using the existing
    # profile dir verbatim preserves mail data, accounts, and folders.
    profiles."wvfssd86.default" = {
      isDefault = true;

      settings = {
        # Force dark UI. TB 153 ignores extensions.activeThemeID for built-in
        # themes (AddonManager keeps default-theme@mozilla.org active), so the
        # working lever is ui.systemUsesDarkTheme — same mechanism as zen.nix.
        "ui.systemUsesDarkTheme" = 1;
        "extensions.activeThemeID" = "thunderbird-compact-dark@mozilla.org";
      };
    };
  };
}
