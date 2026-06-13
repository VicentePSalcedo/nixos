## Sintra's NixOS Justfile
set shell := ["nu", "-c"]
set working-directory := '/home/sintra/nixos'

generation := shell('nixos-rebuild list-generations --json | from json | get --optional 0.generation')

# Commit the current configuration stage to Git and push
backup:
  @git add -A
  @git commit -m "NixOS Gen: {{generation}}"
  @git push

# Collect garbage and delete older generations
cg:
  @sudo nix-collect-garbage --delete-old

# Rebuild and switch the current active host (determines host automatically from hostname)
switch:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake . --sudo
  @just backup

# Rebuild and switch the 'phantom' host specifically
switch-phantom:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake .#phantom --sudo
  @just backup

# Rebuild and switch the 'ghost' host specifically
switch-ghost:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake .#ghost --sudo
  @just backup

# Rebuild and switch the 'wraith' host specifically
switch-wraith:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake .#wraith --sudo
  @just backup

# Rebuild and switch the 'pi' host specifically (requires impure/aarch64 setup)
switch-pi:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake .#pi --sudo --impure
  @just backup

# Download a torrent using rqbit
[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}

# Upgrade packages and switch
update:
  @git fetch
  @git pull
  @nixos-rebuild switch --upgrade --flake . --sudo
  @just backup
