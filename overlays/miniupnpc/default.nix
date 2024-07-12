{ channels, ... }:

# Temporary fix for https://github.com/NixOS/nixpkgs/issues/326299 until it hits unstable.
final: prev: {
  inherit (channels.sunshine-fix) miniupnpc;
}
