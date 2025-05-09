{ pkgs, ... }:
{
  # lets you use lightdm and still login to hyprland without crashing
  services.displayManager.sddm.wayland.enable = true;

  programs.hyprland = {
    enable = true;
    # for applications that require xorg
    xwayland.enable = true;
  };

  # hints dumb electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # suprisingling the setup breaks without kitty (still don't know why)
  environment.systemPackages = with pkgs; [
    kitty
    hyprlandPlugins.hy3
    hyprpaper
    wofi
    waybar
  ];

  # cache fix for hyprland builds that use flakes
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
