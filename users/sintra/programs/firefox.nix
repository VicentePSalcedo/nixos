{ config, pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true;
        "webgl.disabled" = false;
        "ui.systemUsesDarkTheme" = 1;
        "extensions.autoDisableScopes" = 0;
      };
      extensions.packages = with pkgs.firefox-addons; [
        dashlane
        darkreader
        vimium
      ];
    };
  };

  # Symlink Zen Browser's profile directory to Firefox's profile directory so
  # they share the exact same profiles, settings, and extensions cleanly.
  home.file.".config/zen".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.mozilla/firefox";
}
