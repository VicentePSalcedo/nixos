{ config, pkgs, inputs, ... }:

{
  home.username = "sintra";
  home.homeDirectory = "/home/sintra";
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Development tools managed via Home Manager modules
  programs.git = {
    enable = true;
    # Add your default config if desired, e.g.:
    # userName = "Sintra";
    # userEmail = "sintra@example.com";
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight_storm";
    };
  };

  # Packages to install for the user's environment
  home.packages = with pkgs; [
    ghostty      # Modern, fast GPU-accelerated terminal
    waybar       # Clean status bar for Wayland
    wofi         # Wayland application launcher
    mako         # Lightweight notification daemon
    swaybg       # Wallpaper utility
    grim         # Screenshot utility
    slurp        # Region selector for screenshots
    wl-clipboard # Wayland clipboard manager
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
  ];

  # Classic, bulletproof Hyprland configuration
  xdg.configFile."hypr/hyprland.conf".text = ''
    # Set your main modifier key
    $mainMod = ALT

    # Autostart applications
    exec-once = swaybg -i /home/sintra/Pictures/tokyonight.png -m fill
    exec-once = waybar
    exec-once = mako

    # Monitor configuration
    monitor = ,preferred,auto,1

    # Input configuration
    input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
            natural_scroll = false
        }
    }

    # General styling
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(7aa2f7ee) rgba(bb9af7ee) 45deg
        col.inactive_border = rgba(414868aa)
        layout = dwindle
    }

    # Visual decoration
    decoration {
        rounding = 10
        blur {
            enabled = true
            size = 3
            passes = 1
        }
    }

    # Animations
    animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    # Keybindings
    bind = $mainMod, RETURN, exec, ghostty
    bind = $mainMod, X, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, dolphin
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, D, exec, wofi --show drun
    bind = $mainMod, P, pseudo,
    bind = $mainMod, S, layoutmsg, togglesplit

    # Move focus with mainMod + Vim keys (h, j, k, l)
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Swap/move windows with mainMod + SHIFT + Vim keys (h, j, k, l)
    bind = $mainMod SHIFT, H, movewindow, l
    bind = $mainMod SHIFT, L, movewindow, r
    bind = $mainMod SHIFT, K, movewindow, u
    bind = $mainMod SHIFT, J, movewindow, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10
  '';

  # Modern, fast GPU-accelerated Ghostty configuration
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 11;
      background-opacity = 0.9;
      theme = "TokyoNight Storm";
      command = "${pkgs.nushell}/bin/nu"; # Launch Nushell by default
    };
  };

  # Modern and minimalist structured shell
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
    extraConfig = ''
      $env.config.color_config = {
        binary: "#bb9af7"
        block: "#7aa2f7"
        cell-path: "#a9b1d6"
        closure: "#7dcfff"
        custom: "#c0caf5"
        duration: "#e0af68"
        float: "#f7768e"
        glob: "#c0caf5"
        int: "#bb9af7"
        list: "#7dcfff"
        nothing: "#f7768e"
        range: "#e0af68"
        record: "#7dcfff"
        string: "#9ece6a"
        bool: {|| if $in { "#7dcfff" } else { "#e0af68" } }

        shape_and: { fg: "#bb9af7" attr: "b" }
        shape_binary: { fg: "#bb9af7" attr: "b" }
        shape_block: { fg: "#7aa2f7" attr: "b" }
        shape_bool: "#7dcfff"
        shape_closure: { fg: "#7dcfff" attr: "b" }
        shape_custom: "#9ece6a"
        shape_datetime: { fg: "#7dcfff" attr: "b" }
        shape_directory: "#7dcfff"
        shape_external: "#7dcfff"
        shape_external_resolved: "#7dcfff"
        shape_externalarg: { fg: "#9ece6a" attr: "b" }
        shape_filepath: "#7dcfff"
        shape_flag: { fg: "#7aa2f7" attr: "b" }
        shape_float: { fg: "#f7768e" attr: "b" }
        shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
        shape_glob_interpolation: { fg: "#7dcfff" attr: "b" }
        shape_globpattern: { fg: "#7dcfff" attr: "b" }
        shape_int: { fg: "#bb9af7" attr: "b" }
        shape_internalcall: { fg: "#7dcfff" attr: "b" }
        shape_keyword: { fg: "#bb9af7" attr: "b" }
        shape_list: { fg: "#7dcfff" attr: "b" }
        shape_literal: "#7aa2f7"
        shape_match_pattern: "#9ece6a"
        shape_matching_brackets: { attr: "u" }
        shape_nothing: "#f7768e"
        shape_operator: "#e0af68"
        shape_or: { fg: "#bb9af7" attr: "b" }
        shape_pipe: { fg: "#bb9af7" attr: "b" }
        shape_range: { fg: "#e0af68" attr: "b" }
        shape_raw_string: { fg: "#c0caf5" attr: "b" }
        shape_record: { fg: "#7dcfff" attr: "b" }
        shape_redirection: { fg: "#bb9af7" attr: "b" }
        shape_signature: { fg: "#9ece6a" attr: "b" }
        shape_string: "#9ece6a"
        shape_string_interpolation: { fg: "#7dcfff" attr: "b" }
        shape_table: { fg: "#7aa2f7" attr: "b" }
        shape_vardecl: { fg: "#7aa2f7" attr: "u" }
        shape_variable: "#bb9af7"

        foreground: "#c0caf5"
        background: "#1a1b26"
        cursor: "#c0caf5"

        empty: "#7aa2f7"
        header: { fg: "#9ece6a" attr: "b" }
        hints: "#414868"
        row_index: { fg: "#9ece6a" attr: "b" }
        search_result: { fg: "#f7768e" bg: "#a9b1d6" }
        separator: "#a9b1d6"
      }
    '';
  };

  # Fast, terminal-based file manager written in Rust
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Ultra-minimalist Waybar showing ONLY active workspaces
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [];
        modules-right = [];
        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
      };
    };
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: monospace;
          font-size: 13px;
          min-height: 0;
      }
      window#waybar {
          background: transparent;
          color: #cdd6f4;
      }
      #workspaces button {
          padding: 0 8px;
          background: transparent;
          color: #7f849c;
      }
      #workspaces button.active {
          color: #cdd6f4;
          font-weight: bold;
      }
    '';
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      # If logging in on tty1 and not already in a graphical session, autostart Hyprland
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}
