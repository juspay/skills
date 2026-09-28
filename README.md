# skills

**Juspay's skill pack for coding agents.** Skills for Nix, writing, and
tooling, plus a NixOS lookup server, packaged once as an
[Agent Plugin](https://agent-plugins.org/) and loadable by Oh My Pi, Codex, and
Claude Code.

```sh
AI_PROFILE=juspay nix run github:juspay/agent-distro
```

That runs the agent of your choice with everything here preloaded, through
[agent-distro](https://github.com/juspay/agent-distro). To add the pack to an
agent you already have, see [Install](#install).

<img width="549" height="503" alt="image" src="https://github.com/user-attachments/assets/95f1ac62-fd85-422f-93e5-918042bff00d" />

## What's inside

### Nix

| Skill | Description |
|-------|-------------|
| [`nix-bun`](./skills/nix-bun/SKILL.md) | Bun + Nix via bun2nix — bun.nix dependency workflow, the `bun --compile` pitfall, CI drift check |
| [`nix-ci`](./skills/nix-ci/SKILL.md) | CI setup for GitHub repos — GitHub Actions or Vira |
| [`nix-for-dev`](./skills/nix-for-dev/SKILL.md) | Fast `nix develop` setup — zero-inputs `flake.nix`, npins, sub-flakes for non-user-facing Nix |
| [`nix-haskell`](./skills/nix-haskell/SKILL.md) | Haskell projects with haskell-flake: dependencies, settings, devShell, autoWire |
| [`nix-health`](./skills/nix-health/SKILL.md) | Diagnosing Nix installation health — flakes, version, caches, max-jobs, direnv, and shell config |
| [`nix-justfile`](./skills/nix-justfile/SKILL.md) | Conventions for writing justfile recipes in Nix-based projects |
| [`nix-oss-cache`](./skills/nix-oss-cache/SKILL.md) | Set up a GitHub repo to push Nix builds to Juspay's shared OSS Attic cache (`cache.nixos.asia/oss`) |
| [`nix-perf`](./skills/nix-perf/SKILL.md) | Diagnosing slow first-fetch (`direnv allow` / `nix flake archive`) — lockfile inspection, `follows` patterns, and cold-fetch measurement |
| [`nix-playwright`](./skills/nix-playwright/SKILL.md) | Run an existing Playwright e2e suite locally on NixOS via `tests/shell.nix` + justfile |
| [`nix-rust-leptos`](./skills/nix-rust-leptos/SKILL.md) | Conventions for building Leptos CSR apps with Nix (crane + Trunk) |
| [`nix-typescript`](./skills/nix-typescript/SKILL.md) | pnpm + Nix build conventions — fetchPnpmDeps hash management and dependency workflow |

### Writing

| Skill | Description |
|-------|-------------|
| [`pg`](./skills/pg/SKILL.md) | Write essays, articles, and blog posts in Paul Graham's voice — plain, spoken prose that reasons out loud, not AI filler |
| [`programming-essay`](./skills/programming-essay/SKILL.md) | Write programming essays in the voice of the canon — Spolsky, Yegge, Graham, Nystrom, Brooks |

### Tooling

| Skill | Description |
|-------|-------------|
| [`cargo-watch`](./skills/cargo-watch/SKILL.md) | Run cargo-watch in the background for continuous clippy feedback during code editing |
| [`vhs`](./skills/vhs/SKILL.md) | Deterministic terminal demo screencasts with VHS and wait patterns |
| [`waterfall`](./skills/waterfall/SKILL.md) | Implement anything end-to-end using two agents: a planner cum reviewer and an implementer. Requires [Kolu](https://kolu.dev) |

### MCP servers

| Server | Description |
|--------|-------------|
| `nixos` | [mcp-nixos](https://github.com/utensils/mcp-nixos) — look up packages, versions, and NixOS / Home Manager options instead of guessing them |

The server is declared in [`mcp.json`](./mcp.json) by bare command, so it
needs `mcp-nixos` on `PATH`. [agent-distro](https://github.com/juspay/agent-distro)'s
`juspay` profile supplies it, prebuilt; elsewhere, install it yourself, for
example with `nix profile install nixpkgs#mcp-nixos`. Without it the server
fails to start and the skills load as usual.

## Install

This repository is an Agent Plugins package
([spec 1.0.0](https://agent-plugins.org/specification/)): `plugin.json` at the
root, a skill in each `skills/<name>/SKILL.md`, and MCP servers in `mcp.json`.
Any client that implements the standard can load it as is.

It is also a plugin marketplace: the catalogs at `.omp-plugin/marketplace.json`
and `.claude-plugin/marketplace.json` list the repo root as the `juspay-skills`
plugin.

| Client | How |
|--------|-----|
| Any of Oh My Pi, Codex, Claude Code | `AI_PROFILE=juspay nix run github:juspay/agent-distro` |
| Oh My Pi | `omp plugin marketplace add juspay/skills`, then `omp plugin install juspay-skills@juspay` |
| Claude Code | `/plugin marketplace add juspay/skills`, then `/plugin install juspay-skills@juspay` |
| Another Agent Plugins client | Point it at a checkout of this repo |
| OpenCode | `nix run github:juspay/AI` ([juspay/AI](https://github.com/juspay/AI) bundles these skills via APM) |

### Oh My Pi

The same two commands work inside a session as `/marketplace add juspay/skills`
and `/marketplace install juspay-skills@juspay`. To use a local checkout
without installing:

```bash
omp -e /path/to/skills
```

Every skill becomes available as `/skill:<name>`. Run `/reload-plugins` to pick
up changes without restarting the session.

### Individual skills with APM

[APM](https://microsoft.github.io/apm/) installs skills one at a time, for
Claude Code, Cursor, and Copilot, using virtual subdirectory references:

```yaml
# apm.yml
dependencies:
  apm:
    - juspay/skills/skills/nix-for-dev
    - juspay/skills/skills/nix-haskell
    - juspay/skills/skills/nix-ci
```

```bash
apm install
```

Each skill is a standalone package, so pick only what your project needs. See
[Kolu's `apm.yml`](https://github.com/juspay/kolu/blob/master/apm.yml) for an
example.

### Manual

Copy any `skills/<name>/SKILL.md` into your agent's skills directory, for
example `.claude/skills/<name>/SKILL.md` for Claude Code.

## Contributing

See [AGENTS.md](./AGENTS.md) for the skill format and rules. When adding a
skill, add it to the tables above.
