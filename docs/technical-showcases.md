# 🛠️ Highlights & Technical Showcases

### 1. ⚡ Zero Display-Manager Autostart
To minimize memory footprint and eliminate display manager overhead (such as GDM or SDDM), graphical sessions are initiated directly from `tty1` upon user login. 
This is handled via a lightweight POSIX shell startup hook declared in `users/sintra/programs/bash.nix`:

```nix
programs.bash = {
  enable = true;
  profileExtra = ''
    # If logging in on tty1 and not already in a graphical session, autostart Hyprland
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      # Exec launch bypasses display managers cleanly
      exec start-hyprland
    fi
  '';
};
```

---

### 2. 🤖 Autonomous AI Native Integration (Hermes Agent & MCP)
This configuration is built to cooperate with autonomous AI systems natively. Inside `/system/hermes.nix`, the state-of-the-art **Hermes Agent** is declared system-wide as a background service.

#### Critical Architecture Fixes Implemented:
* **Systemd PATH Override:** Since Systemd executes services in restricted pathways, core tools like `nix`, `git`, and `nodejs` are dynamically injected into the service environment via `systemd.services.hermes-agent.path`.
* **MCP Sandbox Environment Mitigation:** When running Node or Python-based Model Context Protocol (MCP) servers (like `mcp-nixos` or `@modelcontextprotocol/server-github`), the process clears `PYTHONPATH` explicitly to prevent python library collisions between parent agent environments and sandboxed Nix store packages.
* **Declarative Skin Sync:** The configuration utilizes `systemd.tmpfiles.rules` to mirror the user's local TokyoNight Storm skin configuration directly into the system-wide service directory, keeping the TUI interface synced on both user and system layers.

```nix
services.hermes-agent = {
  enable = true;
  settings = {
    model.default = "gemini-flash-latest";
    display = {
      interface = "tui";
      skin = "tokyonight-storm";
    };
  };
  mcpServers.nixos = {
    command = "nix";
    args = [ "run" "github:utensils/mcp-nixos" "--" ];
    env = { PYTHONPATH = ""; }; # Crucial Python sandbox mitigation
  };
};

# Inject binaries directly into the service environment path
systemd.services.hermes-agent.path = [ pkgs.nix pkgs.git pkgs.nodejs ];
```

---

### 3. 🧭 Bulletproof Hyprland config (Bypassing HM Lua Translation)
Recent versions of Home Manager's Hyprland module (v0.55+) attempt to generate a `.lua` configuration layout using experimental compilers. However, translating standard declarative settings lists often produces invalid Lua output, breaking core compositor features like system keybindings on system rebuild.

To prevent this config drift, this repository adopts a stable, robust hybrid configuration. It disables the Home Manager generator and writes a native, raw `hyprland.conf` directly into user space via `builtins.readFile`. This preserves perfect syntax highlighting, standard formatting, and absolute stability:

```nix
# users/sintra/programs/hyprland/default.nix
{ config, pkgs, ... }: {
  xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ./hyprland.conf;
}
```

---

### 4. 🦊 Unfree Extensions via Standalone Firefox Overlay
Managing browser extensions declaratively (such as dark themes, ad blockers, or password managers) often crashes during evaluation if an extension has an "unfree" proprietary license. This occurs even if `allowUnfree` is enabled on the host, because external flake inputs evaluate packages in isolated, sandbox states.

This repository resolves this issue by declaring Robert Helgesson's `firefox-addons` input and grafting it directly onto the host's `nixpkgs.overlays`. This pulls the addon libraries directly into the system's global `pkgs` context, where the system-wide `allowUnfree = true` can successfully validate proprietary licenses:

```nix
# system/nix-settings.nix
{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.firefox-addons.overlays.default # Graftaddons into global pkgs
  ];
}
```
This lets you declaratively list any extensions inside Home Manager (e.g., `programs.librewolf.profiles.default.extensions.packages = with pkgs.firefox-addons; [ dashlane DarkReader vimium ];`) without a single evaluation warning.
