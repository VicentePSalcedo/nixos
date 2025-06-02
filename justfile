set shell := ["nu", "-c"]
# set shell := ["bash", "-uc"]
set working-directory := '/home/sintra/nixos'

generation := shell('nixos-rebuild list-generations --json | from json | get -i 0.generation')

switch:
  nixos-rebuild switch --flake . --use-remote-sudo
backup:
  git add .
  git commit -m "NixOS Gen: {{generation}}"
  git push
  git status
cg:
  sudo nix-collect-garbage --delete-old
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose
[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}
