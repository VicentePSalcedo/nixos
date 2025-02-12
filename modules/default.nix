{ pkgs, ... }:
{
  imports = [
    ./i3
    ./tmux
    ./bluetooth.nix
    ./cachix.nix
    ./grub.nix
    ./nix-experimental.nix
    ./us-locale.nix
    ./wire-guard.nix
  ];

  networking.networkmanager.enable = true;

  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "docker" "wheel" "audio" ];
  };

  environment.systemPackages = with pkgs; [
    bottom
    curl
    dconf
    lshw
    lsof
    npth
    pavucontrol
    pulseaudio
    vim
    unzip
    wget
  ];

  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;
}
