$env.config = {
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}

$env.config.show_banner = false

$env.GPG_TTY = "$(tty)"

export-env { $env.STARSHIP_SHELL = "nu"; load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        ^/etc/profiles/per-user/sintra/bin/starship prompt --continuation
    )

    # Does not play well with default character module.
    # TODO: Also Use starship vi mode indicators?
    PROMPT_INDICATOR: ""

    PROMPT_COMMAND: {||
        # jobs are not supported
        (
            ^/etc/profiles/per-user/sintra/bin/starship prompt
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }

    config: ($env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
        (
            ^/etc/profiles/per-user/sintra/bin/starship prompt
                --right
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }
}}

alias core-ls = ls
alias ls = exa --icons --header --classify --group-directories-first --long --time-style=long-iso
alias la = exa --icons --header --classify --group-directories-first --long --time-style=long-iso --all
alias lt = exa --tree --level=2 --git --icons --header --classify --group-directories-first --long --time-style=long-iso
alias lta = exa --tree --level=2 --git --icons --header --classify --group-directories-first --long --time-style=long-iso --all

alias vi = hx

alias core-cat = cat
alias cat = bat

def hypr-wal [image] {
    hyprctl hyprpaper reload , $image
    wal -n -i $image
}

def lookfor [pkgs] {
    nix search nixpkgs $pkgs | bat
}

def edit [path] {
    if $path != null {
        hx /etc/nixos/($path)
    } else {
        hx /etc/nixos
    }
}

# let internal_monitor_name = "eDP-1"
# let internal_monitor_resolution = "1920x1080@60"
# let external_monitor_name = "DP-1"
# let external_monitor_resolution = "1920x1080@120"
# def configure_monitors [ ] {
#     echo "Configuring monitors..."
#     # let connected_monitors = hyprctl monitors -j | jq -r '.[].name'
#     # if { echo $connected_monitors } == 0 {
#     #     echo External monitor $external_monitor_name detected. Enabling...
#     #     hyprctl keyword monitor $external_monitor_name ,($external_monitor_resolution)
#     #     hyprctl keyword monitor $internal_monitor_name ,($internal_monitor_resolution)
#     #     echo External monitor active, internal disabled.
#     # } else {
#     #     echo "External monitor not detected. Enabling internal..."
#     #     hyprctl keyword monitor "$INTERNAL_MONITOR_NAME,1920x1080@60.05,0x0,1"
#     #     echo "Internal monitor active."
#     # }
#     # echo "Monitor configuration complete."
# }

core-cat ~/.cache/wal/sequences
fastfetch

source ~/.zoxide.nu
