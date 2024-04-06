{
  programs.rofi = {
    enable = true;
    font = "FiraCodeNerdFont";
  };
  home.file.".config/rofi" = {
      source = ./config.rasi;
  };
}
