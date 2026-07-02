{ config, pkgs, ... }:

let
  hostName = config.networking.hostName;

  # Map hostnames to their static Tailscale IPs to bypass DNS resolution timeouts when offline
  tailscaleIPs = {
    wraith = "100.64.0.1";
    phantom = "100.64.0.7";
  };

  # Determine other host and its IP
  otherHost = if hostName == "wraith" then "phantom" else "wraith";
  otherHostIP = if hostName == "wraith" then tailscaleIPs.phantom else tailscaleIPs.wraith;

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
    substituters = [ "http://${otherHostIP}:5000" ];
    trusted-public-keys = [ publicKeys.${otherHost} ];

    # Fail-fast options when a cache sharing host is offline
    connect-timeout = 1;
    stalled-download-timeout = 1;
    download-attempts = 1; # No extra retries if offline
  };
}
