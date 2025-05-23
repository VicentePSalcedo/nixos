set shell := ["nu", "-c"]
set working-directory := '/home/sintra'

default: switch backup

generation := shell('nixos-rebuild list-generations --json | from json | get -i 0.generation')

[working-directory: '/home/sintra/nixos']
backup:
  git add .
  git commit -m "NixOS Gen: {{generation}}"
  git push

[working-directory: '/home/sintra/nixos']
cg:
  sudo nix-collect-garbage --delete-old

[working-directory: '/home/sintra/nixos']
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

[working-directory: '/home/sintra/nixos']
switch:
  pwd
  nixos-rebuild switch --flake . --use-remote-sudo
