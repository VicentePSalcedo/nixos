{ pkgs, ... }:
{
  services = {
    xserver = {
      windowManager.i3 = {
        configFile = ./config;
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          rofi
        ];
      };
    };
  };
}
