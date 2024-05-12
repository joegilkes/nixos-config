{ channels, ... }:

final: prev: {
  gnome = prev.gnome.overrideScope (gfinal: gprev: {
    mutter = gprev.mutter.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        (prev.fetchpatch {
          url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/d6fb713cd22abeca146a983e7251f1aebc6f2693.patch";
          hash = "sha256-GKT9nzaYhuF+5PDgfBmqlZrHxfjiDV7XAMOPv+uauYs=";
        })
      ];
    });
  });
}

# Temporary fix for https://github.com/NixOS/nixpkgs/issues/309579
# Future note: mutter is inside a scope and is not directly installed, so
# overlaying it directly does nothing. 
# See https://wiki.nixos.org/wiki/Overlays#Overriding_a_package_inside_a_scope