default:
    @just --list

oc_run := "nix --refresh run github:juspay/oc#oneclick --override-input skills . run"

# Test nix-health skill, e.g.: just test-health "Check the health of my Nix install"
test-health msg="Check the health of my Nix install":
    {{oc_run}} "{{msg}}"

# Test nix-haskell skill: asks agent to create a Haskell project in .tmp/haskell-proj
test-haskell:
    rm -rf .tmp/haskell-proj
    mkdir -p .tmp/haskell-proj
    {{oc_run}} "Create a new Haskell project directly in .tmp/haskell-proj (put flake.nix and all files there, not in a subdirectory)"
    nix run path:.tmp/haskell-proj
