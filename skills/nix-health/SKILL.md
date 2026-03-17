---
name: nix-health
description: Use this when diagnosing or fixing a user's Nix installation — checks flakes, version, caches, max-jobs, direnv, rosetta, trusted-users, and shell config
---

# Nix Health Checks

Run these checks to diagnose problems with a Nix installation. For each failing check, report the issue and suggestion to the user.

## 1. Flakes Enabled

```sh
nix config show 2>/dev/null | grep '^experimental-features'
```

Value must contain both `flakes` and `nix-command`. If missing:
- **Suggestion**: See https://nixos.wiki/wiki/Flakes#Enable_flakes

## 2. Nix Version

```sh
nix --version
```

Version must be ≥ 2.16.0. If older:
- **Suggestion**: See https://nixos.asia/en/howto/nix-package

## 3. Max Jobs

```sh
nix config show 2>/dev/null | grep '^max-jobs'
```

Value must be > 1 (ideally `auto`). If set to 1:
- **Suggestion**: Set `max-jobs = auto` in `/etc/nix/nix.conf` (Linux) or `~/.config/nix/nix.conf` (macOS without nix-darwin). On NixOS use `nix.settings.max-jobs = "auto"`. On nix-darwin use the same option.

## 4. Caches

```sh
nix config show 2>/dev/null | grep '^substituters'
```

Must include `https://cache.nixos.org`. If the project specifies additional caches (e.g. Cachix), verify those too.
- **Suggestion**: Add missing caches to nix.conf `substituters`. For Cachix caches run `nix run nixpkgs#cachix use <name>`.

## 5. Trusted Users

```sh
nix config show 2>/dev/null | grep '^trusted-users'
whoami
```

The current user (or a group they belong to, or `*`) should appear in `trusted-users`. If missing:
- On NixOS: `nix.settings.trusted-users = [ "root" "<user>" ];`
- Otherwise: add `trusted-users = root <user>` to `/etc/nix/nix.conf` and restart the daemon (`sudo pkill nix-daemon`)

## 6. Direnv

```sh
which direnv 2>/dev/null && readlink -f "$(which direnv)"
```

Direnv should be installed and its resolved path should be inside `/nix/store/`. If not installed or installed outside Nix:
- **Suggestion**: Install direnv via Nix (home-manager). See https://github.com/juspay/nixos-unified-template

## 7. Rosetta (macOS only)

Only check on Apple Silicon Macs:
```sh
sysctl -n sysctl.proc_translated 2>/dev/null
```

If the value is `1`, Nix is running under Rosetta emulation which slows builds:
- **Suggestion**: Disable Rosetta for your terminal (Finder → Get Info → uncheck "Open using Rosetta"). Uninstall and reinstall Nix for `aarch64-darwin`. See https://nixos.asia/en/install

## 8. Shell Dotfiles

Check if shell config files are managed by Nix. For each dotfile that exists, resolve its real path — it should point into `/nix/store/`:
```sh
# For zsh:
for f in ~/.zshrc ~/.zshenv ~/.zprofile ~/.zlogin ~/.zlogout; do
  [ -e "$f" ] && echo "$f -> $(python3 -c "import os; print(os.path.realpath('$f'))")"
done
# For bash:
for f in ~/.bashrc ~/.bash_profile ~/.profile; do
  [ -e "$f" ] && echo "$f -> $(python3 -c "import os; print(os.path.realpath('$f'))")"
done
```

Any dotfile whose resolved path is **not** under `/nix/store/` is unmanaged — flag it as ⚠️.
- **Suggestion**: Use home-manager to manage shell configuration. See https://github.com/juspay/nixos-unified-template

## Reporting

Present results as a table with columns: Check, Status (✅/❌/⚠️), Details, and Suggestion (if failing). Mark checks that don't apply to the current OS as skipped.
