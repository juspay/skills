{
  name = "juspay";
  description = "Juspay skills + Kolu, via Juspay's LiteLLM gateway";
  plugins = [ ./. "github:juspay/kolu?dir=agent-plugin" ];
  packages = pkgs: [ pkgs.mcp-nixos ];
  env = {
    LITELLM_BASE_URL = "https://grid.ai.juspay.net";
    LITELLM_API_KEY = { secret = true; hint = "Create a key at grid.ai.juspay.net/dashboard (Juspay VPN)"; };
  };
  settings = {
    omp.modelRoles = { default = "litellm/open-large"; task = "litellm/open-large"; smol = "litellm/open-fast"; };
    opencode = { model = "litellm/open-large"; agents.title.model = "litellm/open-fast"; };
  };
}
