{
  networking.wg-quick.interfaces = {
    pivpn = {
      address = [ "10.83.232.4/24" "fd11:5ee:bad:c0de::a53:e804/64" ];
      dns = [ "9.9.9.9" "149.112.112.112" ];
      privateKeyFile = "/home/sintra/keys/pivpn.key";
      listenPort = 51820;
      peers = [
        {
          publicKey = "m8S8t25u1HLBYNTGQmjOSxObatjg8gyMYZ3qurxXlwo=";
          presharedKeyFile = "/home/sintra/keys/pivpnpreshared.key";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "162.199.85.157:51820";
        }
      ];
    };
  };
}
