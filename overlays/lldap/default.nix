{ channels, ... }:

# Temporary revert to previous version until v0.6.1 hits cache
final: prev: {
  inherit (channels.stable) lldap;
}
