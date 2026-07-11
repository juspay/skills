# skills

AI skill pack — reusable [SKILL.md](https://opencode.ai/docs/skills/) definitions for coding agents.

<img width="549" height="503" alt="image" src="https://github.com/user-attachments/assets/95f1ac62-fd85-422f-93e5-918042bff00d" />

## Skills

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

## Usage

### With APM (Claude Code, Cursor, Copilot)

Install individual skills using [APM](https://microsoft.github.io/apm/) virtual subdirectory references:

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

Each skill is a standalone package — pick only what your project needs. See [Kolu's `apm.yml`](https://github.com/juspay/kolu/blob/master/apm.yml) for an example.

### With OpenCode

[juspay/AI](https://github.com/juspay/AI) bundles these skills into its oneclick OpenCode packages via APM. Run `nix run github:juspay/AI` to get OpenCode with all skills pre-configured.

### Manual

Copy any `skills/<name>/SKILL.md` into your agent's skills directory (e.g., `.claude/skills/<name>/SKILL.md` for Claude Code).
