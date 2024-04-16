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
      key = "202511B15435C6F6";
      signByDefault = true;
      gpgPath = "gpg";
    };
  };
}
