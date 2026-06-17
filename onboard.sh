#!/usr/bin/env bash

# Onboarding Script for Sintra's NixOS Repository
# Designed to run inside the custom NixOS live installer environment.
# Wipes, partitions, formats the disk, generates hardware config,
# registers the new host in the Flake, and installs the OS.

set -euo pipefail

# 1. Verification & Safety Checks
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run this script with sudo or as root." >&2
  exit 1
fi

echo "=========================================================="
echo "🛡️  Sintra's NixOS Installer & Onboarding Assistant"
echo "=========================================================="
echo ""

# 2. Ask for the New Hostname
read -rp "➡️  Enter the hostname for the new machine: " HOSTNAME
if [[ ! "$HOSTNAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "❌ Error: Invalid hostname. Use alphanumeric characters, dashes, and underscores only." >&2
  exit 1
fi

# 3. Choose the Disk to Partition
echo ""
echo "💾 Available storage devices:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS -d | grep -E "disk"

echo ""
read -rp "➡️  Enter the name of the disk to install NixOS on (e.g. nvme0n1, sda): " DISK_NAME

DISK_PATH="/dev/$DISK_NAME"

if [ ! -b "$DISK_PATH" ]; then
  echo "❌ Error: /dev/$DISK_NAME is not a valid block device." >&2
  exit 1
fi

echo ""
echo "⚠️  WARNING: ALL DATA ON $DISK_PATH WILL BE COMPLETELY WIPED! ⚠️"
read -rp "Are you absolutely sure you want to continue? (type 'YES' to proceed): " CONFIRM
if [ "$CONFIRM" != "YES" ]; then
  echo "❌ Aborting installation."
  exit 1
fi

# 4. Partitioning & Formatting
echo ""
echo "🛠️  Partitioning $DISK_PATH..."

# Create a fresh GPT partition table
parted "$DISK_PATH" -- script mktable gpt

# Create EFI boot partition (512MB)
parted "$DISK_PATH" -- script mkpart ESP fat32 1MiB 513MiB
parted "$DISK_PATH" -- script set 1 esp on

# Create root partition (rest of disk)
parted "$DISK_PATH" -- script mkpart primary ext4 513MiB 100%

# Define partition paths depending on disk type (nvme vs sd)
if [[ "$DISK_NAME" =~ ^nvme ]]; then
  BOOT_PART="${DISK_PATH}p1"
  ROOT_PART="${DISK_PATH}p2"
else
  BOOT_PART="${DISK_PATH}1"
  ROOT_PART="${DISK_PATH}2"
fi

# Wait for kernel to register partition changes
sleep 2

echo "🧹 Formatting partitions..."
mkfs.fat -F 32 -n boot "$BOOT_PART"
mkfs.ext4 -F -L nixos "$ROOT_PART"

# 5. Mount the Filesystem
echo "📂 Mounting filesystems..."
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$BOOT_PART" /mnt/boot

# 6. Generate hardware-configuration.nix
echo "⚙️  Generating hardware configuration..."
mkdir -p /mnt/etc/nixos
nixos-generate-config --root /mnt

# 7. Clone the Repository
echo "📥 Setting up NixOS Flake Repository..."
mkdir -p /mnt/home/sintra
REPO_DIR="/mnt/home/sintra/nixos"

# Check if we can reach Github
if curl -s --head https://github.com > /dev/null; then
  echo "✅ Internet connection detected. Cloning repository..."
  # Use HTTPS if SSH is not set up, or SSH if keys are forwarded.
  # Let's prompt or attempt to clone with agent forwarding.
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    git clone git@github.com:VicentePSalcedo/NixOS.git "$REPO_DIR"
  else
    echo "⚠️  SSH agent forwarding not active. Cloning via HTTPS (read-only)..."
    git clone https://github.com/VicentePSalcedo/NixOS.git "$REPO_DIR"
  fi
else
  echo "❌ Error: No internet connection. Please connect to Wi-Fi first using 'nmcli'." >&2
  exit 1
fi

# Set proper ownership for the home directory and repo so 'sintra' user can use it immediately
chown -R 1000:100 /mnt/home/sintra

# 8. Create Host Directory and copy Hardware Config
echo "📂 Creating host profile for '$HOSTNAME'..."
HOST_DIR="$REPO_DIR/hosts/$HOSTNAME"
mkdir -p "$HOST_DIR"

# Copy generated hardware config to the host directory
cp /mnt/etc/nixos/hardware-configuration.nix "$HOST_DIR/hardware-configuration.nix"

# Create default.nix for the new host
cat <<EOF > "$HOST_DIR/default.nix"
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
  ];

  networking.hostName = "$HOSTNAME";

  # Custom host-specific configuration can go here.
}
EOF

# 9. Register the Host in flake.nix
echo "📝 Registering '$HOSTNAME' inside flake.nix..."
FLAKE_FILE="$REPO_DIR/flake.nix"

# Write the new host config block to a temporary file
cat <<EOF > /tmp/host_block.txt
      $HOSTNAME = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          hermes-agent.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/$HOSTNAME
        ];
      };
EOF

# Insert the host block right after 'nixosConfigurations = {'
sed -i "/nixosConfigurations = {/r /tmp/host_block.txt" "$FLAKE_FILE"

# Clean up the temporary file
rm -f /tmp/host_block.txt

# 10. Start NixOS Installation
echo "🚀 Beginning NixOS installation. This will build your entire system!"
nixos-install --flake "$REPO_DIR#$HOSTNAME" --root /mnt

echo "=========================================================="
echo "🎉 SUCCESS! NixOS has been installed on '$HOSTNAME'."
echo "=========================================================="
echo "You can now reboot. Upon boot, log in as 'sintra'."
echo "Your entire user workspace, theme, and programs are ready!"
echo "=========================================================="
EOF
