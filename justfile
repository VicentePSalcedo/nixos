set shell := ["nu", "-c"]
# set shell := ["bash", "-uc"]
set working-directory := '/home/sintra'

default: switch backup

generation := shell('nixos-rebuild list-generations --json | from json | get -i 0.generation')

[working-directory: '/home/sintra/nixos']
backup:
  git add .
  git commit -m "NixOS Gen: {{generation}}"
  git push
  git status

[working-directory: '/home/sintra/nixos']
cg:
  sudo nix-collect-garbage --delete-old

[working-directory: '/home/sintra/nixos']
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

@lookfor pkgs:
  nix search nixpkgs {{pkgs}} | bat

[working-directory: '/home/sintra/nixos']
switch:
  nixos-rebuild switch --flake . --use-remote-sudo

[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}
