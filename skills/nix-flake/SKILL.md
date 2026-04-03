---
name: nix-flake
description: Use this when writing or editing a flake.nix. Covers flake-parts, perSystem, formatter, shell scripts, and package conventions.
---

# Nix Flake Development with flake-parts

All flakes use [flake-parts](https://flake.parts) with `perSystem` for per-architecture outputs.

## Formatter

Always set `formatter = pkgs.nixpkgs-fmt`.

## Shell scripts

Use `pkgs.writeShellApplication` (not `writeShellScriptBin`). It enables strict mode and validates `runtimeInputs` at build time. Always add `meta.description`.

## Key conventions

- Keep `flake.nix` minimal — delegate definitions to individual `.nix` files and import them.
- `perSystem` for per-architecture outputs (packages, devShells, checks, formatter).
- `flake` (top-level) for arch-independent outputs (nixosConfigurations, lib, overlays).
- Add `meta.description` to every package or script.

## Language-specific templates

### Haskell

Use [haskell-template](https://github.com/srid/haskell-template). Key inputs: `haskell-flake`, `nixos-unified`, `fourmolu-nix`. The `flake.nix` delegates entirely to `nixos-unified` autowiring, which auto-imports `./nix/modules/flake/*.nix`.

### Rust

Use [rust-nix-template](https://github.com/srid/rust-nix-template). Key inputs: `rust-flake`, `process-compose-flake`. The `flake.nix` auto-imports all files under `./nix/modules/*.nix` using `builtins.readDir`.

### Home Manager, nix-darwin, NixOS

Use [nixos-unified-template](https://github.com/juspay/nixos-unified-template). Key inputs: `home-manager`, `nix-darwin`, `nixos-unified`. Also uses `nixos-unified` autowiring.

## Dev services

- [`process-compose-flake`](https://github.com/Platonic-Systems/process-compose-flake): runs multi-process dev environments (backends, watchers, etc.) via `process-compose` integrated into a `devShell`.
- [`services-flake`](https://github.com/juspay/services-flake): built on top of `process-compose-flake`; provides ready-made service modules (PostgreSQL, Redis, etc.) for use in dev shells.

## Testing pattern

Isolate tests in `test/flake.nix` to avoid polluting parent. No top-level flake needed — test flake can reference parent content directly:
```nix
configDir = builtins.path { path = ./..; name = "config"; };
```
Use `pkgs.testers.nixosTest` for NixOS VM tests.
