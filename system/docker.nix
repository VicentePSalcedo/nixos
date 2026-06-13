{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  services.openssh.enable = true;
}
