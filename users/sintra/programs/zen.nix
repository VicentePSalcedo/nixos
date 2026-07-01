{ config, pkgs, inputs, lib, ... }:

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
        ublock-origin
      ];
    };
  };

  # Symlink ONLY the default profile folder (holding extensions/settings)
  # instead of the entire .config/zen directory. This leaves Zen's configuration
  # directory and profiles.ini fully writable on disk!
  home.file.".config/zen/default".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/mozilla/firefox/default";

  # Declaratively generate a fully writable profiles.ini on disk upon activation
  home.activation.setupZenProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.config/zen
    
    cat << 'EOF' > "$HOME/.config/zen/profiles.ini"
[Profile0]
Name=default
IsRelative=1
Path=default
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF
    chmod 644 "$HOME/.config/zen/profiles.ini"
  '';
}
