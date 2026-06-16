{ config, pkgs, ... }:

{
  # Define custom TokyoNight Storm skin natively in Nix
  home.file.".hermes/skins/tokyonight-storm.yaml".text = pkgs.lib.generators.toYAML {} {
    name = "tokyonight-storm";
    description = "TokyoNight Storm — a dark, clean theme using the TokyoNight Storm palette";
    colors = {
      banner_border = "#414868";
      banner_title = "#7aa2f7";
      banner_accent = "#bb9af7";
      banner_dim = "#565f89";
      banner_text = "#c0caf5";
      ui_accent = "#7aa2f7";
      ui_label = "#7dcfff";
      ui_ok = "#9ece6a";
      ui_error = "#f7768e";
      ui_warn = "#ff9e64";
      prompt = "#c0caf5";
      input_rule = "#414868";
      response_border = "#7aa2f7";
      status_bar_bg = "#1a1b26";
      status_bar_text = "#a9b1d6";
      status_bar_strong = "#7aa2f7";
      status_bar_dim = "#565f89";
      status_bar_good = "#9ece6a";
      status_bar_warn = "#ff9e64";
      status_bar_bad = "#f7768e";
      status_bar_critical = "#f7768e";
      session_label = "#bb9af7";
      session_border = "#414868";
      voice_status_bg = "#1f2335";
      selection_bg = "#2e3c64";
      completion_menu_bg = "#1f2335";
      completion_menu_current_bg = "#2e3c64";
      completion_menu_meta_bg = "#1a1b26";
      completion_menu_meta_current_bg = "#2e3c64";
    };
    branding = {
      agent_name = "TokyoNight Agent";
      welcome = "Welcome to TokyoNight Storm! Type your message or /help for commands.";
      goodbye = "Goodbye under the storm! ☔";
      response_label = " ☔ TokyoNight ";
      prompt_symbol = "❯";
      help_header = "(☔) Available Commands";
    };
    tool_prefix = "┊";
  };
}
