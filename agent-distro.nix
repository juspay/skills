{
  name = "juspay";
  description = "Juspay skills + Kolu, via Juspay's LiteLLM gateway";
  # This repository, and Kolu's plugin, resolved by the launcher at each launch.
  plugins = [ ./. "github:juspay/kolu?dir=agent-plugin" ];
  # Commands the plugins' MCP servers name, from agent-distro's nixpkgs.
  # mcp-nixos is not in the binary cache for darwin or aarch64-linux yet, see juspay/agent-distro#83.
  packages = pkgs: pkgs.lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [ pkgs.mcp-nixos ];
  gateway = {
    url = "https://grid.ai.juspay.net";
    keyEnv = "LITELLM_API_KEY";
    models = { large = "open-large"; small = "open-fast"; };
    keyHint = "Requires Juspay VPN to access the dashboard";
  };
}
