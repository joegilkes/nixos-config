{ stdenv, lib, fetchFromGitHub, kernel, kmod, patchutils, perlPackages }:
let

  media = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "linux_media";
    rev = "f52def659a416a4685b034eea3bd053605a13f71";
    hash = "sha256-Hvq5R17g7xfX5jz6vEVkFKZGrAYai7f/40HNGkCVjmM=";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "3ae3e7dec33570a2c9a31fdc97890dd23fae460f";
    hash = "sha256-DDZGTlCJm8Tfv1L+eNQxP0eqfONAz3I7Yym5mvVpd4w=";
  };

in
stdenv.mkDerivation {
  pname = "tbs";
  version = "20250125-${kernel.version}";

  srcs = [ media build ];
  sourceRoot = build.name;

  # https://github.com/tbsdtv/linux_media/wiki
  preConfigure = ''
    make dir DIR=../${media.name}
    make allyesconfig
    sed --regexp-extended --in-place v4l/.config \
      -e 's/(^CONFIG.*_RC.*=)./\1n/g' \
      -e 's/(^CONFIG.*_IR.*=)./\1n/g' \
      -e 's/(^CONFIG_VIDEO_VIA_CAMERA=)./\1n/g'
  '';

  postPatch = ''
    patchShebangs .

    sed -i v4l/Makefile \
      -i v4l/scripts/make_makefile.pl \
      -e 's,/sbin/depmod,${kmod}/bin/depmod,g' \
      -e 's,/sbin/lsmod,${kmod}/bin/lsmod,g'

    sed -i v4l/Makefile \
      -e 's,^OUTDIR ?= /lib/modules,OUTDIR ?= ${kernel.dev}/lib/modules,' \
      -e 's,^SRCDIR ?= /lib/modules,SRCDIR ?= ${kernel.dev}/lib/modules,'
  '';

  buildFlags = [ "VER=${kernel.modDirVersion}" ];
  installFlags = [ "DESTDIR=$(out)" ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ patchutils kmod perlPackages.ProcProcessTable ]
    ++ kernel.moduleBuildDependencies;

  postInstall = ''
    find $out/lib/modules/${kernel.modDirVersion} -name "*.ko" -exec xz {} \;
  '';

  meta = with lib; {
    homepage = "https://www.tbsdtv.com/";
    description = "Linux driver for TBSDTV cards";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ck3d ];
    priority = -1;
    broken = kernel.kernelOlder "4.14" || kernel.kernelAtLeast "6.12";
  };
}
