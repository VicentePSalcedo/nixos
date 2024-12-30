{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        blur = true;
        startup_mode = "Maximized";
      };
      font = {
        normal = {
	        family = "FiraCodeNerdFont";
	        style = "Regular";
	      };
        size = 10;
      };
    };
  };
}
