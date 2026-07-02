{ config, pkgs, ... }:

let
  hostName = config.networking.hostName;
  otherHost = if hostName == "wraith" then "phantom" else "wraith";

  # Swap public keys for binary verification.
  # Replace these with the actual public keys generated on each machine.
  publicKeys = {
    wraith = "wraith-1:+eLfO0crBYxkW/BRFDkPU6NEFywzfd3v5iVCqC4Dgn0=";
    phantom = "phantom-1:7xJKoOYRzNCBbkG5UcuafjPtc6tN3IGMpYlqWQ/frHk=";
  };
in
{
  # 1. Spin up a lightweight binary cache server locally
  services.nix-serve = {
    enable = true;
    port = 5000;
    secretKeyFile = "/var/lib/nix-serve/cache-key.sec";
  };

  # 2. Securely expose nix-serve ONLY over the Tailscale network interface
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5000 ];

  # 3. Pull builds from the other host's cache when available
  nix.settings = {
    substituters = [ "http://${otherHost}:5000" ];
    trusted-public-keys = [ publicKeys.${otherHost} ];

    # Fail-fast options when a cache sharing host is offline
    connect-timeout = 3;
    download-attempts = 2;
  };
}
