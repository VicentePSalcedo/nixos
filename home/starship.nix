{ pkgs, ... }:
{

  home.packages = with pkgs; [
    starship
  ];
  programs.starship.settings = {
    gcloud = {
      disabled = true;
    };
  };
}
