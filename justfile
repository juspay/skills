default:
    @just --list

oc_run := "nix --refresh run github:juspay/oc#oneclick --override-input skills . run"

# Launch opencode TUI with local skills
run:
    nix --refresh run github:juspay/oc#oneclick --override-input skills .

