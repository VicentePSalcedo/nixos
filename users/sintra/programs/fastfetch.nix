{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
  };

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "padding": {
          "top": 2,
          "left": 1,
          "right": 2
        }
      },
      "display": {
        "separator": "  "
      },
      "modules": [
        // Title
        {
          "type": "title",
          "format": "{#1}╭───────────── {#}{user-name-colored}"
        },
        // System Information
        {
          "type": "custom",
          "format": "{#1}│ {#}System Information"
        },
        {
          "type": "os",
          "key": "{#separator}│  {#keys}󰍹 OS"
        },
        {
          "type": "kernel",
          "key": "{#separator}│  {#keys}󰒋 Kernel"
        },
        {
          "type": "uptime",
          "key": "{#separator}│  {#keys}󰅐 Uptime"
        },
        {
          "type": "packages",
          "key": "{#separator}│  {#keys}󰏖 Packages",
          "format": "{all}"
        },
        {
          "type": "custom",
          "format": "{#1}│"
        },
        // Desktop Environment
        {
          "type": "custom",
          "format": "{#1}│ {#}Desktop Environment"
        },
        {
          "type": "de",
          "key": "{#separator}│  {#keys}󰧨 DE"
        },
        {
          "type": "wm",
          "key": "{#separator}│  {#keys}󱂬 WM"
        },
        {
          "type": "wmtheme",
          "key": "{#separator}│  {#keys}󰉼 Theme"
        },
        {
          "type": "display",
          "key": "{#separator}│  {#keys}󰹑 Resolution"
        },
        {
          "type": "shell",
          "key": "{#separator}│  {#keys}󰞷 Shell"
        },
        {
          "type": "terminalfont",
          "key": "{#separator}│  {#keys}󰛖 Font"
        },
        {
          "type": "custom",
          "format": "{#1}│"
        },
        // Hardware Information
        {
          "type": "custom",
          "format": "{#1}│ {#}Hardware Information"
        },
        {
          "type": "cpu",
          "key": "{#separator}│  {#keys}󰻠 CPU"
        },
        {
          "type": "gpu",
          "key": "{#separator}│  {#keys}󰢮 GPU"
        },
        {
          "type": "memory",
          "key": "{#separator}│  {#keys}󰍛 Memory"
        },
        {
          "type": "disk",
          "key": "{#separator}│  {#keys}󰋊 Disk (/)",
          "folders": "/"
        },
        {
          "type": "custom",
          "format": "{#1}│"
        },
        // Colors
        {
          "type": "colors",
          "key": "{#separator}│",
          "symbol": "circle"
        },
        // Footer
        {
          "type": "custom",
          "format": "{#1}╰───────────────────────────────╯"
        }
      ]
    }
  '';
}
