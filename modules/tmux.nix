{ pkgs, ... }:
{
  programs.tmux = {
    terminal = "alacritty";
    enable = true;
    baseIndex = 1;
    shortcut = "space";
    newSession = false;
    keyMode = "vi";
    escapeTime = 0;
    secureSocket = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
    ];
    extraConfig = ''
      set -g mouse on

      unbind C-b
      set -g prefix C-Space

      bind h select-pane -L
      bind j select-pane -D 
      bind k select-pane -U
      bind l select-pane -R

      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      set -g pane-active-border-style bg=color0
      set -g pane-border-style bg=color0
      set-window-option -g window-active-style bg=terminal
      set-window-option -g window-style bg=terminal
    '';
  };
}
