{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl
, libiconv, xorg, libGLU, libGL, mesa, addOpenGLRunpath }:

rustPlatform.buildRustPackage rec {
  pname = "ArturKovacs";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "emulsion";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zyc8f4pzgyzssqzxv61cnpq524iksnavbzs3n6v8jyfrxn84hzl";
  };

  nativeBuildInputs = [ addOpenGLRunpath ] ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = [ xorg.libX11 xorg.libXcursor
xorg.libXrandr
xorg.libXi
libGLU libGL # glu?
mesa
 ] ++ stdenv.lib.optionals stdenv.isLinux [ openssl ];
  #   ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "0kp23bymsvg3318ysn2g52ddlgwfl3map8fc2wy31p2fflqvg71f";

  meta = with stdenv.lib; {
    description = "A fast and minimalistic image viewer";
    homepage = "https://arturkovacs.github.io/emulsion-website/";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
