{ channels, ... }:

final: prev: {
  inherit (channels.unstable) mesa;
}