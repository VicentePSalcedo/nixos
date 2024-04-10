{
  services.picom = {
    backend = "glx";
    enable = true;
    fade = true;
    fadeDelta = 2;
    settings = {
      inactive-dim = 0.2;
      corner-radius = 9;
      blur = { 
          method = "dual_kawase";
          strength = 2;
      };
    };
    shadow = true;
    shadowExclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
  };
}
