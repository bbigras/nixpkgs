{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, wlroots, wayland, wayland-protocols
, libX11, libGL, mpv }:

stdenv.mkDerivation rec {
  pname = "mpvpaper";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "GhostNaN";
    repo = pname;
    rev = version;
    sha256 = "d26ef39c542ca5c225ab846687b4bf0857074237a2c921a7edbc4d39bfd21b5e";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayland
    wayland-protocols
    # libX11 # required by libglvnd
    libGL
    mpv
  ];

  meta = with stdenv.lib; {
    description =
      "Video wallpaper program for wlroots based wayland compositors";
    homepage = "https://github.com/GhostNaN/mpvpaper";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bbigras ];
  };
}
