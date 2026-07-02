# 🚀 Onboarding a New Machine

This guide covers the exact process of integrating a fresh machine into this NixOS flake configuration. 

This assumes you have just completed the standard installation using the NixOS graphical installer (or standard minimal ISO) and selected the **"No Desktop" (console-only)** option, and have created your primary user (`sintra`).

---

## Phase 1: Post-Install Prep & Backups

When you first log into your new console-only NixOS installation, the system has generated a default configuration specifically for your hardware located in `/etc/nixos`.

### 1. Backup the Original Configuration
Before we replace the system configuration with our flake, we need to back up the original files. The most critical file is `hardware-configuration.nix`, which tells NixOS how to mount your disks and which kernel modules your hardware needs.

```bash
# Backup the entire nixos configuration directory
sudo cp -r /etc/nixos /etc/nixos.bak

# Copy your specific hardware configuration to your home folder for easy access
cp /etc/nixos/hardware-configuration.nix ~/hardware-configuration.nix
```

---

## Phase 2: Cloning & Symlinking the Repository

We want our configuration to live in our user's home directory so we can edit it without needing `sudo` every time, while still letting the system rebuild commands find it.

### 1. Clone the Repository
Clone the configuration repository directly into your home folder. 
*(Note: We use the public HTTPS link to avoid cloning errors if your SSH keys are not yet set up on GitHub for this new machine)*:
```bash
git clone https://github.com/VicentePSalcedo/NixOS.git ~/nixos
cd ~/nixos
```

### 2. Replace and Symlink `/etc/nixos`
NixOS commands (like `nixos-rebuild`) look at `/etc/nixos` by default. We will delete the default folder and create a symlink pointing to your new repository.

```bash
# Remove the default configuration directory
sudo rm -rf /etc/nixos

# Symlink your repository to /etc/nixos
sudo ln -s /home/sintra/nixos /etc/nixos
```
*(Now, whenever the system looks for its configuration, it will seamlessly read from `~/nixos`)*.

---

## Phase 3: Creating the New Host Files

Your repository is now set up, but it doesn't know about this new machine yet. We need to create a dedicated folder for it, copy over its hardware specifics, and declare its bootloader.

### 1. Create the Host Directory
Pick a name for your new machine (e.g., `spectral`) and create its directory:
```bash
mkdir -p ~/nixos/hosts/spectral
```

### 2. Add the Hardware Configuration
Move the hardware configuration you backed up earlier into this new directory:
```bash
mv ~/hardware-configuration.nix ~/nixos/hosts/spectral/
```

### 3. Create the `default.nix` Configuration
Now, create a `default.nix` file in the same folder. This file glues your hardware configuration to the rest of our global system settings.

```bash
nano ~/nixos/hosts/spectral/default.nix
```

Since bootloader configurations are managed per-host (allowing some machines to use UEFI and older machines to use legacy BIOS/MBR), write your configuration based on the machine's hardware mode:

#### Option A: Modern UEFI Systems (e.g., Laptops/Desktops)
If the machine supports UEFI and has an EFI system partition, use **systemd-boot**:

```nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
    # Optional hardware profiles (uncomment if needed)
    # ../../system/bluetooth.nix
    # ../../system/nvidia.nix
  ];

  networking.hostName = "spectral";

  # Bootloader configurations (UEFI systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 6;
  boot.loader.timeout = 7;
  boot.loader.efi.canTouchEfiVariables = true;
}
```

#### Option B: Legacy BIOS / MBR Systems (No UEFI)
If the machine is older and requires a Master Boot Record (MBR) bootloader, use **GRUB** and point it to your primary boot block device (e.g., `/dev/sda`):

```nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
    # Optional hardware profiles (uncomment if needed)
    # ../../system/bluetooth.nix
    # ../../system/nvidia.nix
  ];

  networking.hostName = "spectral";

  # Bootloader configurations (Legacy BIOS/MBR with GRUB)
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda"; # Specify your target boot disk here
    configurationLimit = 6;
  };
}
```

---

## Phase 4: Updating the Flake

Now we must tell the central `flake.nix` file that this new machine exists and how to build it.

### 1. Edit `flake.nix`
Open `~/nixos/flake.nix` in your text editor. 

Find the `nixosConfigurations = { ... }` block and add a new entry for your machine. It should look like this:

```nix
    nixosConfigurations = {
      # ... existing hosts ...

      spectral = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          hermes-agent.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/spectral  # Points to the directory we just created!
        ];
      };
    };
```

### 2. Track the New Files in Git
⚠️ **CRITICAL STEP:** Nix flakes will *completely ignore* files that are not tracked by Git. If you try to rebuild now, Nix will fail and complain that `hosts/spectral/default.nix` doesn't exist.

Add the new files to git:
```bash
cd ~/nixos
git add flake.nix
git add hosts/spectral/
```

---

## Phase 5: Rebuild and Activate!

With the files tracked and the flake updated, you are ready to apply the configuration.

### 1. Run the Rebuild Command
Execute the switch command. Because we symlinked `/etc/nixos`, the command knows exactly where to look.

```bash
sudo nixos-rebuild switch --flake ~/nixos#spectral
```

*Note: The first run will take a while as it downloads all the packages, window managers, and themes defined in the flake.*

### 2. Reboot into Your Desktop
Once the rebuild finishes successfully, reboot your computer:
```bash
reboot
```

Upon logging back in at the `tty1` prompt as your user, your system will automatically launch the Hyprland desktop environment, fully themed and configured! Welcome to your new workspace.
