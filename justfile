# Run opencode with skills from PWD
run msg="Check the health of my Nix install":
    nix --refresh run github:juspay/oc#oneclick --override-input skills . run "{{msg}}"
