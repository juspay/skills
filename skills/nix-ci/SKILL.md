---
name: nix-ci
description: Use this when setting up CI for a GitHub repository — offers GitHub Actions or Vira depending on the project
---

# CI Setup

When the user asks to set up CI, use the **Ask tool** to prompt them to choose:

1. **GitHub public runners** — CI via GitHub Actions
2. **Vira self-hosted** — self-hosted CI using [Vira](https://vira.nixos.asia)

## Option 1: GitHub Actions

Use the [install-nix](https://github.com/nixbuild/nix-quick-install-action) action (avoid DetSys actions) and invoke Vira to build:

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: nixbuild/nix-quick-install-action@v34
      - run: nix profile install github:juspay/vira
      - run: vira ci
```

### Caching the Nix store (plain `nix build`, no Vira)

When building directly with `nix build` on GitHub runners (instead of `vira ci`), cache `/nix/store` across runs with [`cache-nix-action`](https://github.com/nix-community/cache-nix-action). Otherwise every run re-fetches all dependency tarballs and rebuilds the whole closure — easily 30 min for a large app. With a warm cache the build job drops to ~1 min (dominated by the restore).

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      actions: write          # REQUIRED — see gotcha 2 below
    steps:
      - uses: actions/checkout@v4
      - uses: nixbuild/nix-quick-install-action@v34
      - uses: nix-community/cache-nix-action@v6
        with:
          primary-key: nix-${{ runner.os }}-${{ hashFiles('flake.lock', '**/flake.nix') }}
          restore-prefixes-first-match: nix-${{ runner.os }}-
          gc-max-store-size-linux: 5G   # keep under the 10 GB repo cache limit
          purge: true
          purge-prefixes: nix-${{ runner.os }}-
          purge-last-accessed: 604800
          purge-primary-key: never
      - run: nix build -L
```

Two gotchas, each of which makes the cache **silently no-op** (save/restore complete in ~1s and nothing is cached):

1. **`cache-nix-action` must pair with `nix-quick-install-action`, not the DeterminateSystems installer.** The DetSys daemon-based store layout isn't snapshotted by the cache action. (This is the concrete reason for "avoid DetSys actions" above.)
2. **`purge: true` requires `actions: write` permission.** Without it the save aborts with `Resource not accessible by integration` (it calls the REST cache API to purge stale entries) and no `nix-*` cache is ever created.

Verify it worked: `gh cache list` should show a `nix-*` entry sized in the hundreds-of-MB-to-GB range — not just the installer's own ~40 MB cache.

## Option 2: Vira Self-Hosted

Vira is already running and pointed at the repo. Create a `vira.hs` file in the repo root to configure the build pipeline.

**Before generating `vira.hs`, you MUST fetch and read https://vira.nixos.asia/config to understand the exact DSL format. Do not guess the syntax.**

### Rules for generating `vira.hs`

- If the repo has a **git remote pointing to GitHub**, set `signoff.enable = True`
- If **multiple `flake.nix` files** exist (e.g., in subdirectories), add all of them to `build.flakes` with appropriate `overrideInputs` settings
- Leave `cache.url = Nothing` with a comment `-- TODO: configure Attic cache URL`
- Use the **Ask tool** to ask the user whether `build.systems` should be set to `["x86_64-linux", "aarch64-darwin"]` for multi-platform builds

After creating `vira.hs`, run `vira ci -b` to verify the configuration.

