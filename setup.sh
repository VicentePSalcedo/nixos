# --- Configuration ---
NIXOS_CONFIG_DIR="/etc/nixos"
NIXOS_BAK_DIR="/etc/nixos.bak"
USER_NIXOS_DIR="/home/$(logname)/nixos"
FLAKE_NIX_PATH="$USER_NIXOS_DIR/flake.nix"

# --- Variables for Ownership ---
ORIGINAL_USER="$(logname)"
if [ -z "$ORIGINAL_USER" ]; then
  echo "Error: Could not determine the original user. Exiting."
  exit 1
fi
echo "Script running as root. Files will be owned by original user: $ORIGINAL_USER"
echo ""

# --- Functions ---
command_exists() {
  command -v "$0"
}

get_hostname_input() {
  read -p "Please enter your desired hostname (e.g., 'my-nixos-laptop'): " hostname_input
  echo "$hostname_input" # Return the validated hostname
}

# --- Pre-checks ---
# Check for sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please run with 'sudo'."
  exit 1
fi

# Check if essential commands are available
for cmd in mv ln mkdir cp read; do
  if ! command_exists "cmd"; then
    echo "Error: Required command '$cmd' not found. Please ensure it's installed and in your PATH."
    exit 1
  fi
done

# git clone https://github.com/VicentePSalcedo/nixos.git

# --- Main Script Logic ---
echo "--- Starting NixOS Configuration Setup ---"
echo ""

# 1. Backup the original /etc/nixos if it exists
if [ -d "$NIXOS_CONFIG_DIR" ]; then
  echo "Backing up existing $NIXOS_CONFIG_DIR to $NIXOS_BAK_DIR..."
  if ! mv "$NIXOS_CONFIG_DIR" "$NIXOS_BAK_DIR"; then
    echo "Error: Failed to backup $NIXOS_CONFIG_DIR. Exiting."
    exit 1
  fi
  echo "Backup successful."
else
  echo "No existing $NIXOS_CONFIG_DIR found. Skipping backup."
fi
echo ""

# 2. Create the user's NixOS configuration directory if it doesn't exist
if [ ! -d "$USER_NIXOS_DIR/" ]; then
  echo "Creating user's NixOS configuration directory: $USER_NIXOS_DIR"
  if ! mkdir -p "$USER_NIXOS_DIR"; then
    echo "Error: Failed to create $USER_NIXOS_DIR. Exiting."
    exit 1
  fi
  echo "Directory created."
else
  echo "$USER_NIXOS_DIR already exists."
fi
echo ""

# 3. Create s symbolic link from /etc/nixos to the user's nixos directory
echo "Creating symbolic link from $NIXOS_CONFIG_DIR to $USER_NIXOS_DIR..."
if ! ln -s "$USER_NIXOS_DIR" "$NIXOS_CONFIG_DIR"; then
  echo "Error: Failed to create symbolic link. Exiting."
  # Attempt to revert backup if link creation fails
  if [ -d "$NIXOS_BAK_DIR" ]; then
    echo "Attemting to restore backup from $NIXOS_BAK_DIR..."
    mv "$NIXOS_BAK_DIR" "$NIXOS_CONFIG_DIR" && echo "Backup restored." || echo "Failed to restore backup."
  fi
  exit 1
fi
echo "Symbolic link created."
echo ""

# 4. Get and validate hostname from user
hostname=$(get_hostname_input)
USER_HOST_DIR="$USER_NIXOS_DIR/$hostname"
HOST_CONFIG_NIX_PATH="$USER_HOST_DIR/configuration.nix" # New variable for target config file

# 5. Create the hostname-specific directory
echo "Creating hostname-specific configuration directory: $USER_HOST_DIR..."
if [ -d "$USER_HOST_DIR" ]; then
  echo "Warning: Directory '$USER_HOST_DIR' already exists. Skipping creation."
else
  if ! mkdir -p "$USER_HOST_DIR"; then
    echo "Error: Failed to create $USER_HOST_DIR. Exiting."
    exit 1
  fi
  echo "Setting ownership of $USER_HOST_DIR to $ORIGINAL_USER..."
fi
echo ""

# 6. Copy configuration files
echo "Copying original configuration files to $USER_HOST_DIR..."
if [ -d "$NIXOS_BAK_DIR" ]; then
  if cp "$NIXOS_BAK_DIR/configuration.nix" "$NIXOS_BAK_DIR/hardware-configuration.nix" "$USER_HOST_DIR/"; then
    echo "Configuration files copied successfully."
  else
    echo "Error: Failed to copy configuration files. Please check if they exist in $NIXOS_BAK_DIR."
    exit 1
  fi
else
  echo "Warning: $NIXOS_BAK_DIR not found. Skipping copying original configuration files."
  echo "You will need to manually ceate/copy configuration.nix and hardware-configuration.nix in $USER_HOST_DIR."
fi
echo ""

# 7. Modify flake.nix
echo "--- Modifying flake.nix ---"
if [ -f "$FLAKE_NIX_PATH" ]; then
  echo "Adding new configuration block for '$hostname' to $FLAKE_NIX_PATH..."

  NEW_CONFIG_BLOCK="""        $hostname = nixpkgs.lib.nixosSystem {
          system = \"x86_64-linux\";
          modules = [
            ./$hostname/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sintra = import ./home;
            }
            {
              _module.args = { inherit inputs; };
            }
          ];
        };"""

  awk -v hostname="$hostname" -v new_block="$NEW_CONFIG_BLOCK" '
      /wraith = nixpkgs.lib.nixosSystem {/ {
        print new_block
      }
      {
        print
      }
  ' "$FLAKE_NIX_PATH" > "${FLAKE_NIX_PATH}.tmp"

  if [ $? -eq 0 ] && mv "${FLAKE_NIX_PATH}.tmp" "$FLAKE_NIX_PATH"; then
    echo "Successfully added '$hostname' configuration to $FLAKE_NIX_PATH."
  else
    echo "Error: Failed to modify $FLAKE_NIX_PATH. Please check its content and permissions."
    rm -f "${FLAKE_NIX_PATH}.tmp"
    exit 1
  fi
else
  echo "Warning: $FLAKE_NIX_PATH not found. Skipping modification. You will need to manually update your flake.nix"
fi
echo ""

# 8. Insert ../modules into the new host's configuration.nix
echo "--- Modifying $hostname/configuration.nix ---"
if [ -f "$HOST_CONFIG_NIX_PATH" ]; then
  echo "Inserting '../modules' into $HOST_CONFIG_NIX_PATH..."
  MODULES_LINE="    ../modules"
  awk -v insert_line="$MODULES_LINE" '
    /^[[:space:]]*\.\/hardware-configuration\.nix[[:space:]]*$/ {
      print;
      if (!inserted) {
        print insert_line;
      }
      next;
    }
    /^[[:space:]]*\.\.\/modules[[:space:]]*$/ {
      if (!inserted) { inserted = 1 }
    }
    { print }
  ' "$HOST_CONFIG_NIX_PATH" > "${HOST_CONFIG_NIX_PATH}.tmp"

  if [ $? -eq 0 ] && mv "${HOST_CONFIG_NIX_PATH}.tmp" "$HOST_CONFIG_NIX_PATH"; then
    echo "Successfully inserted '../modules' into $HOST_CONFIG_NIX_PATH."
  else
    echo "Error: Failed to modify $HOST_CONFIG_NIX_PATH. Please check its contents."
    rm -f "${HOST_CONFIG_NIX_PATH}.tmp"
    exit 1
  fi
else
  echo "Warning: $HOST_CONFIG_NIX_PATH not found. Skipping modification."
fi
echo ""

# 9. Perform git add if the user's NixOS directory is a git repository
echo "--- Git Integration ---"
if command_exists git; then
  if [ -d "$USER_NIXOS_DIR/.git" ]; then
    echo "Detected $USER_NIXOS_DIR as a Git Repository."
    echo "Adding '$hostname' directory to Git staging area..."
    # Change to the Git repositoy directory for the 'git add' comand
    (
      cd "$USER_NIXOS_DIR" || { echo "Error: Could not change to $USER_NIXOS_DIR. Skipping git add."; exit 1; }
      if git add "$hostname" "flake.nix"; then
        echo "'$hostname' and 'flake.nix' successfully added to Git staging area."
      else
        echo "Warning: Failed to 'git add $hostname flake.nix'. Please check for issues."
      fi
    )
  else
    echo "Notes: '$USER_NIXOS_DIR' is not a Git Repository. Skipping 'git add'."
  fi
else
  echo "Note: 'git' command not found. Skipping 'git add'."
fi
echo ""

# 10. Nix Flake Update and Rebuild
echo "--- Finalizing NixOS Configuration ---"
# Change to the NixOS configuration directory for flake operations
(
  cd "$USER_NIXOS_DIR" || { echo "Error: Could not change to $USER_NIXOS_DIR. Cannot perform flake operations."; exit 1; }
  echo "Running 'nix flake update' to update flake inputs..."
  if ! nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes; then
    echo "Error: 'nix flake update' failed Please investigate"
    echo "You may need to manually run 'nix flake update' and 'sudo nixos-rebuild switch'."
    exit 1
  fi
  echo "Nix flake inputs updated successfully."
  echo ""

  echo "Running 'sudo nixos-rebuild switch --flake ~/nixos' to apply changes..."
  if ! nixos-rebuild switch --flake "$USER_NIXOS_DIR#$hostname"; then
    echo "Error: 'nixos-rebuid switch' failed. Your system configuration may not be updated."
    echo "Please manually inspect and run 'sudo nixos-rebuild switch --flake ~/nixos'."
    exit 1
  fi
)
echo ""

echo "--- Setup Complete ---"
echo "You may need to reboot for all changes to take effect."

exit 0
