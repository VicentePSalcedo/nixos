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
        "wireplumber.settings" = {
          # Don't remember/promote previously-selected default, so newly
          # connected devices (headphones) can win based on priority alone
          "node.restore-default-targets" = false;
        };
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
          # Give wired headphones/headsets a priority above the internal
          # speaker (100) but below Bluetooth (2000), so they auto-switch
          # when plugged in
          {
            matches = [
              {
                "device.form-factor" = "~headphone|headset|portable";
              }
            ];
            actions = {
              update-props = {
                "priority.driver" = 1500;
                "priority.session" = 1500;
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


}
