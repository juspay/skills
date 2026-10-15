{
  name = "juspay";
  description = "Juspay skills + Kolu, via Juspay's LiteLLM gateway";
  # This repository, and Kolu's plugin, resolved by the launcher at each launch.
  plugins = [ ./. "github:juspay/kolu?dir=agent-plugin" ];
  # Commands the plugins' MCP servers name, from agent-distro's nixpkgs.
  # mcp-nixos is not in the binary cache for darwin or aarch64-linux yet, see juspay/agent-distro#83.
  packages = pkgs: pkgs.lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [ pkgs.mcp-nixos ];
  # Exported before the harness starts: LITELLM_API_KEY is asked for when it is
  # not already set, and never written to a file.
  env = {
    LITELLM_BASE_URL = "https://grid.ai.juspay.net";
    OMP_SKIP_SETUP = "1";
    LITELLM_API_KEY = { secret = true; hint = "Create a key at grid.ai.juspay.net/dashboard (Juspay VPN)"; };
  };
  # What OMP and OpenCode start with: the gateway's models, through OMP's own
  # provider and OpenCode's vendored plugin. Neither replaces a model you chose
  # yourself.
  settings = {
    omp.modelRoles = {
      default = "litellm/open-large";
      slow = "litellm/open-large";
      task = "litellm/open-large";
      smol = "litellm/open-fast";
    };
    opencode = {
      providers.litellm = {
        package = "@opencode/ai/providers/openai-compatible";
        settings.baseURL = "https://grid.ai.juspay.net/v1";
      };
      model = "litellm/open-large";
      agents.title.model = "litellm/open-fast";
    };
  };
}
