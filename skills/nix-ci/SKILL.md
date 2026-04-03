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

## Option 2: Vira Self-Hosted

Vira is already running and pointed at the repo. Create a `vira.hs` file in the repo root to configure the build pipeline.

**Before generating `vira.hs`, you MUST fetch and read https://vira.nixos.asia/config to understand the exact DSL format. Do not guess the syntax.**

### Rules for generating `vira.hs`

- If the repo has a **git remote pointing to GitHub**, set `signoff.enable = True`
- If **multiple `flake.nix` files** exist (e.g., in subdirectories), add all of them to `build.flakes` with appropriate `overrideInputs` settings
- Leave `cache.url = Nothing` with a comment `-- TODO: configure Attic cache URL`
- Use the **Ask tool** to ask the user whether `build.systems` should be set to `["x86_64-linux", "aarch64-darwin"]` for multi-platform builds

After creating `vira.hs`, run `vira ci -b` to verify the configuration.

