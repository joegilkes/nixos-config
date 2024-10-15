{
  lib,
  fetchFromGitHub,
  flutter326,
  rustc,
  cargo,
  libsecret,
  jsoncpp,
  gst_all_1,
  libunwind,
  orc,
  ...
}:

let 
  pname = "saber";
  version = "0.24.3";
  # pubspecLock = lib.importJSON ./pubspec.lock.json;
in 
  flutter326.buildFlutterApplication {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "saber-notes";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-mWRUUY8kNbYbYbpgxhi3JLbVBWhJzSzguXj1S6HGwUs=";
    };

    gitHashes = {
      "json2yaml" = "sha256-Vb0Bt11OHGX5+lDf8KqYZEGoXleGi5iHXVS2k7CEmDw=";
    };

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    buildInputs = [
      rustc
      cargo
      libsecret.dev
      jsoncpp.dev
      gst_all_1.gstreamer.dev
      gst_all_1.gst-plugins-base.dev
      libunwind.dev
      orc.dev
    ];
  }