{ channels, ... }:

final: prev: {
  inherit (channels.master) liquidctl;
}