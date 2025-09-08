{
  programs.git = {
    difftastic.enable = true;
    enable = true;
    extraConfig = {
      diff = {
        tool = "meld";
      };
      difftool = {
        prompt = false;
      };
      init = {
        defaultBranch = "master";
      };
      merge = {
        tool = "meld";
        ff = false;
        trustExitCode = false;
      };
      mergetool = {
        prompt = false;
      };
      pull = {
        rebase = false;
      };
    };
    # signing = {
    #   # key = "EF6EDD4359F0E184CC4B19C868C579FE4A527CA1";
    #   signByDefault = true;
    # };
    userEmail = "vicentepsalcedo@gmail.com";
    userName = "VicentePSalcedo";
  };
}
