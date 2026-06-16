{ config, pkgs, ... }:

{
  # Mandatory Access Control (MAC) for zero-overhead background daemon sandboxing
  security.apparmor.enable = true;

  # Restrict sudo execution entirely to the 'wheel' group
  security.sudo.execWheelOnly = true;

  # DNS-over-TLS (DoT) configuration
  # Opportunistic mode encrypts DNS queries whenever the network allows it,
  # but safely falls back so captive portals (coffee shops/airports) still work.
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
  };
}
