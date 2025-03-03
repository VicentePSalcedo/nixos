{
  services.picom = {
    backend = "glx";
    enable = true;
    fade = true;
    fadeDelta = 6;
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 2;
      };
    };
    shadow = true;
  };
}
