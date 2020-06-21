{ stdenv, fetchFromGitHub
, meson
, ninja
, wayland
, cairo
, pango
, gtk
, pkgconfig
, cmake
, scdoc
, libnotify
, gio-sharp
, glibc
}:

stdenv.mkDerivation rec {
  name = "swappy-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jtheoof";
    repo = "swappy";
    rev = "v${version}";
    sha256 = "1dk5q1f71n5zs2xximpwi2jfdznqwvjrprxi7clqc077nqv48s1j";
  };

  nativeBuildInputs = [ glibc.dev ];

  buildInputs = [ meson ninja pkgconfig cmake scdoc gio-sharp libnotify gtk pango cairo wayland];

  meta = {
    homepage = "https://github.com/jtheoof/swappy";
    description = "A Wayland native snapshot editing tool, inspired by Snappy on macOS ";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
