{ config, pkgs, ... }:

{
  # Enable PipeWire audio services
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # Natively configure WirePlumber priorities so Bluetooth is always preferred
    # and the internal speaker has a rock-bottom priority
    wireplumber.extraConfig = {
      "10-audio-priorities" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_output.pci-0000_06_00.6.HiFi__Speaker__sink";
              }
            ];
            actions = {
              update-props = {
                # Rock-bottom priority so it is never auto-selected over Bluetooth
                "priority.driver" = 100;
                "priority.session" = 100;
              };
            };
          }
        ];
        "monitor.bluez.rules" = [
          {
            matches = [
              {
                # Match any Bluetooth audio output
                "node.name" = "~bluez_output.*";
              }
            ];
            actions = {
              update-props = {
                # High priority so it is immediately selected when connected
                "priority.driver" = 2000;
                "priority.session" = 2000;
              };
            };
          }
        ];
      };
    };
  };

  # Systemd user service to ensure the internal speaker is muted and set to 0% volume on boot
  systemd.user.services.disable-internal-speaker = {
    description = "Mute internal speaker on boot, prefer Bluetooth audio";
    wantedBy = [ "default.target" ];
    after = [ "pipewire.service" "wireplumber.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "disable-internal-speaker" ''
        # Wait for PipeWire / WirePlumber to fully initialize
        for i in {1..10}; do
          ${pkgs.wireplumber}/bin/wpctl status >/dev/null 2>&1 && break
          sleep 0.5
        done

        wpctl_output=$(${pkgs.wireplumber}/bin/wpctl status 2>/dev/null)

        # Robustly parse the Speaker ID using AWK
        SPEAKER_ID=$(echo "$wpctl_output" | awk '
          /├─ Sinks:/ { in_sinks=1 }
          /├─ Sources:/ { in_sinks=0 }
          in_sinks && match($0, /[[:space:]]+([0-9]+)\./, m) { id = m[1] }
          in_sinks && $0 ~ "Ryzen HD Audio Controller Speaker" && id != "" { print id; exit }
        ')

        if [ -n "$SPEAKER_ID" ]; then
          ${pkgs.wireplumber}/bin/wpctl set-mute "$SPEAKER_ID" 1
          ${pkgs.wireplumber}/bin/wpctl set-volume "$SPEAKER_ID" 0%
        fi

        # Robustly parse any connected Bluetooth/JLab sink and make it the default
        BT_ID=$(echo "$wpctl_output" | awk '
          /├─ Sinks:/ { in_sinks=1 }
          /├─ Sources:/ { in_sinks=0 }
          in_sinks && match($0, /[[:space:]]+([0-9]+)\./, m) { id = m[1] }
          in_sinks && $0 ~ "JLab|bluez" && id != "" { print id; exit }
        ')

        if [ -n "$BT_ID" ]; then
          ${pkgs.wireplumber}/bin/wpctl set-default "$BT_ID"
        fi
      '';
    };
  };
}
