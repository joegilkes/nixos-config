{ channels, ... }:

# Temporary fix for https://github.com/NixOS/nixpkgs/issues/325907 until it hits unstable.
final: prev: {
  inherit (channels.master) rocmPackages;
}
