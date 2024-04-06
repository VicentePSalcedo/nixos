{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
    	  i3status
	      i3lock
	      i3blocks
      ];
      configFile = ./config;
    };
  };
}
