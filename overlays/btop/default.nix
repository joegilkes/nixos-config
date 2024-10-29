{ channels, ... }:

final: prev: {
  btop-rocm = prev.btop.override { rocmSupport = true; };
}
