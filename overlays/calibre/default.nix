{ channels, ... }:

# Problems building Calibre on unstable due to version of pyqt6
# See https://github.com/NixOS/nixpkgs/issues/348845 and https://github.com/NixOS/nixpkgs/pull/348697 for info

final: prev: {
  inherit (channels.stable) calibre;
}
