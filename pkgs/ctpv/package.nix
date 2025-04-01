{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  file,
  openssl,
  atool,
  bat,
  chafa,
  delta,
  ffmpeg,
  ffmpegthumbnailer,
  fontforge,
  glow,
  imagemagick,
  jq,
}:
stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3BQi4m44hBmPkJBFNCg6d9YKRbDZwLxdzBb/NDWTQP4=";
  };

  nativeBuildInputs = [makeWrapper];

  buildInputs = [
    file # libmagic
    openssl
  ];

  patches = [./chafa.patch];

  makeFlags = ["PREFIX=$(out)"];

  preFixup = ''
    wrapProgram $out/bin/ctpv \
      --prefix PATH ":" "${
      lib.makeBinPath [
        atool # for archive files
        bat
        chafa # for image files on Wayland
        delta # for diff files
        ffmpeg
        ffmpegthumbnailer
        fontforge
        glow # for markdown files
        imagemagick
        jq # for json files
      ]
    }";
  '';
}
