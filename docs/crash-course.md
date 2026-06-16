# 📖 NixOS Crash Course (For Beginners)

If you are new to NixOS, here are the core concepts that make this repository work:

* **What is NixOS?** Traditional Linux distros (Ubuntu, Arch) store software mutably. If you update a library, it might break another app. NixOS is built on the **Nix Package Manager**, which stores every package in a read-only, content-addressed folder under `/nix/store/`. Your entire operating system is compiled from code, making it completely immutable, reproducible, and immune to "system rot."
* **What are Flakes?** A Nix Flake (`flake.nix`) is a standardized packaging format. It specifies exact inputs (repositories like Nixpkgs) and locks their versions inside `flake.lock`. This guarantees that if you compile this repository on *any* machine, you will get the *exact same* system image down to the byte.
* **What is Home Manager?** Home Manager is like NixOS, but for your user home folder. It declaratively manages your configuration files (dotfiles), user-installed software, shell environments, and settings so your user workspace is as reproducible as your kernel.

---

## ⚙️ Nushell & Just Automation

A Nushell-native task runner is configured in `/home/sintra/nixos/justfile` to simplify system management. It extracts the active system generation number dynamically from `nixos-rebuild list-generations --json` and attaches it directly to automated Git back-up logs:

```justfile
## Sintra's NixOS Justfile
set shell := ["nu", "-c"]
set working-directory := '/home/sintra/nixos'

generation := shell('nixos-rebuild list-generations --json | from json | get --optional 0.generation')

# Commit the current configuration stage to Git and push
backup:
  @git add -A
  @if (git status --porcelain | is-empty) { git push } else { git commit -m "NixOS Gen: {{generation}}"; git push }

# Collect garbage and delete older generations
cg:
  @sudo nix-collect-garbage --delete-old

# Rebuild and switch the current system
switch:
  @git fetch
  @git pull
  @nixos-rebuild switch --flake . --sudo
  @just backup
```

### 🛠️ Common Automation Workflows:

#### 1. Rebuilding and Switching Your System
To apply changes made to your configuration on the local machine:
```bash
just switch
```
*Behind the scenes, this will pull updates, compile your configuration, switch your system live, extract the new generation number, stage all changed files in Git, make a commit with the generation number, and push it back to your repository automatically.*

#### 3. Freeing Up Disk Space (Garbage Collection)
To delete older, inactive system generations and run garbage collection on the Nix store:
```bash
just cg
```
