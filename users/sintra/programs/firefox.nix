{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
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
      userChrome = ''
        /* TokyoNight Storm Theme for Firefox */
        :root {
          --tokyonight-bg: #1f2335;
          --tokyonight-bg-dark: #1a1b26;
          --tokyonight-bg-light: #24283b;
          --tokyonight-fg: #c0caf5;
          --tokyonight-fg-dark: #a9b1d6;
          --tokyonight-accent: #7aa2f7;
          --tokyonight-border: #414868;
        }

        /* Customize tab bar, URL bar, and toolbars */
        #navigator-toolbox {
          background-color: var(--tokyonight-bg-dark) !important;
          border-bottom: 1px solid var(--tokyonight-border) !important;
        }

        #PersonalToolbar, #nav-bar, #TabsToolbar {
          background-color: var(--tokyonight-bg-dark) !important;
          color: var(--tokyonight-fg) !important;
        }

        /* URL/Search Bar styling */
        #urlbar-background {
          background-color: var(--tokyonight-bg-light) !important;
          border: 1px solid var(--tokyonight-border) !important;
          border-radius: 6px !important;
        }

        #urlbar-input {
          color: var(--tokyonight-fg) !important;
        }

        /* Active Tab styling */
        .tab-background[selected="true"] {
          background-color: var(--tokyonight-bg-light) !important;
          background-image: none !important;
          border: 1px solid var(--tokyonight-border) !important;
          border-bottom-color: transparent !important;
        }

        /* Inactive Tab styling */
        .tab-background:not([selected="true"]) {
          background-color: var(--tokyonight-bg-dark) !important;
          background-image: none !important;
          opacity: 0.7 !important;
        }

        /* Tab text color */
        .tab-label {
          color: var(--tokyonight-fg) !important;
        }
        
        .tab-label[selected="true"] {
          color: var(--tokyonight-accent) !important;
          font-weight: bold !important;
        }
      '';
    };
  };
}
