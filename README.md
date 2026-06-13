# 🌌 Sintra's Modular, Multi-Host NixOS Fleet

[![NixOS](https://img.shields.io/badge/NixOS-26.05-blue.svg?logo=nixos&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/Home_Manager-declarative-orange.svg?logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)
[![Built with Flakes](https://img.shields.io/badge/Nix_Flakes-supported-purple.svg?logo=nixos&logoColor=white)](https://wiki.nixos.org/wiki/Flakes)
[![TokyoNight Storm](https://img.shields.io/badge/Theme-TokyoNight_Storm-7aa2f7.svg?style=flat)](https://github.com/folke/tokyonight.nvim)

> An enterprise-grade, beautifully modularized, multi-host, multi-architecture NixOS flake configuration. This repository manages a heterogeneous fleet of devices ranging from high-performance x86 gaming workstations with discrete GPUs to ultra-lightweight, remote-compiled ARM64 single-board computers (Raspberry Pi 4)—all styled with a cohesive, transparent **TokyoNight Storm** aesthetic.

---

## 🚀 Fleet Overview

This repository uses a single unified Git-tracked Nix Flake to manage multiple physical machines under a shared declarative framework:

| Hostname | Role / Architecture | Graphics / Driver | Bootloader | Highlights |
| :--- | :--- | :--- | :--- | :--- |
| **`phantom`** | Daily Driver Workstation <br>`x86_64-linux` | AMD Radeon RX 580 <br>`amdgpu` + Mesa | `systemd-boot` | GPU accelerated, gaming-optimized, runs local system-wide AI assistant. |
| **`ghost`** | Server / Compile Node <br>`x86_64-linux` | NVIDIA GTX/RTX <br>`nvidia` proprietary | `systemd-boot` | High-performance machine, acts as a distributed SSH build server for low-power nodes. |
| **`wraith`** | Portable Laptop <br>`x86_64-linux` | Integrated Intel/Mesa | `GRUB` | LUKS full-disk encryption, portable configurations, optimized battery profiles. |
| **`pi`** | Headless Server <br>`aarch64-linux` (ARM64) | Headless | `generic-extlinux` | Low-power Raspberry Pi 4. **Distributed Builds** outsource heavy package compilation to `ghost`. |

---

## 📁 Repository Architecture

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
│   ├── ghost/                 # Build Node / NVIDIA Server
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── wraith/                # LUKS Encrypted Laptop
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── pi/                    # Headless Raspberry Pi 4 (aarch64)
│       └── default.nix        # Custom kernel, distributed build client configuration
│
├── system/                    # Shareable, modular system-level service modules
│   ├── bluetooth.nix          # Bluetooth daemon and audio profiles
│   ├── direnv.nix             # Automatic development shell environments
│   ├── docker.nix             # Containerization runtimes
│   ├── gaming.nix             # Steam, GameMode, GameScope optimization blocks
│   ├── gnupg.nix              # GnuPG daemon configuration and pinentry
│   ├── hermes.nix             # System-wide Autonomous AI integration (Hermes Agent)
│   ├── minecraft.nix          # Declarative headless gaming server
│   ├── nix-settings.nix       # Garbage collection, Flakes activation, rycee Firefox overlay
│   ├── nvidia.nix             # NVIDIA proprietary drivers and graphics setup
│   ├── power.nix              # TLP power management for portable devices
│   ├── printing.nix           # CUPS configuration for printing services
│   ├── sops.nix               # SOPS age decryption keys & declarations
│   └── tmux.nix               # Multiplexed terminal setups
│
├── users/                     # Declares home directory layouts & desktop settings
│   └── sintra/
│       ├── home.nix           # Home Manager central directory (imports program blocks)
│       └── programs/          # Flat, native Nix and raw configurations (minimalist)
│           ├── bash.nix       # Display-Manager-less TTY autostart logic
│           ├── nushell.nix    # Nu interactive shell with TokyoNight syntax highlight
│           ├── ghostty.nix    # GPU-accelerated terminal (40% transparent, blurred)
│           ├── helix.nix      # Minimalist text editor (transparent tokyonight theme)
│           ├── starship.nix   # Cross-shell prompt featuring custom powerline glyphs
│           ├── fuzzel.nix     # App launcher styled to TokyoNight Storm
│           ├── librewolf.nix  # Privacy browser with declatively managed extensions
│           ├── yazi.nix       # Terminal file explorer integrated with Helix and Nushell
│           ├── hermes.nix     # User-space AI agent setup and theme sync
│           ├── tokyonight-storm.yaml # Custom skin for AI TUI client
│           ├── hyprland/      # Core window manager folder
│           │   ├── default.nix  # Bypasses buggy Home Manager Lua generation
│           │   └── hyprland.conf # Raw compositor config (Vim-navigation, splits)
│           └── waybar/        # Custom status bar
│               ├── default.nix
│               └── style.css  # Native stylesheet layout
│
└── wallpapers/                # Clean, unified repository assets & high-resolution wallpapers
    ├── tokyonight.png         # Main wallpaper styled to matching desktop theme
    └── 1920x1080.png          # Boot splash graphics (GRUB / Plymouth background)
```

---

## 🛠️ Highlights & Technical Showcases

### 1. ⚡ Zero Display-Manager Autostart
To minimize memory footprint and eliminate display manager overhead (such as GDM or SDDM), graphical sessions are initiated directly from `tty1` upon user login. 
This is handled via a lightweight POSIX shell startup hook declared in `users/sintra/programs/bash.nix`:

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

### 2. 🏗️ Remotely Compiled Raspberry Pi (Distributed Nix Builds)
Compiling large system packages (like Linux kernels or Node.js) on a low-powered Single Board Computer like the Raspberry Pi 4 is incredibly slow and can easily lead to thermal throttling or out-of-memory crashes.

To solve this, `/hosts/pi/default.nix` is configured to use **Distributed Builds**, outsourcing heavy compilation workloads to the high-performance `ghost` workstation over a secure SSH connection, while executing the final package output natively on its ARM64 architecture:

```nix
nix.buildMachines = [
  {
    hostName = "ghost";
    systems = [ "x86_64-linux" "aarch64-linux" ]; # Ghost is configured as a multi-arch builder
    protocol = "ssh-ng";
    maxJobs = 8;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  }
];
nix.distributedBuilds = true;
nix.settings.builders-use-substitutes = true; # Re-use compiled binaries locally where possible
```

---

### 3. 🤖 Autonomous AI Native Integration (Hermes Agent & MCP)
This fleet is built to cooperate with autonomous AI systems natively. Inside `/system/hermes.nix`, the state-of-the-art **Hermes Agent** is declared system-wide as a background service.

#### Critical Architecture Fixes Implemented:
* **Systemd PATH Override:** Since Systemd executes services in restricted pathways, core tools like `nix`, `git`, and `nodejs` are dynamically injected into the service environment via `systemd.services.hermes-agent.path`.
* **MCP Sandbox Environment Mitigation:** When running Node or Python-based Model Context Protocol (MCP) servers (like `mcp-nixos` or `@modelcontextprotocol/server-github`), the process clears `PYTHONPATH` explicitly to prevent python library collisions between parent agent environments and sandboxed Nix store packages.
* **Declarative Skin Sync:** The configuration utilizes `systemd.tmpfiles.rules` to mirror the user's local TokyoNight Storm skin configuration directly into the system-wide service directory, keeping the TUI interface synced on both user and system layers.

```nix
services.hermes-agent = {
  enable = true;
  settings = {
    model.default = "gemini-flash-latest";
    display = {
      interface = "tui";
      skin = "tokyonight-storm";
    };
  };
  mcpServers.nixos = {
    command = "nix";
    args = [ "run" "github:utensils/mcp-nixos" "--" ];
    env = { PYTHONPATH = ""; }; # Crucial Python sandbox mitigation
  };
};

# Inject binaries directly into the service environment path
systemd.services.hermes-agent.path = [ pkgs.nix pkgs.git pkgs.nodejs ];
```

---

### 4. 🧭 Bulletproof Hyprland config (Bypassing HM Lua Translation)
Recent versions of Home Manager's Hyprland module (v0.55+) attempt to generate a `.lua` configuration layout using experimental compilers. However, translating standard declarative settings lists often produces invalid Lua output, breaking core compositor features like system keybindings on system rebuild.

To prevent this config drift, this repository adopts a stable, robust hybrid configuration. It disables the Home Manager generator and writes a native, raw `hyprland.conf` directly into user space via `builtins.readFile`. This preserves perfect syntax highlighting, standard formatting, and absolute stability:

```nix
# users/sintra/programs/hyprland/default.nix
{ config, pkgs, ... }: {
  xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ./hyprland.conf;
}
```

---

### 5. 🦊 Unfree Extensions via Standalone Firefox Overlay
Managing browser extensions declaratively (such as dark themes, ad blockers, or password managers) often crashes during evaluation if an extension has an "unfree" proprietary license. This occurs even if `allowUnfree` is enabled on the host, because external flake inputs evaluate packages in isolated, sandbox states.

This repository resolves this issue by declaring Robert Helgesson's `firefox-addons` input and grafting it directly onto the host's `nixpkgs.overlays`. This pulls the addon libraries directly into the system's global `pkgs` context, where the system-wide `allowUnfree = true` can successfully validate proprietary licenses:

```nix
# system/nix-settings.nix
{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.firefox-addons.overlays.default # Graftaddons into global pkgs
  ];
}
```
This lets you declaratively list any extensions inside Home Manager (e.g., `programs.librewolf.profiles.default.extensions.packages = with pkgs.firefox-addons; [ dashlane DarkReader vimium ];`) without a single evaluation warning.

---

## 📖 NixOS Crash Course (For Beginners)

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
  @git commit -m "NixOS Gen: {{generation}}"
  @git push

# Collect garbage and delete older generations
cg:
  @sudo nix-collect-garbage --delete-old

# Rebuild and switch a host (defaults to current host, appends --impure for "pi")
switch host="":
  @git fetch
  @git pull
  @nixos-rebuild switch --flake .{{ if host == "" { "" } else { "#" + host } }} --sudo {{ if host == "pi" { "--impure" } else { "" } }}
  @just backup
```

### 🛠️ Common Automation Workflows:

#### 1. Rebuilding and Switching Your System
To apply changes made to your configuration on the local machine:
```bash
just switch
```
*Behind the scenes, this will pull updates, compile your configuration, switch your system live, extract the new generation number, stage all changed files in Git, make a commit with the generation number, and push it back to your repository automatically.*

#### 2. Rebuilding a Remote/Specific Host
To compile and test changes for a remote node (for example, the `pi` server):
```bash
just switch pi
```

#### 3. Freeing Up Disk Space (Garbage Collection)
To delete older, inactive system generations and run garbage collection on the Nix store:
```bash
just cg
```

---

## 📋 Bootstrapping & Setup Guide

Want to use this repository as a baseline for your own modular multi-host setup? Follow these steps:

### Phase 1: Installation & Key Generation
1. Install NixOS on your target machine using any standard ISO installer. Choose `systemd-boot` as your bootloader if you are on UEFI.
2. In your home directory, initialize a GPG or SSH key. If you are using secrets management, generate an `age` key:
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```
3. Extract your public key from that file to reference in your `.sops.yaml` configuration.

### Phase 2: Cloning the Repository
1. Clone this repository directly into your home folder:
   ```bash
   git clone https://github.com/your-username/nixos-config.git ~/nixos
   ```
2. Symlink your local directory to the system configuration root:
   ```bash
   sudo ln -s /home/sintra/nixos /etc/nixos
   ```
   *(On NixOS, the default rebuild tool looks inside `/etc/nixos/flake.nix` by default. Symlinking it to your home directory lets you edit, compile, and run git operations seamlessly without root privilege warnings!)*

### Phase 3: Building and Activating
1. Run a dry run build to verify your local host compiles correctly:
   ```bash
   nixos-rebuild build --flake ~/nixos#phantom
   ```
2. Once the dry run compiles successfully, apply the configuration live:
   ```bash
   sudo nixos-rebuild switch --flake ~/nixos#phantom
   ```
3. Reboot your system and enjoy a beautiful, TokyoNight Storm workspace!
