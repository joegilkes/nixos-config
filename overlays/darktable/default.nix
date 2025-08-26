{ channels, ... }:

# osm-gps-map is broken doe to a bunch of deprecations around libsoup
# See https://github.com/NixOS/nixpkgs/pull/436257
final: prev: {
  inherit (channels.darktable-fix) osm-gps-map;
}