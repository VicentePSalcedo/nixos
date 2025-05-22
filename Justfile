set shell := ["nu", "-c"]

cg:
  sudo nix-collect-garbage --delete-old

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

switch:
  nixos-rebuild switch --flake . --use-remote-sudo
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  git push
