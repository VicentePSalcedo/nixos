{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # for applications that require xorg
    xwayland.enable = true;
  };

  # hints dumb electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    kdePackages.xwaylandvideobridge # May or may not be needed without KDE desktop enabled
    # kitty
    hyprpaper
    imagemagick
    pipewire
    rofi-wayland
    wireplumber
    waybar
    xdg-desktop-portal-hyprland
  ];

  # cache fix for hyprland builds that use flakes
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
