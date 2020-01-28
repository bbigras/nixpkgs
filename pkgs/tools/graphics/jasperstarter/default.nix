{ stdenv, fetchurl, fetchzip, intltool, libxml2, gmime, nss, jdk, makeWrapper, maven }:

stdenv.mkDerivation rec {
  pname = "jasperstarter";
  version = "3.5.0";

  # src = fetchurl {
    # url = "mirror://sourceforge/jasperstarter/${pname}-${version}.tar.gz";
    # sha256 = "1111111111111111111111111111111111111111111111111111";
  # };

  src = fetchzip {
    url = "https://bitbucket.org/cenote/jasperstarter/get/JasperStarter-${version}.tar.bz2";
    # url = "https://bitbucket.org/cenote/jasperstarter/get/v${version}.tar.gz";
    sha256 = "15d6spph455201asbxwkwhi6j9zcw2haz3n2891p2ygvvh4262q0";
  };

  buildInputs = [ jdk makeWrapper maven ];

  buildPhase = ''
    mvn package --offline -P release
  '';

  # nativeBuildInputs = [ intltool ];
  # buildInputs = [ pidgin gmime libxml2 nss ];
  # enableParallelBuilding = true;

  # postInstall = "ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  meta = with stdenv.lib; {
    # description = "SIPE plugin for Pidgin IM";
    # homepage = "http://sipe.sourceforge.net/";
    # license = licenses.gpl2;
    # platforms = platforms.linux;
  };
}
