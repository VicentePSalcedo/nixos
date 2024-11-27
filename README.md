This repo is how I keep my OS the same regardless of which machine I use. It assumes you already have a minimal install of Nix OS with an encrypted partition, SSH enabled, and your username is Sintra.

# Quick Start

## Add your SSH key to clone your repo
If you are cloning via SSH, you'll first want to generate an SSH key and make sure it is connected to your GitHub account.
- Generate new SSH key:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

- Add the new SSH key to your GitHub account:
```bash
cat ~/.ssh/id_ed25519.pub
# Then select and copy the contents of the id_ed25519.pub file
# displayed in the terminal to your clipboard
```
- In the upper-right corner of any page, click your profile photo, then click Settings.
- In the "Access" section of the sidebar, click SSH and GPG keys.
- Click New SSH key or Add SSH key.
- In the "Key" field, paste your public key.
- Click Add SSH key.
## Clone Nix OS repo to your home directory
```bash
# If you're using SSH
git clone git@github.com:VicentePSalcedo/nixos.git
# If you're using HTTPS
git clone https://github.com/VicentePSalcedo/nixos.git
```

## Link repo and rebuild
before you run the following, make sure that you rebuild with a hostname that you chose instead of the default "nixos" otherwise, it gets messy to fix later
```bash
sudo mv /etc/nixos /etc/nixos.bak # Backup the original configuration
sudo ln -s ~/nixos/ /etc/nixos
mkdir ~/nixos/"your-hostname"
cp /etc/nixos.bak/configuration.nix /etc/nixos.bak/hardware-configuration.nix ~/nixos/"your-hostname"/
# need to git add because the flake is tied to the git version control and won't see new files otherwise
```
You'll need to generate a home.nix file or copy one that already exists and then add the following section 
```nix
      *your-host-name* = nixpkgs.lib.nixosSystem {
        system = "x86_64-linx";
        modules = [
          ./*your-host-name*/configuration.nix
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
      };
```
```bash
git add .
# Deploy the flake.nix located at the default location (/etc/nixos)
nix flake update
sudo nixos-rebuild switch --flake ~/nixos
```

## Resources
[Quick Home Manager Look-Ups](https://nix-community.github.io/home-manager/options.xhtml)
[Quick Configuration Options Look Ups](https://nixos.org/manual/nixos/stable/options)

## repos I borrowed from
[tmux](https://github.com/dreamsofcode-io/tmux)
[LazyVim](https://github.com/LazyVim/LazyVim)

## Inspiration for the style setup that I am working on
[Dynamic Rice](https://github.com/zDyanTB/HyprNova)
