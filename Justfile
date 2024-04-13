# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################
backup:
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  git push
clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
collect-garbage:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose
deploy:
  nixos-rebuild switch --flake . --use-remote-sudo
refresh:
  git add .
  git commit -s -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  git push
  nix flake update
  nixos-rebuild switch --flake . --use-remote-sudo
update:
  nix flake update
upgrade:
  nixos-rebuild switch --flake . --upgrade --use-remote-sudo


