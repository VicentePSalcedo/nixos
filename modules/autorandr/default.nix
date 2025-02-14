{
  services = {
    autorandr = {
      enable = true;
      profiles = {
        "external lid open" = {
          # included from example but we should see if the setups become universal when these are removed
          fingerprint = {
            HDMI-1 = "00ffffffffffff0005e30232de0500001c220103804627782a9be5ad5046a526105054bfef00d1c081803168317c4568457c6168617c023a801871382d40582c4500ba892100001e000000ff0032485751374a41303031353032000000fc00333247325747380a2020202020000000fd0030f01eff3c000a202020202020017f020337f14c101f0514041303120211013f230907078301000067030c002000004467d85dc4017880006d1a0000020130f0e6000000000015df80a07038404030403500ba892100001e377f80887038144018203500ba892100001e8b6f80a07038404030203500ba892100001e000000000000000000000000000000000000ea";
            eDP-1 = "00ffffffffffff0006af2d2200000000211c0104951d11780230e5a556539d270c505400000001010101010101010101010101010101143780b87038244010103e0025a5100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231333348414b30322e32200a00ea";
          };
          config = {
            HDMI-1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "240";
            };
            eDP-1 = {
              enable = true;
              mode = "1920x1080";
              position = "1920x0";
            };
          };
        };
        "external lid closed" = {
          # included from example but we should see if the setups become universal when these are removed
          fingerprint = {
            HDMI-1 = "00ffffffffffff0005e30232de0500001c220103804627782a9be5ad5046a526105054bfef00d1c081803168317c4568457c6168617c023a801871382d40582c4500ba892100001e000000ff0032485751374a41303031353032000000fc00333247325747380a2020202020000000fd0030f01eff3c000a202020202020017f020337f14c101f0514041303120211013f230907078301000067030c002000004467d85dc4017880006d1a0000020130f0e6000000000015df80a07038404030403500ba892100001e377f80887038144018203500ba892100001e8b6f80a07038404030203500ba892100001e000000000000000000000000000000000000ea";
            eDP-1 = "00ffffffffffff0006af2d2200000000211c0104951d11780230e5a556539d270c505400000001010101010101010101010101010101143780b87038244010103e0025a5100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231333348414b30322e32200a00ea";
          };
          config = {
            HDMI-1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "240";
            };
            eDP-1 = {
              enable = false;
            };
          };
        };
        "laptop" = {
          # included from example but we should see if the setups become universal when these are removed
          fingerprint = {
            eDP-1 = "00ffffffffffff0006af2d2200000000211c0104951d11780230e5a556539d270c505400000001010101010101010101010101010101143780b87038244010103e0025a5100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231333348414b30322e32200a00ea";
          };
          config = {
            eDP-1 = {
              enable = true;
              mode = "1920x1080";
            };
          };
        };
      };
      ignoreLid = false;
    };
  };
}
