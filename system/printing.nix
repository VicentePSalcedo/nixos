{ config, pkgs, lib, ... }:

{
  # CUPS printing services
  services.printing = {
    enable = true;
    # Auto-discover and browse network printers (legacy CUPS/LPD and IPP
    # network printers) via the cups-browsed daemon.
    browsed.enable = true;
  };

  # mDNS/DNS-SD discovery (how modern network printers announce themselves:
  # IPP Everywhere, AirPrint). CUPS-browsed talks to this daemon.
  services.avahi = {
    enable = true;
    openFirewall = true; # allow mDNS (UDP 5353) through the firewall
    nssmdns4 = true;     # resolve *.local hostnames so printers resolve by name
  };

  # HP printers: hplip provides full PPD drivers and the hp tooling.
  # Many modern HP models also work driverless over IPP Everywhere, but the
  # driver package covers models that don't. Add if your model needs it:
  #   services.printing.drivers = [ pkgs.hplip ];
}
