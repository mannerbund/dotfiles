{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  zig_0_15,
  wayland,
  wayland-scanner,
  wayland-protocols,
  pkg-config,
  pixman,
  fcft,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "creek";
  version = "0.4.3-unstable-2025-08-22";

  src = fetchFromGitHub {
    owner = "nmeum";
    repo = "creek";
    rev = "e30eae05ab0d0ec43c18816cf9bcf1150b3c3b61";
    hash = "sha256-34l0w6ftCjMEpZwI1JSK+kNkH4PHthhGKmnMh63m3GU=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  nativeBuildInputs = [
    zig_0_15
    wayland-scanner
    pkg-config
  ];

  buildInputs = [
    pixman
    wayland
    fcft
    wayland-protocols
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    homepage = "https://github.com/nmeum/creek";
    licence = lib.licenses.mit;
    longDescription = ''
      Creek is a dwm-inspired malleable and minimalist status bar for the River Wayland compositor. The implementation is a hard fork of version 0.1.3 of the levee status bar. Compared to levee, the main objective is to ease recombination and reuse by providing a simpler interface for adding custom information to the status bar. The original version of levee only provides builtin support for certain modules, these have to be written in Zig and compiled into levee. This fork pursues an alternative direction by allowing arbitrary text to be written to standard input of the status bar process, this text is then displayed in the status bar.
    '';
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
