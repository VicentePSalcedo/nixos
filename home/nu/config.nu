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

alias ls = exa --icons --header --classify --group-directories-first --long --time-style=long-iso
alias la = exa --icons --header --classify --group-directories-first --long --time-style=long-iso --all
alias lt = exa --tree --level=2 --git --icons --header --classify --group-directories-first --long --time-style=long-iso --all

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

cat ~/.cache/wal/sequences
fastfetch

def hypr-wal [image] {
    wal -n -i ($image)
    hyprctl hyprpaper preload eDP-1, ($image)
    hyprctl hyprpaper wallpaper eDP-1, ($image)
}
