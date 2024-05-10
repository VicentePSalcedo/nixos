{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        blue = true;
        startup_mode = "Maximized";
      };
      font = {
        normal = {
	        family = "FiraCodeNerdFont";
	        style = "Regular";
	      };
        size = 12;
      };
    };
  };
}
