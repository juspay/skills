# Claude Code home-manager module
# Just import this — no options needed.
{ skillsSrc }:

{ lib, ... }:

let
  skills = import ./discover-skills.nix { inherit skillsSrc; } { inherit lib; };
in
{
  programs.claude-code.enable = true;
  programs.claude-code.skills = skills;
}
