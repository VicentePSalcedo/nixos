{
  services.picom = {
    backend = "glx";
    enable = true;
    fade = true;
    fadeDelta = 2;
    settings = {
      blur = { 
          method = "dual_kawase";
          strength = 5;
      };
    };
    shadow = true;
  };
}
