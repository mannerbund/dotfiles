{
  stdenv,
  lib,
  fetchurl,
  nix-update-script,

  gnumake,
  gcc,
  zlib,
  libcap,
  libnetfilter_queue,
  libnfnetlink,
  libmnl,
  luajit,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zapret2";
  version = "0.9.4.5";

  src = fetchurl {
    url = "https://github.com/bol-van/zapret2/releases/download/v${finalAttrs.version}/zapret2-v${finalAttrs.version}.tar.gz";
    hash = "sha256-ipgSd7pzkwrvkjwb31+19wsK0YILw3ffL8hpwnJf0uo=";
  };

  buildInputs = [
    pkg-config
    gnumake
    gcc
    zlib
    libcap
    libnetfilter_queue
    libnfnetlink
    libmnl
    luajit
  ];

  unpackPhase = ''
    tar -xzf $src --strip-components=1
  '';

  preBuild = ''
    makeFlagsArray+=("CFLAGS=-DZAPRET_GH_VER=v${finalAttrs.version}")
  '';

  makeFlags = [ "TGT=${placeholder "out"}/bin" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/usr/share/zapret2/init.d/sysv
    mkdir -p $out/usr/share/docs

    cp blockcheck2.sh $out/bin/blockcheck2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/bol-van/zapret2";
    licence = lib.licenses.mit;
    description = "anti-dpi software";
    mainProgram = "zapret";
    platforms = lib.platforms.linux;
  };
})
