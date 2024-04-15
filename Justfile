# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################
clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
collect-garbage:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose
refresh:
  git add .
  git commit -m "Updated: `date +'%Y-%m-%d %H:%M:%S'`"
  git push
  nix flake update
  nixos-rebuild switch --flake . --use-remote-sudo
upgrade:
  nixos-rebuild switch --flake . --upgrade --use-remote-sudo
