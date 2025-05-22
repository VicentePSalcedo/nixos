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
alias lt = exa --tree --level=2 --git --icons --header --classify --group-directories-first --long --time-style=long-iso
alias lta = exa --tree --level=2 --git --icons --header --classify --group-directories-first --long --time-style=long-iso --all
alias vi = hx

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
    wal -n -i $image
    hyprctl hyprpaper preload eDP-1, $image
    hyprctl hyprpaper wallpaper eDP-1, $image
}

$env.GPG_TTY = "$(tty)"

def "nu-complete just" [] {
    (^just --dump --unstable --dump-format json | from json).recipes | transpose recipe data | flatten | where {|row| $row.private == false } | select recipe doc parameters | rename value description
}

# Just: A Command Runner
export extern "just" [
    ...recipe: string@"nu-complete just", # Recipe(s) to run, may be with argument(s)
]

def "get-nixos-generation" [] {
  let nixos_profile = "/nix/var/nix/profiles/system"

  # Check if the NixOS profile link exists
  if (not (path exists $nixos_profile)) {
    error "NixOS system profile not found at ($nixos_profile)"
    return "" # Return empty string on error
  }

  let link_target = (ls -F $nixos_profile | get target)

  # Extract the generation number using regex (Nushell 0.80+ has good regex support)
  # This regex extracts digits that are between '-system-' and '-link'
  let matched_gen = ($link_target | str find -r "system-(\d+)-link" | get 0)

  if ($matched_gen | is empty) {
    error "Could not extract NixOS generation from ($link_target)"
    return ""
  }

  # The `str find` command returns a table, we need the first capture group.
  # For Nushell 0.80+, this is usually the first element of the found list.
  # For older versions, you might need `get matched_part` and then parse it.
  # Assuming 0.80+ for simplicity.
  let gen_num = ($matched_gen | get 1) # Get the first capture group (the actual number)

  $gen_num
}

# Example usage:
# get-nixos-generation
