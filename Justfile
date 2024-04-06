# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy:
  nixos-rebuild switch --flake . --use-remote-sudo

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

update:
  nix flake update

upgrade:
  nixos-rebuild switch --flake . --upgrade --use-remote-sudo

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

collect-garbage:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old

