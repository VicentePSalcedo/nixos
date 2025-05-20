# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################
# 
deploy:
  nixos-rebuild switch --flake . --use-remote-sudo
  nix flake update
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  git push
collect-garbage:
  sudo nix-collect-garbage --delete-old
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

# check to see is you have autoupdate module enabled
upgrade:
  nixos-rebuild switch --flake . --upgrade --use-remote-sudo
  nix flake update
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  git push
