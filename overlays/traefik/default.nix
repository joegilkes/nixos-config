{ channels, ... }:

final: prev: {
  inherit (channels.stable) traefik;
}
