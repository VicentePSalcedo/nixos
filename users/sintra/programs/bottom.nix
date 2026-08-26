{ pkgs, ... }:

{
  # bottom (btm) — dev-tuned system monitor.
  # Config schema verified against bottom 0.14.8 (schema/v0.14.7/bottom.json).
  #
  # Cheatsheet (in-app):
  #   /        search        (regex is ON by default; Tab/Alt+w/Alt+c toggle match modes)
  #   dd       kill          -> advanced dialog: pick signal (15 TERM, 9 KILL, 2 INT, ...)
  #   t / T    tree on/off,  collapse/expand branch with +/- or Enter
  #   %        toggle Mem as value / percent
  #   e        expand focused widget fullscreen        f  freeze data
  #   s        sort menu     Ctrl+f  filter columns    ?  full help
  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        rate = "750ms";              # snappier than the 1s default
        default_time_value = "30s";  # tighter graph window: spot build spikes
        time_delta = "15s";
        retention = "5m";
        table_gap = "none";          # no blank line under headers -> more rows on screen
        show_table_scroll_position = true;
        show_table_scroll_bar = true;
      };

      # The bit that matters for finding/killing things.
      processes = {
        columns = [ "PID" "Name" "CPU%" "Mem%" "R/s" "W/s" "Time" "State" ];
        default_sort = "CPU%";
        sort_order = "Descending";
        process_command = true;      # full argv, not just "node"/"python3"
        hide_k_threads = true;       # drop hundreds of [kworker] rows
        regex = true;               # `/` search is regex by default
        default_memory_value = true; # MiB instead of %, `%` toggles
        unnormalized_cpu = true;     # htop-style: a 16-thread build reads ~1600%
        disable_advanced_kill = false; # keep the signal picker on `dd`
      };

      cpu = {
        default = "all";             # per-core on start, not the average
        show_decimal = false;
      };

      memory_graph.cache_memory = true; # split cache/buffers out of "used"

      # Cut noise out of the disk + network widgets.
      disk.name_filter = {
        is_list_ignored = true;
        regex = true;
        list = [ "^/dev/loop\\d+" "^/dev/zram\\d+" ];
      };
      network_graph.interface_filter = {
        is_list_ignored = true;
        regex = true;
        list = [ "^lo$" "^veth" "^podman" "^docker" "^virbr" "^br-" ];
      };

      # TokyoNight Storm.
      styles = {
        cpu = {
          all_entry_colour = "#7aa2f7";
          avg_entry_colour = "#f7768e";
          cpu_core_colours = [
            "#7aa2f7"
            "#9ece6a"
            "#e0af68"
            "#bb9af7"
            "#7dcfff"
            "#ff9e64"
            "#2ac3de"
            "#c0caf5"
          ];
        };
        memory = {
          ram_colour = "#7aa2f7";
          cache_colour = "#565f89";
          swap_colour = "#e0af68";
          arc_colour = "#7dcfff";
        };
        network = {
          rx_colour = "#9ece6a";
          tx_colour = "#bb9af7";
          rx_total_colour = "#7dcfff";
          tx_total_colour = "#ff9e64";
        };
        tables.headers = {
          colour = "#7dcfff";
          bold = true;
        };
        graphs = {
          graph_colour = "#565f89";
          legend_text.colour = "#a9b1d6";
        };
        widgets = {
          widget_border_type = "Rounded";
          border_colour = "#414868";
          selected_border_colour = "#7aa2f7";
          widget_title = {
            colour = "#7dcfff";
            bold = true;
          };
          text.colour = "#c0caf5";
          selected_text = {
            colour = "#1a1b26";
            bg_colour = "#7aa2f7";
          };
          disabled_text.colour = "#565f89";
          thread_text.colour = "#9ece6a";
        };
      };

      # Layout: graphs stay small, the process table gets the screen.
      row = [
        {
          ratio = 26;
          child = [
            {
              ratio = 3;
              type = "cpu";
            }
            {
              ratio = 2;
              type = "mem";
            }
          ];
        }
        {
          ratio = 52;
          child = [
            {
              type = "proc";
              default = true;
            }
          ];
        }
        {
          ratio = 22;
          child = [
            {
              ratio = 4;
              type = "net";
            }
            {
              ratio = 4;
              type = "disk";
            }
            {
              ratio = 3;
              type = "temp";
            }
          ];
        }
      ];
    };
  };

  # pik: search-first process killer. `pik :3000` finds whatever is squatting
  # your dev port, `pik /home/sintra/Repos` filters by binary path,
  # `pik -jar` by argument. Enter kills, Ctrl+r refreshes.
  home.packages = [ pkgs.pik ];

  programs.nushell = {
    shellAliases = {
      btmp = "btm --expanded";                     # fullscreen process table
      btmt = "btm --tree";                         # parent/child tree
      btmm = "btm --process_default_sort mem";     # memory hogs first
      btmb = "btm --basic";                        # htop-ish, no graphs
      kp = "pik";
    };
    extraConfig = ''
      # Kill whatever holds a TCP port: `kport 3000`
      def kport [port: int] { ^pik $":($port)" }
    '';
  };

  programs.bash.shellAliases = {
    btmp = "btm --expanded";
    btmt = "btm --tree";
    btmm = "btm --process_default_sort mem";
    btmb = "btm --basic";
    kp = "pik";
  };
}
