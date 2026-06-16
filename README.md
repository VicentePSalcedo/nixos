# 🌌 Sintra's Modular NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-26.05-blue.svg?logo=nixos&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/Home_Manager-declarative-orange.svg?logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)
[![Built with Flakes](https://img.shields.io/badge/Nix_Flakes-supported-purple.svg?logo=nixos&logoColor=white)](https://wiki.nixos.org/wiki/Flakes)
[![TokyoNight Storm](https://img.shields.io/badge/Theme-TokyoNight_Storm-7aa2f7.svg?style=flat)](https://github.com/folke/tokyonight.nvim)

> An enterprise-grade, beautifully modularized NixOS flake configuration. This repository manages Sintra's workstation styled with a cohesive, transparent **TokyoNight Storm** aesthetic.

---

## 🚀 Host Overview

This repository uses a single unified Git-tracked Nix Flake to manage the physical machine under a shared declarative framework:

| Hostname | Role / Architecture | Graphics / Driver | Bootloader | Highlights |
| :--- | :--- | :--- | :--- | :--- |
| **`phantom`** | Daily Driver Workstation <br>`x86_64-linux` | AMD Radeon RX 580 <br>`amdgpu` + Mesa | `systemd-boot` | GPU accelerated, gaming-optimized, runs local system-wide AI assistant. |
| **`wraith`** | Portable Laptop <br>`x86_64-linux` | Integrated Graphics | `systemd-boot` | Portable laptop setup, fully syncs data with Phantom, supports backlight/brightness controls via Hyprland. |

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
├── docs/                      # Detailed documentation
│   ├── architecture.md        # Detailed breakdown of repository structure
│   ├── crash-course.md        # NixOS basics and automation workflows
│   ├── onboarding-new-machine.md # Guide to onboarding new hosts
│   ├── secrets-management.md  # Guide to setting up and managing encrypted secrets
│   └── technical-showcases.md # Architecture deep-dives and technical fixes
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
│   ├── ssh.nix                # SSH daemon configurations
│   ├── syncthing.nix          # System-level Syncthing configurations
│   ├── tailscale.nix          # Tailscale mesh VPN daemon
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

## 📚 Documentation

To keep this overview clean, detailed guides and technical deep-dives have been moved to the `docs/` folder.

* **[📐 Repository Architecture](./docs/architecture.md):** Detailed breakdown of how the repository is structured, including separation of concerns between system, host, and user modules.
* **[🚀 Onboarding a New Machine](./docs/onboarding-new-machine.md):** An excruciatingly detailed, step-by-step guide on how to provision a brand new physical machine, partition its disks, integrate it into this flake, setup SOPS secrets, and deploy this NixOS configuration from a Live USB.
* **[🔐 Secrets Management](./docs/secrets-management.md):** Guide on setting up and managing encrypted secrets, API keys, and passwords using `sops`, `age`, and `sops-nix`.
* **[📖 NixOS Crash Course & Automation](./docs/crash-course.md):** A beginner-friendly introduction to NixOS, Flakes, Home Manager, and our automated `just` workflows (like rebuilding, garbage collection, and git backups).
* **[🛠️ Technical Showcases & Architecture Fixes](./docs/technical-showcases.md):** Deep dives into how we achieved zero display-manager autostart, native autonomous AI integration (Hermes Agent & MCP), bulletproof Hyprland config bypasses, and unfree Firefox extension overlays.
