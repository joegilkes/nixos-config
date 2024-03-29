{ channels, ... }:

final: prev: {
  android-tools = prev.android-tools.overrideAttrs (previousAttrs: {
    version = "34.0.5";
    src = prev.fetchurl {
      url = "https://github.com/nmeum/android-tools/releases/download/34.0.5/android-tools-34.0.5.tar.xz";
      hash = "sha256-+wnP8Sz7gqz0Ko6+u8A0JnG/zQIRdxY2i9xz/dpgMEo=";
    };
  });
}