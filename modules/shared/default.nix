{ config, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;

      # TODO: Add symlink to all applications installed on OS X
      packageOverrides = pkgs: {
        maccy = pkgs.maccy.overrideAttrs (oldAttrs: {
          postBuild = ''
            echo "Package installed out $out"
          '';
        });
      };

    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let path = ../../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))

      ++ [];
  };
}
