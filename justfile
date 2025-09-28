## useful commands for setup
# sudo mv /etc/nixos /etc/nixos.bak
# sudo ln -s ~/nixos /etc/nixos
# nixos-rebuild switch --flake .  --sudo

set shell := ["nu", "-c"]
# set shell := ["bash", "-uc"]
set working-directory := '/home/sintra/nixos'

generation := shell('nixos-rebuild list-generations --json | from json | get --optional 0.generation')

backup:
  @git add .
  @git commit -m "NixOS Gen: {{generation}}"
  @git push

cg:
  @sudo nix-collect-garbage --delete-old

switch:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake . --sudo
  @just backup

switchpi:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake . --sudo --impure
  @just backup

[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}

update:
  @git fetch
  @git pull
  @nixos-rebuild switch --upgrade --flake . --sudo
  @just backup

updatepi:
  @git fetch
  @git pull
  @nixos-rebuild switch --upgrade --flake . --sudo --impure
  @just backup
