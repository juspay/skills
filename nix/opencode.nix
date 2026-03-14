# OpenCode home-manager module
# Just import this — no options needed.
{ skillsSrc }:

{ lib, ... }:

let
  skills = import ./discover-skills.nix { inherit skillsSrc; } { inherit lib; };
in
{
  programs.opencode.enable = true;
  programs.opencode.skills = skills;
}
