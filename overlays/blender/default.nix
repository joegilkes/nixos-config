{ channels, ... }:

final: prev: {
  inherit (channels.blender-fix) blender blender-fix;
}