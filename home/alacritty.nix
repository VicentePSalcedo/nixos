{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "FiraCodeNerdFont";
          style = "Regular";
        };
        size = 12;
      };
      terminal = {
        shell = "nu";
      };
      window = {
        opacity = 0.85;
        startup_mode = "Maximized";
      };
    };
  };
}
