{ config, pkgs, ... }:

{
  # Enable PipeWire (already likely enabled by Hyprland, but be explicit)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # Disable the internal ALSA speaker device by overriding its profile
    # This prevents the Ryzen HD Audio Controller from ever being used as a sink
    extraConfig.pipewire = {
      # Context properties — disable the ALSA card's output profile
      "100-disable-internal-speaker" = {
        "context.modules" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              "pulse.default.req" = "128/48000";
            };
          }
        ];
        "context.objects" = [
          {
            # Factory to create nodes with specific properties
            factory = "adapter";
            args = {
              "factory.name" = "api.alsa.pcm.node";
              "node.name" = "Ryzen HD Audio Controller Speaker";
              "node.description" = "Internal Speaker (disabled)";
              "media.class" = "Audio/Sink";
              "api.alsa.path" = "hw:1,0";
              "node.pause-on-idle" = true;
            };
          }
        ];
        "context.properties" = {
          # Disable suspend-on-idle for Bluetooth, keep for others
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 44100 48000 ];
        };
      };
    };
  };

  # ALSA UCM/UCM2 configuration to disable internal speaker at kernel level
  # This creates an ALSA conf that sets the internal speaker to 0% and mutes it
  environment.etc."alsa/conf.d/99-disable-internal-speaker.conf".text = ''
    # Disable internal speaker — force all audio to Bluetooth/HDMI
    pcm.!default {
        type plug
        slave {
            pcm "hw:1,0"
        }
        softvol {
            name "SoftMaster"
            card 1
        }
    }

    # Override the internal speaker ALSA device to be muted by default
    pcm.internal_speaker {
        type hw
        card 1
        device 0
    }

    ctl.internal_speaker {
        type hw
        card 1
    }
  '';

  # Systemd user service to ensure internal speaker stays muted on boot
  # and Bluetooth device becomes the default sink
  systemd.user.services.disable-internal-speaker = {
    description = "Disable internal speaker, prefer Bluetooth audio";
    wantedBy = [ "default.target" ];
    after = [ "pipewire.service" "wireplumber.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "disable-internal-speaker" ''
        # Wait for PipeWire to be ready
        ${pkgs.wireplumber}/bin/wpctl status > /dev/null 2>&1
        sleep 2

        # Find and mute the internal speaker sink
        SPEAKER_ID=$(${pkgs.wireplumber}/bin/wpctl status 2>/dev/null | \
          grep -A1 "Ryzen HD Audio Controller Speaker" | \
          grep -oP '^\s+\K\d+' | head -1)

        if [ -n "$SPEAKER_ID" ]; then
          ${pkgs.wireplumber}/bin/wpctl set-mute "$SPEAKER_ID" 1
          ${pkgs.wireplumber}/bin/wpctl set-volume "$SPEAKER_ID" 0%
        fi

        # Set Bluetooth as default if available
        BT_ID=$(${pkgs.wireplumber}/bin/wpctl status 2>/dev/null | \
          grep -i "bluez\|bluetooth\|JLab" | \
          grep -oP '^\s+\K\d+' | head -1)

        if [ -n "$BT_ID" ]; then
          ${pkgs.wireplumber}/bin/wpctl set-default "$BT_ID"
        fi
      '';
    };
  };
}
