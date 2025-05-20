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
alias la = exa --tee --level=2 --icons --header --classify --group-directories-first --long --time-style=long-iso --all
