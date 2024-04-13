{
  programs.git = {
    enable = true;
    userName = "VicentePSalcedo";
    userEmail = "vicentepsalcedo@gmail.com";
    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
    signing = {
      key = "11F2553FE9834701";
      signByDefault = true;
      gpgPath = "gpg";
    };
  };
}
