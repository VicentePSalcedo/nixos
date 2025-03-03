# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################
upgrade:
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  nixos-rebuild switch --flake . --upgrade --use-remote-sudo
deploy:
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  nixos-rebuild switch --flake . --use-remote-sudo
backup:
  nix flake update
  git push
collect-garbage:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose
doitall:
  nixos-rebuild switch --flake . --upgrade --use-remote-sudo
  nix flake update
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  git push
  sudo nix-collect-garbage --delete-old
