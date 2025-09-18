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

debug:
  #nixos-rebuild switch --flake . --sudo --show-trace --verbose

setup:
  sudo mv /etc/nixos /etc/nixos.bak
  sudo ln -s ~/nixos /etc/nixos
  nixos-rebuild switch --flake .  --sudo

switch:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake . --sudo
  @just backup

[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}

update:
  @git fetch
  @git pull
  @nixos-rebuild switch --upgrade --flake . --sudo
  @just backup
