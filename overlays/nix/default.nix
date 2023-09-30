{ channels, ... }:

final: prev: {
  inherit (channels.stable) nix;
}