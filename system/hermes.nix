{ config, pkgs, ... }:

{
  # System Services & Integrations
  services.hermes-agent = {
    enable = true;
    settings = {
      model.default = "gemini-flash-lite-latest";
      display = {
        interface = "tui";
        tui_auto_resume_recent = true;
        skin = "tokyonight-storm";
      };
    };
    mcpServers = {
      nixos = {
        command = "nix";
        args = [ "run" "github:utensils/mcp-nixos" "--" ];
        env = {
          PYTHONPATH = "";
        };
      };
      github = {
        command = "nix";
        args = [ "run" "nixpkgs#nodejs" "--" "npx" "-y" "@modelcontextprotocol/server-github" ];
      };
      context7 = {
        command = "nix";
        args = [ "run" "nixpkgs#nodejs" "--" "npx" "-y" "@upstash/context7-mcp@latest" ];
      };
    };
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };

  # Deploy Hermes custom theme into its system-wide directory
  systemd.tmpfiles.rules = [
    "d /var/lib/hermes/.hermes/skins 0775 hermes hermes - -"
    "f+ /var/lib/hermes/.hermes/skins/tokyonight-storm.yaml 0664 hermes hermes - ${builtins.readFile ../users/sintra/programs/tokyonight-storm.yaml}"
  ];

  # Inject core packages into the systemd service PATH so it can run Nix and Node MCP servers
  systemd.services.hermes-agent.path = [ pkgs.nix pkgs.git pkgs.nodejs ];
}
