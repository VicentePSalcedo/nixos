This repo is how I key my OS the same regardless of which machine I'm using. This assume you already have a minimal install of NixOS and have SSH enabled.
# Quick Start
## Add your SSH key to clone your repo
If you are cloning via SSH the first thing that you'll want to do is generate an SSH key and make sure it is connected to your GitHub account.
1. Generate new SSH key:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
```bash
eval "$(ssh-agent -s)"
```
```bash
ssh-add ~/.ssh/id_ed25519
```
2. Add the new SSH key to your GitHub account:
```bash
cat ~/.ssh/id_ed25519.pub
# Then select and copy the contents of the id_ed25519.pub file
# displayed in the terminal to your clipboard
```
3. In the upper-right corner of any page, click your profile photo, then click Settings.
4. In the "Access" section of the sidebar, click SSH and GPG keys.
5. Click New SSH key or Add SSH key.
6. In the "Title" field, add a descriptive label for the new key. For example, if you're using a personal laptop, you might call this key "Personal laptop".
7. Select the type of key, either authentication or signing. For more information about commit signing, see "About commit signature verification."
8. In the "Key" field, paste your public key.
9. Click Add SSH key.
## Clone NixOS repo to your home directory
```bash
# If you're using SSH
git clone git@github.com:VicentePSalcedo/nixos.git
```
```bash
# If you're using HTTPS
git clone https://github.com/VicentePSalcedo/nixos.git
```
## Link repo and rebuild
```bash
sudo mv /etc/nixos /etc/nixos.bak # Backup the original configuration
```
```bash
sudo ln -s ~/nixos-config/ /etc/nixos
```
```bash
# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```
