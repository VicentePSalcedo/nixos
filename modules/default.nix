{ pkgs, ... }:
{
  imports = [
    ./i3
    ./tmux.nix
    ./bluetooth.nix
    ./cachix.nix
    ./grub.nix
    # ./nvidia.nix # only enable this if you have an nvidia gpu or you will get bent and not in a nice way
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
