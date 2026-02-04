#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl zon2nix nixfmt gnugrep

latest_rev=$(grep -oP 'rev = "\K\w+(?=")' package.nix)

curl -O "https://raw.githubusercontent.com/nmeum/creek/${latest_rev}/build.zig.zon";
zon2nix build.zig.zon >build.zig.zon.nix
nixfmt build.zig.zon.nix

rm -f build.zig.zon
