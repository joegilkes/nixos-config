{ lib
, stdenv
, fetchFromGitHub
, fetchpatch

# buildtime
, makeWrapper
, pkg-config
, python3
, which

# runtime
, avahi
, bzip2
, dbus
, dtv-scan-tables
, ffmpeg_7
, gettext
, gnutar
, gzip
, libiconv
, openssl
, uriparser
, zlib
, libdvbcsa
, x264
, x265
, libvpx
, libopus
}:

let
  version = "4.3-unstable-2024-11-12";
in stdenv.mkDerivation {
  pname = "tvheadend";
  inherit version;

  src = fetchFromGitHub {
    owner = "tvheadend";
    repo = "tvheadend";
    rev = "653bd0400b4413db96b80c807f0f7524f9248adb";
    hash = "sha256-LvLBF3YEpcnk7HIJQ5IN+zqTAh440PqxruSF/aDBojM=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
    which
  ];

  buildInputs = [
    avahi
    bzip2
    dbus
    ffmpeg_7
    gettext
    gzip
    libiconv
    openssl
    uriparser
    zlib
    libdvbcsa
    x264
    x265
    libvpx
    libopus
  ];

  enableParallelBuilding = true;

  configureFlags = [
    # disable dvbscan, as having it enabled causes a network download which
    # cannot happen during build.  We now include the dtv-scan-tables ourselves
    "--disable-dvbscan"
    "--disable-bintray_cache"
    "--disable-ffmpeg_static"
    # incompatible with our libhdhomerun version
    "--disable-hdhomerun_client"
    "--disable-hdhomerun_static"
    "--disable-libx264_static"
    "--disable-libx265_static"
    "--disable-libvpx_static"
    "--disable-libtheora_static"
    "--disable-libvorbis_static"
    "--disable-libfdkaac_static"
    "--disable-libmfx_static"
  ];

  preConfigure = ''
    substituteInPlace src/config.c \
      --replace-fail /usr/bin/tar ${gnutar}/bin/tar

    substituteInPlace src/input/mpegts/scanfile.c \
      --replace-fail /usr/share/dvb ${dtv-scan-tables}/share/dvbv5

    # the version detection script `support/version` reads this file if it
    # exists, so let's just use that
    echo ${version} > rpm/version
  '';

  postInstall = ''
    wrapProgram $out/bin/tvheadend \
      --prefix PATH : ${lib.makeBinPath [ bzip2 ]}
  '';

  meta = with lib; {
    description = "TV streaming server and digital video recorder";
    longDescription = ''
      Tvheadend is a TV streaming server for Linux supporting DVB-S,
      DVB-S2, DVB-C, DVB-T, ATSC, IPTV,SAT>IP and other formats
      through the unix pipe as input sources.
    '';
    homepage = "https://tvheadend.org";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simonvandel ];
    mainProgram = "tvheadend";
  };
}
