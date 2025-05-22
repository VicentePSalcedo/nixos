set shell := ["nu", "-c"]

generation := shell('nixos-rebuild list-generations --json | from json | get -i 0.generation')
# generation := shell('nixos-rebuild', list-generations, --json | from json | get -i 0.generation)

cg:
  sudo nix-collect-garbage --delete-old

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

switch:
  nixos-rebuild switch --flake . --use-remote-sudo
  git add .
  git commit -m "Updated: (date now | format '%Y-%m-%d %H:%M:%S') (NixOS Gen: $generation)"
  git push
