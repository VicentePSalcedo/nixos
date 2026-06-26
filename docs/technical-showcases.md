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
* **Systemd PATH Override & Custom Rust Package Build:** Since Systemd executes services in restricted pathways, core tools like `nix`, `git`, and `nodejs` are dynamically injected into the service environment. Crucially, the service path also injects a custom-compiled and patched Rust helper `rust-analyzer-mcp` (version 0.2.0) to allow the agent to interface with Language Servers:
  ```nix
  systemd.services.hermes-agent.path = [
    pkgs.nix
    pkgs.git
    pkgs.nodejs
    pkgs.rust-analyzer
    (pkgs.rustPlatform.buildRustPackage {
      pname = "rust-analyzer-mcp";
      version = "0.2.0";
      src = pkgs.fetchFromGitHub {
        owner = "zeenix";
        repo = "rust-analyzer-mcp";
        rev = "v0.2.0";
        hash = "sha256-brnzVDPBB3sfM+5wDw74WGqN5ahtuV4OvaGhnQfDqM0=";
      };
      cargoHash = "sha256-7t4bjyCcbxFAO/29re7cjoW1ACieeEaM4+QT5QAwc34=";
      nativeBuildInputs = [ pkgs.pkg-config ];
      doCheck = false;
      # Patch handles a bug in notification IDs
      postPatch = ''
        substituteInPlace src/main.rs \
          --replace-fail 'let response = self.handle_request(request).await;' \
                         'if request.id.is_none() { debug!("Ignoring notification: {}", request.method); continue; } let response = self.handle_request(request).await;'
      '';
    })
  ];
  ```
* **MCP Sandbox Environment Mitigation:** When running Node or Python-based Model Context Protocol (MCP) servers (like `mcp-nixos` or `@modelcontextprotocol/server-github`), the process clears `PYTHONPATH` explicitly to prevent python library collisions between parent agent environments and sandboxed Nix store packages.
* **Declarative Skin Generation & Sync:** To keep user-space TUI sessions and the background system service perfectly synchronized, the repository programmatically generates the matching **TokyoNight Storm** skin YAML file from an inline Nix attribute set using `pkgs.lib.generators.toYAML`. This is written via `pkgs.writeText` and symlinked using a systemd `L+` rule:
  ```nix
  systemd.tmpfiles.rules = let
    themeContent = pkgs.lib.generators.toYAML {} {
      name = "tokyonight-storm";
      colors = {
        banner_border = "#414868";
        banner_title = "#7aa2f7";
        # ...
      };
      branding = { ... };
    };
    themeFile = pkgs.writeText "tokyonight-storm.yaml" themeContent;
  in [
    "d /var/lib/hermes/.hermes/skins 0775 hermes hermes - -"
    "L+ /var/lib/hermes/.hermes/skins/tokyonight-storm.yaml - - - - ${themeFile}"
  ];
  ```

```nix
# system/hermes.nix
services.hermes-agent = {
  enable = true;
  settings = {
    model.default = "gemini-flash-latest";
    model.provider = "gemini";
    display = {
      interface = "tui";
      skin = "tokyonight-storm";
    };
  };
  mcpServers = {
    nixos = {
      command = "nix";
      args = [ "run" "github:utensils/mcp-nixos" "--" ];
      env = { PYTHONPATH = ""; }; # Crucial Python sandbox mitigation
    };
    github = {
      command = "nix";
      args = [ "shell" "nixpkgs#nodejs" "-c" "npx" "-y" "@modelcontextprotocol/server-github" ];
    };
    context7 = {
      command = "nix";
      args = [ "shell" "nixpkgs#nodejs" "-c" "npx" "-y" "@upstash/context7-mcp@latest" ];
    };
    rust-analyzer = {
      command = "rust-analyzer-mcp";
      args = [];
    };
  };
};
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

### 4. 🦊 Unfree Extensions & Zen Browser Integration via Standalone Firefox Overlay
Managing browser extensions declaratively (such as dark themes, ad blockers, or password managers) often crashes during evaluation if an extension has an "unfree" proprietary license. This occurs even if `allowUnfree` is enabled on the host, because external flake inputs evaluate packages in isolated, sandbox states.

This repository resolves this issue by declaring Robert Helgesson's `firefox-addons` input and grafting it directly onto the host's `nixpkgs.overlays`. This pulls the addon libraries directly into the system's global `pkgs` context, where the system-wide `allowUnfree = true` can successfully validate proprietary licenses:

```nix
# system/nix-settings.nix
{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.firefox-addons.overlays.default # Graft addons into global pkgs
  ];
}
```

This lets us declaratively manage **Zen Browser** (via its custom flake input `inputs.zen-browser`) using the standard `programs.firefox` Home Manager module, while successfully grafting unfree extensions:

```nix
# users/sintra/programs/firefox.nix
{ config, pkgs, inputs, lib, ... }: {
  programs.firefox = {
    enable = true;
    package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      extensions.packages = with pkgs.firefox-addons; [
        dashlane
        darkreader
        vimium
      ];
    };
  };

  # Symlink ONLY the default profile folder to keep profiles.ini fully writable on disk!
  home.file.".config/zen/default".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/mozilla/firefox/default";
}
```
This elegant setup gives us a modern, fast, and secure browser with perfectly synced extensions without a single license evaluation error.
