# 🏛️ Architecture & Design Document

This document outlines the architectural blueprints, structural rules, and design philosophies underpinning this NixOS configuration repository. It is intended for developers, system administrators, and technical users who want to understand the *why* behind the repository's layout, boundaries, and technical decisions.

---

## 🧭 Core Design Philosophies

This configuration repository is designed around three fundamental pillars:

1. **Reprodubicitly First**: Every host, application, configuration, and environment variable must be declared in code. If it cannot be declared, it should be isolated and automated.
2. **Minimalist Cohesion**: Avoid redundant directories, nested boilerplate, and complex file nesting. Prefer a flat, readable file layout wherever possible.
3. **Decoupled User-System Boundary**: The operating system layer (managed by NixOS) and the user environment layer (managed by Home Manager) should be clearly separated, but harmonized through unified styling and configuration overlays.

---

## 🗺️ System & User Boundary Matrix

To maintain a clean boundary, the repository enforces a strict rule set on where configurations are declared:

```text
┌────────────────────────────────────────────────────────┐
│                      FLAKE.NIX                         │
│             (Unified Flake Entrypoint)                 │
└──────────────────────────┬─────────────────────────────┘
                           │
             ┌─────────────┴─────────────┐
             ▼                           ▼
 ┌──────────────────────┐    ┌──────────────────────┐
 │       SYSTEMS        │    │    USER WORKSPACE    │
 │ (Root: sudo privileges)│   │ (Root: user-space)   │
 ├──────────────────────┤    ├──────────────────────┤
 │  • Kernel & Boot     │    │  • Window Manager    │
 │  • Hardware Drivers  │    │  • Terminal Shells   │
 │  • Docker & Runtimes │    │  • User CLI Utilities│
 │  • System Daemons    │    │  • Browsers & Clients│
 │  • PAM & Users       │    │  • Custom User Themes│
 └──────────────────────┘    └──────────────────────┘
```

### 1. The System Layer (`system/` and `hosts/`)
The system layer is responsible for low-level configuration, hardware-specific drivers, security protocols, and system-wide services.
* **Imports Rule:** Hosts under `hosts/<hostname>/default.nix` import shared modules under `system/` (such as `sops.nix`, `gaming.nix`, `bluetooth.nix`) and declare host-specific details (such as the computer's hostname, users, bootloaders, and state version).
* **Relative Path Standard:** Because files are modularized, all relative path imports must scale correctly. Files in `hosts/` use `../../system/` prefix, while files in `system/` reference global root assets using `../` (e.g. referencing `secrets.yaml` inside `system/sops.nix` as `defaultSopsFile = ../secrets.yaml;`).

### 2. The User Layer (`users/sintra/`)
The user layer manages user-space programs, dotfiles, application settings, styling, and personal terminal workflows via **Home Manager**.
* **Single-File Preference:** Unless a program requires multiple complex nested assets or custom scripts (like Waybar with its stylesheet), **we always prefer a single-file configuration** directly under `programs/` (e.g., `programs/starship.nix`, `programs/fastfetch.nix`) rather than creating a nested folder with a `default.nix`.
* **Declarative Settings Block:** We prioritize declaring application settings natively inside Nix using standard attribute sets (e.g., `programs.starship.settings = { ... }` or `programs.helix.settings = { ... }`) instead of writing raw config files. This maintains maximum coherence and type safety within the Nix evaluator.
* **Raw Config Fallback:** When a program's Nix translator is experimental or buggy (such as Hyprland's Lua generation), we bypass the translator and load a raw config file using `builtins.readFile` to ensure 100% stable execution.

---

## 🔒 Secrets Management Layout

Secrets (API tokens, private configuration files, private keys) are fully encrypted and committed directly to Git using **SOPS-nix** and **age**. 

```text
                  ┌──────────────────────┐
                  │    secrets.yaml      │  <── Encrypted with Age Public Key
                  └──────────┬───────────┘      (Safe to commit to Git)
                             │
                             ▼
┌────────────────────────────────────────────────────────┐
│                    system/sops.nix                     │
│  (Loads secrets using local private key at boot time)  │
└────────────────────────────┬───────────────────────────┘
                             │
                             ▼
        /run/secrets/hermes-env (Decrypted RAM FS)
                             │
                             ▼
           Injected into services.hermes-agent
```

### Key Management Policies:
* The encrypted file `secrets.yaml` sits at the root of the repository.
* The public age keys are registered inside a root `.sops.yaml` file to determine encryption targets.
* The private decryption key is kept at `/home/sintra/.config/sops/age/keys.txt` (or `/var/lib/sops-nix/key` depending on the machine). This file is **strictly excluded** from Git via `.gitignore`.
* At boot time, the system uses the private key to decrypt the secrets into a secure RAM filesystem (`/run/secrets/`), which is only readable by system daemons or users in the `wheel`/`hermes` groups. This prevents secrets from ever touching disk in plain text.

---

## 🤖 AI-Agent Co-operation & Boundary Design

This repository is optimized for autonomous AI operations (e.g. using Hermes Agent). To prevent system collisions and compilation bottlenecks in sandboxed agent sessions, several custom system boundaries are established:

### 1. System-wide Hermes Daemon
Rather than running an AI assistant purely in a user session, `services.hermes-agent` runs as a systemd system service.
* **The Permission Bypass:** The system user `sintra` is added to the `hermes` group. Because system-wide Hermes state files are owned by the `hermes` group with group-write permissions (0775), the user can modify skins and settings without needing `sudo` access.
* **Systemd PATH Isolation Fix:** Background systemd services start with an extremely bare environment lacking core packages. To let the agent run nix builds or git clones, we inject compile binaries directly into the service path:
  ```nix
  systemd.services.hermes-agent.path = [ pkgs.nix pkgs.git pkgs.nodejs ];
  ```
* **Skin Mirroring:** To synchronize the TokyoNight Storm theme between user-space terminal sessions and the system-wide daemon, we deploy custom skins natively via `systemd.tmpfiles.rules`:
  ```nix
  systemd.tmpfiles.rules = [
    "d /var/lib/hermes/.hermes/skins 0775 hermes hermes - -"
    "f+ /var/lib/hermes/.hermes/skins/tokyonight-storm.yaml 0664 hermes hermes - ${builtins.readFile ../users/sintra/programs/tokyonight-storm.yaml}"
  ];
  ```

---

## 📡 Distributed Build Network Topology

To keep compile times short on minimal single-board ARM computers (e.g. Raspberry Pi 4), the fleet utilizes distributed compilation. 

```text
   ┌──────────────────────────────────────────────────┐
   │                  Raspberry Pi                    │
   │               (aarch64-linux)                    │
   └───────────────────────┬──────────────────────────┘
                           │  Nix Build Protocol
                           │  (via secure SSH-ng)
                           ▼
   ┌──────────────────────────────────────────────────┐
   │                ghost Compile Node                │
   │            (x86_64-linux & aarch64)              │
   └──────────────────────────────────────────────────┘
```

1. **Initiation:** The Raspberry Pi triggers a system rebuild (e.g., `just switch` or `nixos-rebuild switch`).
2. **Analysis:** The Nix package manager evaluates the local configuration, checks which packages need to be compiled, and notices that the compile load exceeds local speed thresholds.
3. **Delegation:** The Pi transfers the target packages' source code to `ghost` over SSH.
4. **Execution:** `ghost` compiles the package natively (or using binfmt emulation if compiling for ARM). Since `ghost` has a high-performance CPU with parallel cores, compilation finishes in seconds.
5. **Retrieval:** The compiled binaries are transferred back to the Pi's `/nix/store/` and executed live.

---

## 🎮 GPU Acceleration & Performance Profiles

Different physical hosts in the fleet leverage customized graphics driver architectures:

* **AMD Graphics (`phantom`, laptop):** Utilizes the open-source `amdgpu` kernel module and userspace Mesa libraries. Under NixOS 24.11 and newer, hardware acceleration is enabled cleanly under the `hardware.graphics` subsystem:
  ```nix
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Wine/Steam 32-bit gaming runtimes
  };
  ```
* **NVIDIA Graphics (`ghost`):** Utilizes NVIDIA's proprietary driver package. Modesetting is forced to support stable Wayland rendering inside Hyprland:
  ```nix
  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Proprietary blobs provide better 3D performance on legacy cards
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  ```
* **Gaming Optimizations:** System modules like `gaming.nix` configure the kernel to support dynamic process prioritization (`gamemode`) and low-latency compositor isolation (`gamescope`), allowing games to run with high thread priority and zero window-manager lag.
