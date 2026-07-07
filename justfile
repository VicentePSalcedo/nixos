## Sintra's NixOS Justfile
set shell := ["nu", "-c"]
set working-directory := '/home/sintra/nixos'

# Commit the current configuration stage to Git and push
@backup:
  git add -A
  let generation = (nixos-rebuild list-generations --json | from json | get --optional 0.generation | default "unknown"); if (git status --porcelain | is-empty) { git push } else { git commit -m $"NixOS Gen: ($generation)"; git push }

# Collect garbage and delete older generations
@cg:
  sudo nix-collect-garbage --delete-old

# Rebuild and switch the current system
@switch:
  git fetch
  git pull --rebase --autostash
  git add -A
  let generation = (nixos-rebuild list-generations --json | from json | get --optional 0.generation | default "unknown"); if (git status --porcelain | is-empty) { echo "Nothing to commit" } else { git commit -m $"NixOS Gen: ($generation) \(pre-switch\)" }
  nixos-rebuild switch --flake . --sudo --fallback
  sudo -u sintra just backup

# Upgrade packages and switch the current system
@update:
  git fetch
  git pull --rebase --autostash
  nix flake update
  git add -A
  let generation = (nixos-rebuild list-generations --json | from json | get --optional 0.generation | default "unknown"); if (git status --porcelain | is-empty) { echo "Nothing to commit" } else { git commit -m $"NixOS Gen: ($generation) \(pre-update\)" }
  nixos-rebuild switch --flake . --sudo --fallback
  sudo -u sintra just backup

# Download a torrent using rqbit
[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}
