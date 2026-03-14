{ skillsSrc }:

{ lib, ... }:

let
  # Auto-discover skill directories containing SKILL.md
  allSkillDirs = lib.filterAttrs
    (_: type: type == "directory")
    (builtins.readDir skillsSrc);

  skillsAttr = lib.listToAttrs (
    lib.concatMap
      (name:
        if builtins.pathExists (skillsSrc + "/${name}/SKILL.md")
        then [ (lib.nameValuePair name (skillsSrc + "/${name}")) ]
        else [ ])
      (builtins.attrNames allSkillDirs)
  );
in
skillsAttr
