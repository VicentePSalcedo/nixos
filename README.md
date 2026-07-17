# Sintra's Modular NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-26.05-blue.svg?logo=nixos&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/Home_Manager-declarative-orange.svg?logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)
[![Built with Flakes](https://img.shields.io/badge/Nix_Flakes-supported-purple.svg?logo=nixos&logoColor=white)](https://wiki.nixos.org/wiki/Flakes)
[![TokyoNight Storm](https://img.shields.io/badge/Theme-TokyoNight_Storm-7aa2f7.svg?style=flat)](https://github.com/folke/tokyonight.nvim)

> An enterprise-grade, beautifully modularized NixOS flake configuration. This repository manages Sintra's workstation styled with a cohesive, transparent **TokyoNight Storm** aesthetic.

---

## Host Overview

This repository uses a single unified Git-tracked Nix Flake to manage the physical machine under a shared declarative framework:

| Hostname | Role / Architecture | Graphics / Driver | Bootloader | Highlights |
| :--- | :--- | :--- | :--- | :--- |
| **`phantom`** | Daily Driver Workstation <br>`x86_64-linux` | AMD Radeon RX 580 <br>`amdgpu` + Mesa | `systemd-boot` | GPU accelerated, gaming-optimized, runs local system-wide AI assistant. |
| **`wraith`** | Portable Laptop <br>`x86_64-linux` | Integrated Graphics | `systemd-boot` | Portable laptop setup, fully syncs data with Phantom, supports backlight/brightness controls via Hyprland. |

---

## Repository Architecture

The repository enforces a strict, logical **Separation of Concerns**. Core system services belong under `system/`, host-specific hardware details live under `hosts/`, and user-space dotfiles are kept under `users/`.

```text
/etc/nixos/ / ~ /nixos/
├── flake.nix                  # Unified entrypoint declaring inputs & machine mappings
├── flake.lock                 # Lockfile pinning exact package versions for 100% reproducibility
├── justfile                   # Nushell-powered workflow runner and automation engine
├── secrets.yaml               # Encrypted sops-nix credentials (API keys, environments)
│
├── hosts/                     # Machine-specific directories
│   ├── phantom/               # Daily driver workstation
│   │   ├── default.nix        # Host definitions (systemd-boot, user definitions, modules)
│   │   └── hardware-configuration.nix
│   └── wraith/                # Portable laptop setup
│       ├── default.nix        # Host definitions, brightness, and bluetooth settings
│       └── hardware-configuration.nix
│
├── system/                    # Shareable, modular system-level service modules
│   ├── common.nix             # Shared configuration block for all hosts
│   ├── bluetooth.nix          # Bluetooth daemon and audio profiles
│   ├── direnv.nix             # Automatic development shell environments
│   ├── podman.nix             # Containerization runtimes (Podman with Docker-compat)
│   ├── gaming.nix             # Steam, GameMode, GameScope optimization blocks
│   ├── gnupg.nix              # GnuPG daemon configuration and pinentry
│   ├── hermes.nix             # System-wide Autonomous AI integration (Hermes Agent)
│   ├── minecraft.nix          # Declarative headless gaming server
│   ├── nix-settings.nix       # Garbage collection, Flakes activation, rycee Firefox overlay
│   ├── nvidia.nix             # NVIDIA proprietary drivers and graphics setup
│   ├── power.nix              # TLP power management for portable devices
│   ├── printing.nix           # CUPS configuration for printing services
│   ├── sops.nix               # SOPS age decryption keys & declarations
│   ├── ssh.nix                # SSH daemon configurations
│   ├── syncthing.nix          # System-level Syncthing configurations
│   ├── tailscale.nix          # Tailscale mesh VPN daemon
│   └── tmux.nix               # Multiplexed terminal setups
│
├── users/                     # Declares home directory layouts & desktop settings
│   └── sintra/
│       ├── home.nix           # Home Manager central directory (imports program blocks)
│       ├── theme.nix          # Global TokyoNight Storm theme colors in pure Nix attribute set
│       └── programs/          # Flat, native Nix and raw configurations (minimalist)
│           ├── bash.nix       # Display-Manager-less TTY autostart logic
│           ├── beets.nix      # Music library organizer setup
│           ├── direnv.nix     # Fast development shells configuration
│           ├── eza.nix        # Beautiful, color-coded replacement for ls
│           ├── fastfetch.nix  # Neofetch replacement with performance stats
│           ├── zen.nix        # Zen Browser with declaratively managed extensions
│           ├── fuzzel.nix     # App launcher styled to TokyoNight Storm
│           ├── foot.nix       # Lightweight, Wayland-native CPU-rendered terminal daemon
│           ├── git.nix        # Git global configuration
│           ├── gtk.nix        # GTK theming mirroring TokyoNight Storm
│           ├── helix.nix      # Minimalist text editor (transparent tokyonight theme)
│           ├── hermes.nix     # Declarative user-space AI agent skin configuration
│           ├── nushell.nix    # Nu interactive shell with TokyoNight syntax highlight
│           ├── rust-analyzer-mcp.nix # Modular custom build definition for rust-analyzer-mcp
│           ├── starship.nix   # Cross-shell prompt featuring custom powerline glyphs
│           ├── verso.nix      # Modular custom build definition for Verso web browser
│           ├── yazi.nix       # Terminal file explorer integrated with Helix and Nushell
│           ├── zoxide.nix     # Fast directory jumper setup
│           ├── hyprland/      # Core window manager folder
│           │   ├── default.nix  # Bypasses buggy Home Manager Lua generation
│           │   └── hyprland.conf # Raw compositor config (Vim-navigation, splits)
│           └── waybar/        # Custom status bar
│               ├── default.nix
│               └── style.css  # Native stylesheet layout
│
```

---

## Architecture & Design

This document outlines the architectural blueprints, structural rules, and design philosophies underpinning this NixOS configuration repository.

### Core Design Philosophies

This configuration repository is designed around three fundamental pillars:

1. **Reproducibility First**: Every host, application, configuration, and environment variable must be declared in code. If it cannot be declared, it should be isolated and automated.
2. **Minimalist Cohesion**: Avoid redundant directories, nested boilerplate, and complex file nesting. Prefer a flat, readable file layout wherever possible.
3. **Decoupled User-System Boundary**: The operating system layer (managed by NixOS) and the user environment layer (managed by Home Manager) should be clearly separated, but harmonized through unified styling and configuration overlays.

---

### System & User Boundary Matrix

To maintain a clean boundary, the repository enforces a strict rule set on where configurations are declared:

```text
+----------------------------------------------------------+
|                       FLAKE.NIX                           |
|              (Unified Flake Entrypoint)                   |
+----------------------------+-----------------------------+
                             |
               +-------------+-------------+
               v                           v
 +--------------------------+  +--------------------------+
 |        SYSTEMS           |  |     USER WORKSPACE       |
 |  (Root: sudo privileges) |  |  (Root: user-space)      |
 +--------------------------+  +--------------------------+
 |  - Kernel & Boot         |  |  - Window Manager        |
 |  - Hardware Drivers      |  |  - Terminal Shells       |
 |  - Docker & Runtimes     |  |  - User CLI Utilities    |
 |  - System Daemons        |  |  - Browsers & Clients    |
 |  - PAM & Users           |  |  - Custom User Themes    |
 +--------------------------+  +--------------------------+
```

#### 1. The System Layer (`system/` and `hosts/`)

The system layer is responsible for low-level configuration, hardware-specific drivers, security protocols, and system-wide services.

- **Imports Rule:** Hosts under `hosts/<hostname>/default.nix` import shared modules under `system/` (such as `sops.nix`, `gaming.nix`, `bluetooth.nix`) and declare host-specific details (such as the computer's hostname, users, bootloaders, and state version).
- **Relative Path Standard:** Because files are modularized, all relative path imports must scale correctly. Files in `hosts/` use `../../system/` prefix, while files in `system/` reference global root assets using `../` (e.g. referencing `secrets.yaml` inside `system/sops.nix` as `defaultSopsFile = ../secrets.yaml;`).

#### 2. The User Layer (`users/sintra/`)

The user layer manages user-space programs, dotfiles, application settings, styling, and personal terminal workflows via **Home Manager**.

- **Single-File Preference:** Unless a program requires multiple complex nested assets or custom scripts (like Waybar with its stylesheet), **we always prefer a single-file configuration** directly under `programs/` (e.g., `programs/starship.nix`, `programs/fastfetch.nix`) rather than creating a nested folder with a `default.nix`.
- **Declarative Settings Block:** We prioritize declaring application settings natively inside Nix using standard attribute sets (e.g., `programs.starship.settings = { ... }` or `programs.helix.settings = { ... }`) instead of writing raw config files. This maintains maximum coherence and type safety within the Nix evaluator.
- **Raw Config Fallback:** When a program's Nix translator is experimental or buggy (such as Hyprland's Lua generation), we bypass the translator and load a raw config file using `builtins.readFile` to ensure 100% stable execution.

---

### Secrets Management Layout

Secrets (API tokens, private configuration files, private keys) are fully encrypted and committed directly to Git using **SOPS-nix** and **age**.

```text
                    +--------------------------+
                    |     secrets.yaml         |  <-- Encrypted with Age Public Key
                    +------------+-------------+      (Safe to commit to Git)
                                 |
                                 v
  +--------------------------------------------------------+
  |                   system/sops.nix                      |
  |  (Loads secrets using local private key at boot time)  |
  +----------------------------+---------------------------+
                               |
                               v
          /run/secrets/hermes-env (Decrypted RAM FS)
                               |
                               v
              Injected into services.hermes-agent
```

#### Key Management Policies:

- The encrypted file `secrets.yaml` sits at the root of the repository.
- The public age keys are registered inside a root `.sops.yaml` file to determine encryption targets.
- The private decryption key is kept at `/home/sintra/.config/sops/age/keys.txt` (or `/var/lib/sops-nix/key` depending on the machine). This file is **strictly excluded** from Git via `.gitignore`.
- At boot time, the system uses the private key to decrypt the secrets into a secure RAM filesystem (`/run/secrets/`), which is only readable by system daemons or users in the `wheel`/`hermes` groups. This prevents secrets from ever touching disk in plain text.

---

### AI-Agent Co-operation & Boundary Design

This repository is optimized for autonomous AI operations (e.g. using Hermes Agent). To prevent system collisions and compilation bottlenecks in sandboxed agent sessions, several custom system boundaries are established:

#### 1. System-wide Hermes Daemon

Rather than running an AI assistant purely in a user session, `services.hermes-agent` runs as a systemd system service.

- **The Permission Bypass:** The system user `sintra` is added to the `hermes` group. Because system-wide Hermes state files are owned by the `hermes` group with group-write permissions (0775), the user can modify skins and settings without needing `sudo` access.
- **Systemd PATH Isolation Fix:** Background systemd services start with an extremely bare environment lacking core packages. To let the agent run nix builds or git clones, we inject compile binaries directly into the service path:
  ```nix
  systemd.services.hermes-agent.path = [ pkgs.nix pkgs.git pkgs.nodejs ];
  ```
- **Declarative Theme Generation & Sync:** Rather than using static theme files, both user and system-wide configurations programmatically generate the exact same TokyoNight Storm skin YAML file from a Nix attribute set via `pkgs.lib.generators.toYAML`.
  At the system level, this is built using `pkgs.writeText` and symlinked natively via `systemd.tmpfiles.rules` using the `L+` rule:
  ```nix
  systemd.tmpfiles.rules = let
    themeContent = pkgs.lib.generators.toYAML {} {
      name = "tokyonight-storm";
      colors = { ... };
      branding = { ... };
    };
    themeFile = pkgs.writeText "tokyonight-storm.yaml" themeContent;
  in [
    "d /var/lib/hermes/.hermes/skins 0775 hermes hermes - -"
    "L+ /var/lib/hermes/.hermes/skins/tokyonight-storm.yaml - - - - ${themeFile}"
  ];
  ```
  At the user level (`users/sintra/programs/hermes.nix`), we programmatically generate the skin directly into the user's home directory:
  ```nix
  home.file.".hermes/skins/tokyonight-storm.yaml".text = pkgs.lib.generators.toYAML {} { ... };
  ```
  This guarantees perfect theme synchronization across all layers while keeping configurations completely declarative and tracked inside the Nix store.

---

### GPU Acceleration & Performance Profiles

This configuration leverages optimized graphics driver architectures:

- **AMD Graphics (phantom):** Utilizes the open-source `amdgpu` kernel module and userspace Mesa libraries. Hardware acceleration is enabled cleanly under the `hardware.graphics` subsystem:
  ```nix
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Wine/Steam 32-bit gaming runtimes
  };
  ```
- **NVIDIA Graphics:** Although no longer active on the host, a system-level configuration template for NVIDIA's proprietary driver is preserved under `system/nvidia.nix` for future use.
- **Gaming Optimizations:** System modules like `gaming.nix` configure the kernel to support dynamic process prioritization (`gamemode`) and low-latency compositor isolation (`gamescope`), allowing games to run with high thread priority and zero window-manager lag.

---

## NixOS Crash Course (For Beginners)

If you are new to NixOS, here are the core concepts that make this repository work:

- **What is NixOS?** Traditional Linux distros (Ubuntu, Arch) store software mutably. If you update a library, it might break another app. NixOS is built on the **Nix Package Manager**, which stores every package in a read-only, content-addressed folder under `/nix/store/`. Your entire operating system is compiled from code, making it completely immutable, reproducible, and immune to "system rot."
- **What are Flakes?** A Nix Flake (`flake.nix`) is a standardized packaging format. It specifies exact inputs (repositories like Nixpkgs) and locks their versions inside `flake.lock`. This guarantees that if you compile this repository on *any* machine, you will get the *exact same* system image down to the byte.
- **What is Home Manager?** Home Manager is like NixOS, but for your user home folder. It declaratively manages your configuration files (dotfiles), user-installed software, shell environments, and settings so your user workspace is as reproducible as your kernel.

---

### Nushell & Just Automation

A Nushell-native task runner is configured in `/home/sintra/nixos/justfile` to simplify system management. It extracts the active system generation number dynamically from `nixos-rebuild list-generations --json` and attaches it directly to automated Git back-up logs:

```justfile
## Sintra's NixOS Justfile
set shell := ["nu", "-c"]
set working-directory := '/home/sintra/nixos'

# Commit the current configuration stage to Git and push
@backup:
  git add -A
  let generation = (nixos-rebuild list-generations --json | from json | get --optional 0.generation | default "unknown"); if (git status --porcelain | is-empty) { git push } else { git commit -m $"NixOS Gen: ($generation)"; git push }

# Collect garbage and delete older generations
@cg:
  sudo nix-collect-garbage --delete-old

# Rebuild and switch the current system
@switch:
  git fetch
  git pull --rebase --autostash
  git add -A
  let generation = (nixos-rebuild list-generations --json | from json | get --optional 0.generation | default "unknown"); if (git status --porcelain | is-empty) { echo "Nothing to commit" } else { git commit -m $"NixOS Gen: ($generation) \(pre-switch\)" }
  nixos-rebuild switch --flake . --sudo
  sudo -u sintra just backup

# Upgrade packages and switch the current system
@update:
  git fetch
  git pull --rebase --autostash
  nix flake update
  nixos-rebuild switch --flake . --sudo
  sudo -u sintra just backup

# Download a torrent using rqbit
[positional-arguments]
@torrent path:
  rqbit download --output-folder ~/Downloads --exit-on-finish {{path}}
```

#### Common Automation Workflows:

**1. Rebuilding and Switching Your System** — To apply changes made to your configuration on the local machine:
```bash
just switch
```
*Behind the scenes, this will fetch upstream git changes, rebase and autostash if necessary, stage your local changes, create an automated "pre-switch" commit carrying the current generation number, run `nixos-rebuild switch` as root, and then trigger a final `just backup` as your user to commit and push the completed new generation to your Git repository!*

**2. Upgrading Packages** — To update your flake inputs and upgrade all system & home packages:
```bash
just update
```
*This command pulls the latest package definitions from nixpkgs (unstable) by updating the lock file, compiles and switches the system, and performs an automated Git backup.*

**3. Freeing Up Disk Space (Garbage Collection)** — To delete older, inactive system generations and run garbage collection on the Nix store:
```bash
just cg
```

**4. Torrenting via CLI** — To quickly download files/torrents using the high-performance Rust torrent client `rqbit`:
```bash
just torrent <magnet-url-or-file-path>
```

---

## Secrets Management with SOPS and Age

This repository uses **[SOPS](https://github.com/getsops/sops)** (Secrets OPerationS) combined with **[Age](https://github.com/FiloSottile/age)** and the **[sops-nix](https://github.com/Mic92/sops-nix)** module to manage sensitive data like API keys, passwords, and environment variables declaratively.

Instead of keeping plain-text secrets in your git repository, SOPS encrypts the values while keeping the YAML keys readable. `sops-nix` then securely decrypts them during system activation and loads them into `/run/secrets/`.

### 1. Initial Setup: Generating an Age Key

`Age` is a modern, simple alternative to GPG. You need to generate a private key on your machine to decrypt the secrets.

1. Create the directory for your keys:
   ```bash
   mkdir -p ~/.config/sops/age
   ```
2. Generate the key:
   ```bash
   age-keygen -o ~/.config/sops/age/keys.txt
   ```
   *Note: This command will print your **Public Key** to the terminal. It will look something like `age1...`*

3. **Backup your private key:** The `keys.txt` file contains your private identity. Back it up to a secure password manager or offline storage. If you lose this key, you lose access to decrypt the repository's secrets!

### 2. Configuring `.sops.yaml`

The `.sops.yaml` file at the root of this repository maps which public keys are allowed to decrypt which files.

If you are adding a new machine or a new key, you must add its public key to this file:

```yaml
# .sops.yaml
keys:
  - &sintra_phantom age1your_public_key_here
  - &sintra_wraith age1another_public_key_here
creation_rules:
  - path_regex: secrets.yaml$
    key_groups:
    - age:
      - *sintra_phantom
      - *sintra_wraith
```

#### Adding a New Machine (Multi-Key Setup)

If `secrets.yaml` was already created on another machine (e.g., `phantom`) using its own `age` key, your new machine (e.g., `wraith`) **will not be able to decrypt it** until the original machine grants it access.

Here is the exact process to authorize a new machine:

1. **On the NEW machine:** Generate the `age` key as shown above and copy the **Public Key**.
2. **On the ORIGINAL machine:**
   - Open `.sops.yaml` and add the new machine's public key to the file.
   - Add the new reference to the `creation_rules` block.
   ```yaml
   keys:
     - &sintra_phantom age1original_key_here
     - &sintra_wraith age1newly_generated_public_key_here
   creation_rules:
     - path_regex: secrets.yaml$
       key_groups:
       - age:
         - *sintra_phantom
         - *sintra_wraith
   ```
3. **On the ORIGINAL machine:** Run the following command:
   ```bash
   sops updatekeys secrets.yaml
   ```
   *(This tells SOPS to decrypt the file with the old key, and re-encrypt it to include the new key).*
4. **On the ORIGINAL machine:** Commit and push the updated `.sops.yaml` and `secrets.yaml` to Git.
5. **On the NEW machine:** `git pull`. Your new machine can now successfully decrypt `secrets.yaml`!

### 3. Editing Secrets

To create or edit a secrets file, use the `sops` command. Because `.sops.yaml` is in the root directory, SOPS knows exactly which keys to use for encryption.

```bash
sops secrets.yaml
```

- **What happens:** SOPS decrypts the file into a temporary buffer, opens it in your default terminal editor (`$EDITOR`), and automatically re-encrypts it when you save and exit.
- **If it opens in the wrong editor:** You can temporarily override it:
  ```bash
  EDITOR=nano sops secrets.yaml
  ```

#### Adding New Secrets

Inside `secrets.yaml`, you write standard YAML:
```yaml
hermes-env: |
  GEMINI_API_KEY=AIzaSy...
  OPENAI_API_KEY=sk-...
```

### 4. Using Secrets in NixOS

This repository uses `sops-nix` to securely inject these secrets into your system configuration without putting them in the world-readable `/nix/store`.

In `/system/sops.nix`, we configure the global settings:
```nix
sops = {
  defaultSopsFile = ../secrets.yaml;
  age.keyFile = "/home/sintra/.config/sops/age/keys.txt";

  # Declare the secrets we want to deploy to the system
  secrets."hermes-env" = { format = "yaml"; };
};
```

When you rebuild your system (`just switch`), `sops-nix` decrypts the secret and places it at `/run/secrets/hermes-env` with strict permissions.

You can then pass the path to this secret into systemd services. For example, in `/system/hermes.nix`:
```nix
services.hermes-agent = {
  enable = true;
  # ...
  environmentFiles = [ config.sops.secrets."hermes-env".path ];
};
```

---

## Onboarding a New Machine (Post-Install, Root Only)

This guide covers how to onboard a newly-installed, fresh minimal NixOS system.

It assumes you have completed a standard minimal installation (using the official NixOS minimal ISO), booted into the fresh system for the first time, logged in as the **`root`** user, and have **no normal users created yet**.

Our flake configuration will automatically create and configure your primary user (`sintra`) during the build process.

---

### Phase 1: Creating directories & Cloning

When you first log into your fresh minimal installation as `root`, the system's active configuration is stored in `/etc/nixos`.

#### 1. Backup the Original Configuration

The system has generated a `hardware-configuration.nix` specific to this machine. We must back it up before replacing `/etc/nixos`:
```bash
# Backup the entire default configuration directory
cp -r /etc/nixos /etc/nixos.bak
```

#### 2. Prepare the Home Folder & Clone

Since the `sintra` user does not exist yet, we must manually create their future home folder and clone your configuration repository directly into it using HTTPS:
```bash
# Create the home directory path
mkdir -p /home/sintra

# Clone your configuration repository
git clone https://github.com/VicentePSalcedo/NixOS.git /home/sintra/nixos
```

#### 3. Replace and Symlink `/etc/nixos`

Remove the default configuration directory and symlink `/etc/nixos` to point directly to your newly cloned repository:
```bash
# Remove default config folder
rm -rf /etc/nixos

# Symlink etc/nixos to home folder repo
ln -s /home/sintra/nixos /etc/nixos
```

---

### Phase 2: Creating and Configuring Host Files

We need to register your new hardware configuration and bootloader settings inside your repository.

#### 1. Create the Host Directory

Choose a hostname for your new machine (e.g., `spectre`) and create its directory:
```bash
mkdir -p /home/sintra/nixos/hosts/spectre
```

#### 2. Add the Hardware Configuration

Move the hardware configuration generated by your minimal installation into your new host folder:
```bash
mv /etc/nixos.bak/hardware-configuration.nix /home/sintra/nixos/hosts/spectre/
```

#### 3. Create the `default.nix` Profile

Create a configuration file to glue your hardware specifics to your global system settings:
```bash
nano /home/sintra/nixos/hosts/spectre/default.nix
```

Write the following block based on your machine's bootloader profile:

**Option A: Modern UEFI / GPT Systems (Default)**

Our central configuration (`system/common.nix`) enables the modern `systemd-boot` UEFI bootloader by default. If your new machine is a standard UEFI system, **you do not need to define any bootloader configuration here**. It is inherited automatically:

```nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
    # Optional hardware profiles (uncomment if desired)
    # ../../system/bluetooth.nix
    # ../../system/nvidia.nix
  ];

  networking.hostName = "spectre";
}
```

**Option B: Legacy BIOS / MBR Systems (using GRUB Override)**

If your new machine is an older BIOS/MBR system, you must explicitly disable the default `systemd-boot` configuration inherited from `common.nix` and enable **GRUB** instead using **`lib.mkForce`**:

```nix
{ config, pkgs, inputs, lib, ... }: # Make sure to add 'lib' to arguments

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
    # Optional hardware profiles (uncomment if desired)
    # ../../system/bluetooth.nix
    # ../../system/nvidia.nix
  ];

  networking.hostName = "spectre";

  # Force-override bootloader settings for GRUB (Legacy BIOS/MBR)
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  boot.loader.grub = {
    enable = lib.mkForce true;
    device = "/dev/sda"; # Replace with your target boot disk device (e.g. /dev/sda)
    configurationLimit = 6;
  };
}
```

---

### Phase 3: Registering Host & Permissions

#### 1. Edit `flake.nix`

Open `/home/sintra/nixos/flake.nix` in a text editor:
```bash
nano /home/sintra/nixos/flake.nix
```
Add an entry for your new host under the `nixosConfigurations` block:
```nix
    nixosConfigurations = {
      # ... existing hosts ...

      spectre = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          hermes-agent.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/spectre
        ];
      };
    };
```

#### 2. Stage Changes in Git (CRITICAL)

**Nix Flakes strictly ignore untracked files.** If you attempt to rebuild now, Nix will fail and complain that `hosts/spectre/default.nix` doesn't exist. Add everything to Git:
```bash
git -C /home/sintra/nixos add .
```

#### 3. Assign Ownership (CRITICAL)

Because you cloned the repository as `root`, all files are owned by the `root` user. You must recursively assign ownership of the directory structure to UID `1000` (user `sintra`) and GID `100` (`users` group) so that your normal user will own their home directory once created:
```bash
chown -R 1000:100 /home/sintra
```

---

### Phase 4: Rebuild & Prevent Lockout

#### 1. Rebuild the System

Run the rebuild command targeting your new host definition to download packages, configure the system, and **automatically create the `sintra` user**:
```bash
nixos-rebuild switch --flake /home/sintra/nixos#spectre
```

#### 2. Set the User Password (CRITICAL)

Your configuration declares the `sintra` user with your public SSH keys, but does not specify a password. To prevent being locked out of the local TTY prompt upon reboot, assign a password for `sintra` now:
```bash
passwd sintra
```

#### 3. Reboot

Reboot the system to launch your secure and fully themed Hyprland environment:
```bash
reboot
```

Log in as `sintra` with the password you just set on the TTY1 prompt, and welcome to your new, fully personalized workspace!

---

### Phase 5: Post-Install Configuration (Tailscale, SOPS, SSH)

After rebooting and successfully logging in as `sintra`, you need to configure the networking, secret management, and secure connection parties to fully integrate this node.

#### Part 1: Joining the Tailscale Party

Since Tailscale is enabled globally in our system configuration, the service is already running. To authorize your new machine onto your secure private mesh network (Tailnet):

1. **Authenticate the Node:** Launch the authorization process:
   ```bash
   sudo tailscale up
   ```
2. **Authorize the Link:** Copy the unique URL printed in the terminal, open it in Zen Browser on another active machine, and sign in to approve the device.
3. **Use Tailscale SSH (Optional but highly recommended):** If you want Tailscale to manage and authorize SSH authentications securely over your mesh network automatically, run:
   ```bash
   sudo tailscale up --ssh
   ```

#### Part 2: Configuring SOPS Cryptography

Our configuration utilizes `sops-nix` with Age to secure variables like API keys and passwords in `secrets.yaml`. Because you are on a fresh machine, it will fail to decrypt secrets unless it has access to your Age key.

You have two options to integrate this host into the SOPS environment:

**Option A: Copy Your Existing Master Age Key (Easiest)**
Copy your master `keys.txt` securely from an active machine to the new machine:
```bash
mkdir -p ~/.config/sops/age/
# Copy your master keys.txt securely (e.g. via secure flash drive or Tailscale SSH)
# and place it at: ~/.config/sops/age/keys.txt
```

**Option B: Register a Unique Age Key for the New Machine (Recommended)**
1. Generate a unique Age key on the new machine:
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```
2. Extract its public key:
   ```bash
   age-keygen -y ~/.config/sops/age/keys.txt
   ```
   *(This will output a string starting with `age1...`)*
3. Add the new public key to your repository. On any machine, open the `.sops.yaml` file at the root of the repository and add the new public key under the `age` list:
   ```yaml
   creation_rules:
     - path_regex: secrets.yaml$
       key_groups:
         - age:
             - age1fnle7w46h40zap... # existing key
             - age1cwt78nzh2d625... # existing key
             - age1yournewpublickey... # Add your new machine public key here
   ```
4. Re-encrypt Secrets: From an already-authorized machine (where you can decrypt the secrets), navigate to your repository and run:
   ```bash
   sops updatekeys secrets.yaml
   ```
   Commit and push your changes, pull them on the new machine, and run `sudo nixos-rebuild switch` to activate!

#### Part 3: Registering SSH Keys

To safely connect to your new machine from other nodes (and push commits securely to GitHub), you need to configure a unique SSH identity. **Never share SSH keys across physical machines.**

1. **Generate a Unique SSH Key:** On the new machine, generate a dedicated Ed25519 key:
   ```bash
   ssh-keygen -t ed25519 -C "sintra@spectre"
   ```
2. **Retrieve the Public Key:**
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
3. **Add Key to System Configuration:** Open `/home/sintra/nixos/system/common.nix` and append the new public key to `users.users.sintra.openssh.authorizedKeys.keys`:
   ```nix
   users.users."sintra" = {
     isNormalUser = true;
     # ...
     openssh.authorizedKeys.keys = [
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... wraith"
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... phantom"
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... spectre (your new key)"
     ];
   };
   ```
4. **Add Key to GitHub:** Go to your GitHub Account Settings under **SSH and GPG keys** and add the new public key to allow pushing configurations back to GitHub.
5. **Rebuild & Apply:** Commit the updated `common.nix` and pull it on all your machines, then run `sudo nixos-rebuild switch` to authorize connections!

---

## Highlights & Technical Showcases

### 1. Zero Display-Manager Autostart

To minimize memory footprint and eliminate display manager overhead (such as GDM or SDDM), graphical sessions are initiated directly from `tty1` upon user login. This is handled via a lightweight POSIX shell startup hook declared in `users/sintra/programs/bash.nix`:

```nix
programs.bash = {
  enable = true;
  profileExtra = ''
    # If logging in on tty1 and not already in a graphical session, autostart Hyprland
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      # Exec launch bypasses display managers cleanly
      exec start-hyprland
    fi
  '';
};
```

---

### 2. Autonomous AI Native Integration (Hermes Agent & MCP)

This configuration is built to cooperate with autonomous AI systems natively. Inside `/system/hermes.nix`, the state-of-the-art **Hermes Agent** is declared system-wide as a background service.

#### Critical Architecture Fixes Implemented:

- **Systemd PATH Override & Custom Rust Package Build:** Since Systemd executes services in restricted pathways, core tools like `nix`, `git`, and `nodejs` are dynamically injected into the service environment. Crucially, the service path also injects a custom-compiled and patched Rust helper `rust-analyzer-mcp` (version 0.2.0) to allow the agent to interface with Language Servers:
  ```nix
  systemd.services.hermes-agent.path = [
    pkgs.nix
    pkgs.git
    pkgs.nodejs
    pkgs.rust-analyzer
    (pkgs.rustPlatform.buildRustPackage {
      pname = "rust-analyzer-mcp";
      version = "0.2.0";
      src = pkgs.fetchFromGitHub {
        owner = "zeenix";
        repo = "rust-analyzer-mcp";
        rev = "v0.2.0";
        hash = "sha256-brnzVDPBB3sfM+5wDw74WGqN5ahtuV4OvaGhnQfDqM0=";
      };
      cargoHash = "sha256-7t4bjyCcbxFAO/29re7cjoW1ACieeEaM4+QT5QAwc34=";
      nativeBuildInputs = [ pkgs.pkg-config ];
      doCheck = false;
      # Patch handles a bug in notification IDs
      postPatch = ''
        substituteInPlace src/main.rs \
          --replace-fail 'let response = self.handle_request(request).await;' \
                         'if request.id.is_none() { debug!("Ignoring notification: {}", request.method); continue; } let response = self.handle_request(request).await;'
      '';
    })
  ];
  ```
- **MCP Sandbox Environment Mitigation:** When running Node or Python-based Model Context Protocol (MCP) servers (like `mcp-nixos` or `@modelcontextprotocol/server-github`), the process clears `PYTHONPATH` explicitly to prevent python library collisions between parent agent environments and sandboxed Nix store packages.
- **Declarative Skin Generation & Sync:** To keep user-space TUI sessions and the background system service perfectly synchronized, the repository programmatically generates the matching **TokyoNight Storm** skin YAML file from an inline Nix attribute set using `pkgs.lib.generators.toYAML`. This is written via `pkgs.writeText` and symlinked using a systemd `L+` rule:
  ```nix
  systemd.tmpfiles.rules = let
    themeContent = pkgs.lib.generators.toYAML {} {
      name = "tokyonight-storm";
      colors = {
        banner_border = "#414868";
        banner_title = "#7aa2f7";
        # ...
      };
      branding = { ... };
    };
    themeFile = pkgs.writeText "tokyonight-storm.yaml" themeContent;
  in [
    "d /var/lib/hermes/.hermes/skins 0775 hermes hermes - -"
    "L+ /var/lib/hermes/.hermes/skins/tokyonight-storm.yaml - - - - ${themeFile}"
  ];
  ```

```nix
# system/hermes.nix
services.hermes-agent = {
  enable = true;
  settings = {
    model.default = "gemini-flash-latest";
    model.provider = "gemini";
    display = {
      interface = "tui";
      skin = "tokyonight-storm";
    };
  };
  mcpServers = {
    nixos = {
      command = "nix";
      args = [ "run" "github:utensils/mcp-nixos" "--" ];
      env = { PYTHONPATH = ""; }; # Crucial Python sandbox mitigation
    };
    github = {
      command = "nix";
      args = [ "shell" "nixpkgs#nodejs" "-c" "npx" "-y" "@modelcontextprotocol/server-github" ];
    };
    context7 = {
      command = "nix";
      args = [ "shell" "nixpkgs#nodejs" "-c" "npx" "-y" "@upstash/context7-mcp@latest" ];
    };
    rust-analyzer = {
      command = "rust-analyzer-mcp";
      args = [];
    };
  };
};
```

---

### 3. Bulletproof Hyprland config (Bypassing HM Lua Translation)

Recent versions of Home Manager's Hyprland module (v0.55+) attempt to generate a `.lua` configuration layout using experimental compilers. However, translating standard declarative settings lists often produces invalid Lua output, breaking core compositor features like system keybindings on system rebuild.

To prevent this config drift, this repository adopts a stable, robust hybrid configuration. It disables the Home Manager generator and writes a native, raw `hyprland.conf` directly into user space via `builtins.readFile`. This preserves perfect syntax highlighting, standard formatting, and absolute stability:

```nix
# users/sintra/programs/hyprland/default.nix
{ config, pkgs, ... }: {
  xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ./hyprland.conf;
}
```

---

### 4. Unfree Extensions & Zen Browser Integration via Standalone Firefox Overlay

Managing browser extensions declaratively (such as dark themes, ad blockers, or password managers) often crashes during evaluation if an extension has an "unfree" proprietary license. This occurs even if `allowUnfree` is enabled on the host, because external flake inputs evaluate packages in isolated, sandbox states.

This repository resolves this issue by declaring Robert Helgesson's `firefox-addons` input and grafting it directly onto the host's `nixpkgs.overlays`. This pulls the addon libraries directly into the system's global `pkgs` context, where the system-wide `allowUnfree = true` can successfully validate proprietary licenses:

```nix
# system/nix-settings.nix
{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.firefox-addons.overlays.default # Graft addons into global pkgs
  ];
}
```

This lets us declaratively manage **Zen Browser** (via its custom flake input `inputs.zen-browser`) using the standard `programs.firefox` Home Manager module, while successfully grafting unfree extensions:

```nix
# users/sintra/programs/firefox.nix
{ config, pkgs, inputs, lib, ... }: {
  programs.firefox = {
    enable = true;
    package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      extensions.packages = with pkgs.firefox-addons; [
        dashlane
        darkreader
        vimium
      ];
    };
  };

  # Symlink ONLY the default profile folder to keep profiles.ini fully writable on disk!
  home.file.".config/zen/default".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/mozilla/firefox/default";
};
```

This elegant setup gives us a modern, fast, and secure browser with perfectly synced extensions without a single license evaluation error.
