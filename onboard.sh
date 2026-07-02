#!/usr/bin/env bash

# Safe-guards and configuration
set -euo pipefail

# Text formatting helper functions
info() { echo -e "\e[34m[INFO]\e[0m $*"; }
warn() { echo -e "\e[33m[WARN]\e[0m $*"; }
error() { echo -e "\e[31m[ERROR]\e[0m $*"; exit 1; }
success() { echo -e "\e[32m[SUCCESS]\e[0m $*"; }

# 1. Assert running as root (required for /etc/nixos manipulation and rebuilds)
if [ "$EUID" -ne 0 ]; then
  error "This script must be run as root or with sudo. Try: sudo ./onboard.sh"
fi

# Detect actual user to maintain proper home directory mapping and file permissions
REAL_USER="${SUDO_USER:-$USER}"
if [ "$REAL_USER" = "root" ]; then
  # If direct root without SUDO_USER, default to 'sintra'
  REAL_USER="sintra"
fi
REAL_HOME=$(eval echo "~$REAL_USER")
info "Detected user: $REAL_USER (Home: $REAL_HOME)"

# 2. Locate the NixOS configuration repository
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/flake.nix" ]; then
  REPO_DIR="$SCRIPT_DIR"
else
  REPO_DIR="$REAL_HOME/nixos"
fi

info "Using repository directory: $REPO_DIR"
if [ ! -d "$REPO_DIR" ]; then
  error "Could not find your NixOS configuration directory at $REPO_DIR. Please ensure it is cloned there."
fi

# 3. Locate or generate hardware-configuration.nix
TEMP_HW_CONF="/tmp/onboard-hardware-configuration.nix"
rm -f "$TEMP_HW_CONF"

if [ -f "/etc/nixos/hardware-configuration.nix" ] && [ ! -L "/etc/nixos" ]; then
  info "Found existing hardware-configuration.nix at /etc/nixos"
  cp "/etc/nixos/hardware-configuration.nix" "$TEMP_HW_CONF"
elif [ -f "$REAL_HOME/hardware-configuration.nix" ]; then
  info "Found hardware-configuration.nix in home folder"
  cp "$REAL_HOME/hardware-configuration.nix" "$TEMP_HW_CONF"
else
  warn "No existing hardware-configuration.nix found. Generating one using nixos-generate-config..."
  nixos-generate-config --show-hardware-config > "$TEMP_HW_CONF" || error "Failed to generate hardware configuration."
fi

# 4. Handle Symlinking of /etc/nixos
if [ ! -L "/etc/nixos" ]; then
  info "Preparing /etc/nixos backup and symlink..."
  if [ -d "/etc/nixos" ]; then
    sudo cp -r /etc/nixos /etc/nixos.bak
    info "Backed up /etc/nixos to /etc/nixos.bak"
  fi
  sudo rm -rf /etc/nixos
  sudo ln -s "$REPO_DIR" /etc/nixos
  success "Symlinked /etc/nixos -> $REPO_DIR"
else
  info "/etc/nixos is already a symlink: $(readlink -f /etc/nixos)"
fi

# 5. Prompt for the new Hostname
echo ""
read -rp "Enter the hostname for this new machine (e.g., wraith-pro, spectral): " HOSTNAME
# Sanitize hostname to lowercase alphanumeric + hyphens
HOSTNAME=$(echo "$HOSTNAME" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')

if [ -z "$HOSTNAME" ]; then
  error "Hostname cannot be empty."
fi

HOST_DIR="$REPO_DIR/hosts/$HOSTNAME"

# Check if the host already exists in the repo
if [ -d "$HOST_DIR" ]; then
  warn "Host configuration for '$HOSTNAME' already exists at $HOST_DIR."
  read -rp "Do you want to overwrite it? [y/N]: " OVERWRITE
  if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
    info "Using existing configuration for '$HOSTNAME'."
  else
    rm -rf "$HOST_DIR"
    mkdir -p "$HOST_DIR"
  fi
else
  mkdir -p "$HOST_DIR"
fi

# Move hardware configuration into position
if [ -f "$TEMP_HW_CONF" ]; then
  mv "$TEMP_HW_CONF" "$HOST_DIR/hardware-configuration.nix"
  success "Placed hardware-configuration.nix in $HOST_DIR/"
else
  error "Failed to locate hardware configuration for this machine."
fi

# 6. Generate default.nix if creating/overwriting host configuration
if [ ! -f "$HOST_DIR/default.nix" ]; then
  info "Let's configure hardware features for '$HOSTNAME'..."
  
  read -rp "Does this machine have Bluetooth? [y/N]: " HAS_BLUETOOTH
  read -rp "Does this machine have an Nvidia GPU? [y/N]: " HAS_NVIDIA

  # Build imports block
  IMPORTS="    ./hardware-configuration.nix\n    ../../system/common.nix"
  if [[ "$HAS_BLUETOOTH" =~ ^[Yy]$ ]]; then
    IMPORTS="$IMPORTS\n    ../../system/bluetooth.nix"
  fi
  if [[ "$HAS_NVIDIA" =~ ^[Yy]$ ]]; then
    IMPORTS="$IMPORTS\n    ../../system/nvidia.nix"
  fi

  # Write default.nix
  cat << EOF > "$HOST_DIR/default.nix"
{ config, pkgs, inputs, ... }:

{
  imports = [
$(echo -e "$IMPORTS")
  ];

  networking.hostName = "$HOSTNAME";
}
EOF
  success "Generated $HOST_DIR/default.nix"
fi

# 7. Add Host to flake.nix if not already registered
if ! grep -q "\./hosts/$HOSTNAME" "$REPO_DIR/flake.nix"; then
  info "Registering host '$HOSTNAME' in flake.nix..."
  
  # Inject the host configuration block using AWK
  awk -v host="$HOSTNAME" '
    /nixosConfigurations = \{/ {
      print
      print "      " host " = nixpkgs.lib.nixosSystem {"
      print "        system = \"x86_64-linux\";"
      print "        specialArgs = { inherit inputs; };"
      print "        modules = ["
      print "          sops-nix.nixosModules.sops"
      print "          hermes-agent.nixosModules.default"
      print "          home-manager.nixosModules.home-manager"
      print "          ./hosts/" host
      print "        ];"
      print "      };"
      next
    }
    { print }
  ' "$REPO_DIR/flake.nix" > "$REPO_DIR/flake.nix.tmp"
  
  mv "$REPO_DIR/flake.nix.tmp" "$REPO_DIR/flake.nix"
  success "Registered '$HOSTNAME' in flake.nix"
else
  info "Host '$HOSTNAME' is already registered in flake.nix"
fi

# 8. Fix file ownership of the repository so that the user owns it
info "Ensuring correct ownership for $REPO_DIR..."
chown -R 1000:100 "$REPO_DIR"

# 9. Track files in Git (Crucial for Nix Flakes!)
info "Tracking new files in git..."
# Run git commands as the real user to avoid permission and configuration issues
sudo -u "$REAL_USER" git -C "$REPO_DIR" add "$REPO_DIR/flake.nix"
sudo -u "$REAL_USER" git -C "$REPO_DIR" add "$REPO_DIR/hosts/$HOSTNAME"
success "New files successfully tracked in git."

# 10. Rebuild & Activate Prompt
echo ""
warn "Ready to build and activate the default configuration for '$HOSTNAME'!"
read -rp "Do you want to run nixos-rebuild switch now? [y/N]: " RUN_REBUILD

if [[ "$RUN_REBUILD" =~ ^[Yy]$ ]]; then
  info "Rebuilding and switching system configuration... This might take some time."
  nixos-rebuild switch --flake "$REPO_DIR#$HOSTNAME"
  success "NixOS has been successfully configured and activated!"
  echo "You can now reboot to launch Hyprland and complete the onboarding."
else
  info "Skipped automatic rebuild. You can manually apply the configuration later using:"
  echo -e "  \e[32msudo nixos-rebuild switch --flake $REPO_DIR#$HOSTNAME\e[0m"
fi
