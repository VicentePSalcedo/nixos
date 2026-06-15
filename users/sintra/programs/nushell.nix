{ config, pkgs, ... }:

{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      NPM_CONFIG_CACHE = "${config.home.homeDirectory}/.cache/npm";
    };
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
        background: "nothing"
        cursor: "#c0caf5"

        empty: "#7aa2f7"
        header: { fg: "#9ece6a" attr: "b" }
        hints: "#414868"
        row_index: { fg: "#9ece6a" attr: "b" }
        search_result: { fg: "#f7768e" bg: "#a9b1d6" }
        separator: "#a9b1d6"
      }

      # SSH host completion
      def ssh_hosts [] {
          if ('.ssh/config' | path exists) {
              open ~/.ssh/config 
              | lines 
              | filter { $in =~ '^Host\\s+' } 
              | parse "Host {name}" 
              | get name
          } else { [] }
      }

      $env.config.completions.external = {
        enable: true
        completer: {|spans|
          if ($spans.0 == "ssh") {
              ssh_hosts | filter { $in | str starts-with ($spans | last) }
          } else {
              null
          }
        }
      }
      # Just completion
      mkdir ~/.cache/nushell
      just --completions nushell | save -f ~/.cache/nushell/completions.nu
      source ~/.cache/nushell/completions.nu
    '';
  };
}
