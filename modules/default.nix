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
  ];
  networking.networkmanager.enable = true;

  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "docker" "wheel" "audio" ];
  };
  environment.systemPackages = with pkgs; [
    curl
    dconf
    htop
    lshw
    lsof
    npth
    pavucontrol
    vim
    unzip
    wget
  ];
  nixpkgs.config.allowUnfree = true;
  security.rtkit.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.openssh.enable = true;
}
