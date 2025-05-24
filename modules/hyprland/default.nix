{ pkgs, ... }:
{
  services = {
    displayManager = {
      defaultSession = "hyprland";
      autoLogin = {
        enable = true;
        user = "sintra";
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      desktopManager = {
        xterm.enable = false;
      };
      displayManager = {
        lightdm = {
          enable = true;
          background = ../../wallpaper/1920x1080.png;
          greeters.slick = {
            enable = true;
            font.name = "FiraCodeNerdFont";
          };
        };
      };
    };
  };
  # lets you use lightdm and still login to hyprland without crashing
  programs.hyprland = {
    enable = true;
    # for applications that require xorg
    xwayland.enable = true;
  };

  # suprisingling the setup breaks without kitty (still don't know why)
  environment.systemPackages = with pkgs; [
    kdePackages.xwaylandvideobridge
    kitty
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
