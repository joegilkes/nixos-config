{ channels, ... }:

final: prev: {
  inherit (channels.unstable) nix;
}