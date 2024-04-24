{
  services.picom = {
    backend = "glx";
    enable = true;
    fade = true;
    fadeDelta = 2;
    settings = {
      corner-radius = 6;
      blur = { 
          method = "dual_kawase";
          strength = 5;
      };
    };
    shadow = true;
  };
}
