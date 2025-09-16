{ channels, ... }:

# Lix in nixpkgs temporarily broken, see https://github.com/NixOS/nixpkgs/pull/442624
# Tracking into unstable at https://nixpk.gs/pr-tracker.html?pr=442624

final: prev: {
  inherit (channels.lixfix) lixPackageSets;
}