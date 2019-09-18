{ stdenv, fetchurl, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-gmusic";
  version = "3562ad4b07bf6c0801338db72cd0c6f0633a07af";

  src = fetchurl {
    url = "https://github.com/mopidy/mopidy-gmusic/archive/3562ad4b07bf6c0801338db72cd0c6f0633a07af.tar.gz";
    sha256 = "13ad9zxidnqb818ngi2h4rx38964r1pibdpzpqk2blflfvf6g8py";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.requests
    pythonPackages.gmusicapi
    pythonPackages.cachetools
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = "Mopidy extension for playing music from Google Play Music";
    license = licenses.asl20;
    maintainers = [ maintainers.jgillich ];
    hydraPlatforms = [];
  };
}
