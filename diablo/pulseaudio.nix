{
  users.extraUsers.sintra.extraGroups = [ "audio" ];
  hardware = {
    pulseaudio = {
      enable = true; 
      support32Bit = true;
    };
  };
}
