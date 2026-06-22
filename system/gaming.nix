{ pkgs, ... }:

{
  # Steam & Gaming Optimizations
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;                # Open ports for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true; # Open ports for Local Network Game Transfers
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;                           # Permits GameMode to adjust process priorities
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;                             # Permits GameScope to run with higher thread priority
  };

  # Disable mouse acceleration at the libinput level for consistent 1:1 pointer input
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
    };
  };
}
