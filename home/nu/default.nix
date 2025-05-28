{
  home.shell.enableNushellIntegration = true;
  programs = {
    nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
    };
  };
}
