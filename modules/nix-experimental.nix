{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [ "sintra" ];
      substituters = [ "https//cache.nixos.org" ];
    };
  };
}
