{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        Class = "0x000100"; # Announce computer/audio profile capability to connecting devices
      };
    };
  };
  # services.blueman.enable = true;
}
