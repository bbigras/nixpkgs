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
  version = "2020-02-26";

  src = fetchFromGitHub {
    owner = "jtheoof";
    repo = "swappy";
    rev = "b5cc433d75d77759cef139e0e232bde79196f886";
    sha256 = "08r9hmhzzb5ac4g6zwm7w05n99v0hl2h0w4d8i694hg4pyjxb95y";
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
