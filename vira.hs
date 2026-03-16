-- vira.hs
\ctx pipeline ->
  pipeline
    { signoff.enable = True
    , build.flakes = [".", "./nix/test" { overrideInputs = [("skills", ".")] }]
    , build.systems = ["x86_64-linux", "aarch64-darwin"]
    , cache.url = Nothing  -- TODO: configure Attic cache URL
    }
