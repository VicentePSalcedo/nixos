{
  programs.git = {
    enable = true;
    userEmail = "vicentepsalcedo@gmail.com";
    userName = "VicentePSalcedo";
    signing = {
      key = "EF6EDD4359F0E184CC4B19C868C579FE4A527CA1";
      signByDefault = true;
    };
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };
}
