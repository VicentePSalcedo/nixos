#echo "generating ssh key for github"
#ssh-keygen -t ed25519 -C "vicentepsalcedo@gmail.com"
#echo "evaluating ssh agent"
#eval "$(ssh-agent -s)"
#echo "adding ssh key"
#ssh-add ~/.ssh/id_ed25519
#echo "please add the following ssh key to your github account"
#cat ~/.ssh/id_ed25519.pub

echo "backing up existing configuration"
sudo mv /etc/nixos /etc/nixos.bak
echo "symbolicaly linking the nixos directory in your home to the nixos directory for the system"
sudo ln -s ~/nixos/ /etc/nixos
echo "Enter desired host name"
read hostname
echo "making system directory"
mkdir ~/nixos/$hostname
echo "copying existing configuration"
cp /etc/nixos.bak/configuration.nix /etc/nixos.bak/hardware-configuration.nix ~/nixos/$hostname
head -n -3 flake.nix > tmp.txt && mv tmp.txt flake.nix
echo "      $hostname = nixpkgs.lib.nixosSystem {
      system = \"x86_64-link\";
        modules = [
          ./$hostname/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sintra = import ./home;
          }
          {
            _module.args = { inherit inputs; } ;
          }
        ];
      };
    };
  };
}" >> flake.nix
git add .
nix flake update --extra-experimental-features flakes --extra-experimental-features  nix-command
sudo nixos-rebuild switch --flake ~/nixos --extra-experimental-features nix-command flakes
