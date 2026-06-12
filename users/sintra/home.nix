{ config, pkgs, ... }:

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
    # Custom settings can be defined here, e.g.:
    # settings = {
    #   theme = "catppuccin_mocha";
    # };
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
  ];

  # Classic, bulletproof Hyprland configuration
  xdg.configFile."hypr/hyprland.conf".text = ''
    # Set your main modifier key
    $mainMod = ALT

    # Autostart applications
    exec-once = swaybg -c '#1e1e2e' -m solid
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
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
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
    bind = $mainMod, Q, killactive,
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
      command = "${pkgs.nushell}/bin/nu"; # Launch Nushell by default
    };
  };

  # Modern and minimalist structured shell
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
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
