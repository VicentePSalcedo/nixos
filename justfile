## Sintra's NixOS Justfile
set shell := ["nu", "-c"]
set working-directory := '/home/sintra/nixos'

generation := shell('nixos-rebuild list-generations --json | from json | get --optional 0.generation')

# Commit the current configuration stage to Git and push
backup:
  @git add -A
  @git commit -m "NixOS Gen: {{generation}}"
  @git push

# Collect garbage and delete older generations
cg:
  @sudo nix-collect-garbage --delete-old

# Rebuild and switch a host (defaults to current host, appends --impure for "pi")
switch host="":
  @git fetch
  @git pull
  @nixos-rebuild switch --flake .{{ if host == "" { "" } else { "#" + host } }} --sudo {{ if host == "pi" { "--impure" } else { "" } }}
  @just backup

# Upgrade packages and switch a host (defaults to current host, appends --impure for "pi")
update host="":
  @git fetch
  @git pull
  @nixos-rebuild switch --upgrade --flake .{{ if host == "" { "" } else { "#" + host } }} --sudo {{ if host == "pi" { "--impure" } else { "" } }}
  @just backup

# Download a torrent using rqbit
[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}
