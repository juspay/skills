---
name: nix-haskell
description: Use this when working on a Haskell project with Nix. Covers haskell-flake setup, adding/overriding dependencies, package settings, and devShell configuration.
---

# Haskell + Nix with haskell-flake

Use [haskell-flake](https://github.com/srid/haskell-flake) — a flake-parts module. Start from [haskell-template](https://github.com/srid/haskell-template). Requires a `.cabal` or `cabal.project` file; haskell-flake scans for it automatically.

## Basic setup

Import `inputs.haskell-flake.flakeModule` and configure `haskellProjects.default` inside `perSystem`.

## Adding / overriding dependencies

Inside `haskellProjects.default.packages`:

- **From a flake input (Git):** `ema.source = inputs.ema;` (add `ema.flake = false` in inputs)
- **From Hackage:** `ema.source = "0.8.2.0";`
- **From a monorepo input:** `foo.source = inputs.myrepo + /foo;`
- **Specific nixpkgs version:** use `settings.<name>.custom = _: super.pkg_version;`

## Package settings (overrides)

`haskellProjects.default.settings.<name>` maps to `pkgs.haskell.lib` functions:

- `check = false` → disables test suite (`dontCheck`)
- `jailbreak = true` → relaxes version bounds (`doJailbreak`)
- `custom = drv: drv.overrideAttrs (o: { ... })` → arbitrary override

Full list: [settings/all.nix](https://github.com/srid/haskell-flake/blob/master/nix/modules/project/settings/all.nix)

## devShell

Compose the haskell-flake devShell into your own shell via `inputsFrom`:

```nix
devShells.default = pkgs.mkShell {
  inputsFrom = [ config.haskellProjects.default.outputs.devShell ];
  packages = [ pkgs.just ];
};
```

## autoWire

Controls which outputs haskell-flake wires automatically:

```nix
autoWire = [ "packages" "apps" "checks" ]; # omit "devShells" to manage it yourself
```

## Docs

- Full guide: https://community.flake.parts/haskell-flake
- Module options: https://flake.parts/options/haskell-flake
