{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/common.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    enable = lib.mkForce true;
    device = "/dev/sda";
    configurationLimit = 6;
  };

  networking.hostName = "spectre";

  # ------------------------------------------------------------------
  # Proton VPN Exit Node via Tailscale
  # ------------------------------------------------------------------
  # spectre connects to Proton VPN via a direct WireGuard interface,
  # then advertises itself as a Tailscale exit node so other machines
  # can route their traffic through Proton VPN.
  #
  # To get the values below:
  #   1. Log into https://account.protonvpn.com
  #   2. Downloads > WireGuard configuration
  #   3. Pick a server and download the .conf file
  #   4. Fill in the PLACEHOLDER values below
  # ------------------------------------------------------------------

  # Enable Tailscale with exit-node support (server mode enables IP forwarding)
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  # WireGuard interface for Proton VPN (runs in default namespace alongside Tailscale)
  networking.wireguard.interfaces = {
    proton0 = {
      # IP assigned by Proton VPN (from [Interface] > Address in the .conf)
      ips = [
        "10.2.0.2/32"
        # e.g. "10.2.0.2/32"
        # If the config has an IPv6 address, include it too:
        "2a07:b944::2:2/128"
      ];

      # Private key from [Interface] > PrivateKey in the .conf
      # Stored in sops-nix, decrypted at boot to tmpfs
      privateKeyFile = config.sops.secrets."proton-vpn-wireguard-key".path;

      peers = [
        {
          # From [Peer] in the .conf:
          publicKey = "vrQlzOff8/CWCDVaesXMZLfQaOE4qrdY2BJUjWeRHyA=";
          endpoint = "149.22.94.113:51820";
          # Route all internet traffic through the VPN
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          # Keep the tunnel alive through NAT
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Systemd dependency: wireguard-proton0 must be up before tailscaled
  # advertises the exit node
  systemd.services.tailscaled.after = [ "wireguard-wg-proton0.service" ];
  systemd.services.tailscaled.wants = [ "wireguard-wg-proton0.service" ];

  # ------------------------------------------------------------------
  # Firewall: only allow traffic through Tailscale + WireGuard
  # ------------------------------------------------------------------
  networking.firewall = {
    # Allow WireGuard UDP on the Proton VPN endpoint port
    allowedUDPPorts = [ 51820 ];
    # Also allow Tailscale's own WireGuard (already handled by the Tailscale
    # module by default, but being explicit)
    # Tailscale handles its own firewall rules automatically via tailscaled
  };

  system.stateVersion = "26.05";
}
