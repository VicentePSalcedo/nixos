{
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        shell = "nu"; 
      };
      window = {
        opacity = 0.95;
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
