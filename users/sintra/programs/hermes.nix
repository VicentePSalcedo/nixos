{ config, pkgs, ... }:

{
  # Define custom TokyoNight Storm skin in user space (for local terminal sessions or user-level fallback)
  home.file.".hermes/skins/tokyonight-storm.yaml".text = builtins.readFile ./tokyonight-storm.yaml;
}
