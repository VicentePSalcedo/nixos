{ config, pkgs, ... }:

let
  hostName = config.networking.hostName;

  # Spectre's static Tailscale IP and public key
  spectreIP = "100.64.0.8";
  spectrePublicKey = "spectre-1:czIFjRGSEbELwMeOe91g5TDFOnEzKGZSNKmHfHElsiw=";
in
{
  # 1. If we are on spectre, act as the central binary cache server
  services.nix-serve = {
    enable = hostName == "spectre";
    port = 5000;
    secretKeyFile = "/var/lib/nix-serve/cache-key.sec";
    bindAddress = if hostName == "spectre" then spectreIP else "127.0.0.1";
  };

  # 2. Securely expose nix-serve ONLY over the Tailscale interface on the server
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = 
    if hostName == "spectre" then [ 5000 ] else [];

  # 3. Every other machine pulls builds from spectre's cache
  nix.settings = if hostName != "spectre" then {
    substituters = [ "http://${spectreIP}:5000" ];
    trusted-public-keys = [ spectrePublicKey ];

    # Fail-safe options when the central cache is offline or slow
    connect-timeout = 5;
    stalled-download-timeout = 15;
    download-attempts = 1;
    fallback = true;
  } else {};
}
