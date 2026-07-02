# 🚀 Onboarding a New Machine

This guide covers the exact process of integrating a fresh machine into this NixOS flake configuration. 

This assumes you have just completed the standard installation using the NixOS graphical installer and selected the **"No Desktop" (console-only)** option, and have created your primary user (e.g., `sintra`).

---

## ⚡ Automated Onboarding (Recommended)

To make onboarding seamless, you can use the interactive `onboard.sh` script included in this repository. It automates backing up your current configuration, symlinking `/etc/nixos` to your cloned repo, prompting you for machine-specific features (like Bluetooth and Nvidia drivers), registering the new host in `flake.nix`, staging changes in git, and running the initial rebuild.

### 1. Clone the repository
Log into your new minimal installation and clone the configuration repository into your home directory:
```bash
git clone https://github.com/your-username/nixos-config.git ~/nixos
cd ~/nixos
```

### 2. Run the onboarding script
Make the script executable (if it isn't already) and run it with `sudo`:
```bash
chmod +x onboard.sh
sudo ./onboard.sh
```

Follow the interactive prompts to define your new hostname, configure hardware features (Nvidia/Bluetooth), and optionally trigger the initial rebuild automatically!

---

## 📖 Manual Onboarding (Reference)

If you prefer to perform the onboarding steps manually, follow the phases below.

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
Clone the configuration repository directly into your home folder:
```bash
git clone https://github.com/your-username/nixos-config.git ~/nixos
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

Your repository is now set up, but it doesn't know about this new machine yet. We need to create a dedicated folder for it and copy over its hardware specifics.

### 1. Create the Host Directory
Pick a name for your new machine (e.g., `new-host`) and create its directory:
```bash
mkdir -p ~/nixos/hosts/new-host
```

### 2. Add the Hardware Configuration
Move the hardware configuration you backed up earlier into this new directory:
```bash
mv ~/hardware-configuration.nix ~/nixos/hosts/new-host/
```

### 3. Create the `default.nix` Configuration
Now, create a `default.nix` file in the same folder. This file glues your hardware configuration to the rest of our global system settings.

```bash
nano ~/nixos/hosts/new-host/default.nix
```
Add the following content:
```nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
  ];

  # Set the machine's hostname here
  networking.hostName = "new-host";
  
  # Note: Add any machine-specific hardware overrides here 
  # (e.g., specific graphics drivers if it has an Nvidia GPU)
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

      new-host = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          hermes-agent.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/new-host  # Points to the directory we just created!
        ];
      };
    };
```

### 2. Track the New Files in Git
**Crucial Step:** Nix flakes will *completely ignore* files that are not tracked by Git. If you try to rebuild now, Nix will complain that `hosts/new-host/default.nix` doesn't exist.

Add the new files to git:
```bash
cd ~/nixos
git add flake.nix
git add hosts/new-host/
```

---

## Phase 5: Rebuild and Activate!

With the files tracked and the flake updated, you are ready to apply the configuration.

### 1. Run the Rebuild Command
Execute the switch command. Because we symlinked `/etc/nixos`, the command knows exactly where to look.

```bash
sudo nixos-rebuild switch --flake ~/nixos#new-host
```

*Note: The first run will take a while as it downloads all the packages, window managers, and themes defined in the flake.*

### 2. Reboot into Your Desktop
Once the rebuild finishes successfully, reboot your computer:
```bash
reboot
```

Upon logging back in at the `tty1` prompt as your user, your system will automatically launch the Hyprland desktop environment, fully themed and configured! Welcome to your new workspace.
