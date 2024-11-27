{ pkgs, ... }:
{
  services = {
      displayManager = {
        autoLogin = {
          enable = true;
          user = "sintra";
        };
        sddm = {
          enable = true;
          wayland.enable = true;
          autoLogin.relogin = true;
        };
      };
  };
  environment.systemPackages = with pkgs; [
    hyprpaper
    wlogout
  ];
  programs.hyprland = {
    enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
