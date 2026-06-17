{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../system/common.nix
      ../../system/bluetooth.nix
    ];

  networking.hostName = "wraith";

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  # Ultra-fast boot optimizations for the laptop
  boot = {
    loader.timeout = pkgs.lib.mkForce 0; # Skip the 7-second boot menu (hold space during boot to show it)
    initrd.systemd.enable = true; # Use parallelized systemd in initrd instead of bash scripts
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  # Prevent network initialization from stalling the boot process
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

  # Power Management
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "suspend";
    powerKeyLongPress = "hibernate";
  };
}
