default:
    @just --list


# Run opencode with local skills, e.g.: just run "Check the health of my Nix install"
run msg="Check the health of my Nix install":
    nix --refresh run github:juspay/oc#oneclick --override-input skills . run "{{msg}}"
