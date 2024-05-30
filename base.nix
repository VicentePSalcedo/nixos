{ config, pkgs, inputs, callPackages, ... }:
{
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [
    curl
    dconf
    git
    htop
    lshw
    lsof
    npth
    pavucontrol
    vim
    unzip
    wget
  ];
  programs.gnupg.agent = {
    enable = true;
  };
  nixpkgs.config.allowUnfree = true;
  users.users.sintra = {
    isNormalUser = true;
    description = "sintra";
    extraGroups = [ "networkmanager" "docker" "wheel" "audio" "libvirtd" ];
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["sintra"];
      substituters = [ "https//cache.nixos.org" ];
    };
  };
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { 
    LC_ADDRESS = "en_US.UTF-8"; 
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
