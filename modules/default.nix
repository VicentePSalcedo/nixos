{ pkgs, ... }:
{
  imports = [
    ./autorandr
    ./i3
    ./tmux.nix
    ./bluetooth.nix
    # ./cachix.nix
    ./grub.nix
    # ./nvidia.nix # only enable this if you have an nvidia gpu
    ./nix-experimental.nix
    ./us-locale.nix
  ];

  networking.networkmanager.enable = true;

  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "audio"
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    dconf
    lshw
    lsof
    npth
    wget
  ];

  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;
}
